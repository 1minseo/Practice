# 10. 데이터 분석 애플리케이션 개발하기

load("C:/workspace/R_shiny/06_geodataframe/06_apt_price.rdata") #아파트 실거래 데이터
#install.packages("sf")
library(sf)

bnd <- st_read("C:/workspace/R_shiny/01_code/sigun_bnd/seoul.shp") #서울시 경계선
load("./07_map/07_kde_high.rdata") #최고가 래스터 이미지
load("./07_map/07_kde_hot.rdata") #급등 지역 래스터 이미지
grid <- st_read("C:/workspace/R_shiny/01_code/sigun_grid/seoul.shp") #서울시 1km 그리드

pcnt_10 <-as.numeric(quantile(apt_price$py, probs=seq(.1,.9, by=.1))[1]) #하위 10%
pcnt_90 <-as.numeric(quantile(apt_price$py, probs=seq(.1,.9, by=.1))[9]) #상위 10%
load("C:/workspace/R_shiny/01_code/circle_marker/circle_marker.rdata") #마커 클러스터링 함수
circle.colors <- sample(x=c("red","green","blue"), size=1000,replace = TRUE)

library(leaflet)
library(purrr)
library(raster)

leaflet() %>%
  addTiles(options=providerTileOptions(minZoom=9, maxZoom=18)) %>%
  addRasterImage(raster_high,
                 colors = colorNumeric(c("blue","green","yellow","red"), values(raster_high),
                                       na.color="transparent"),opacity = 0.4, group= "2021 최고가") %>% 
  addRasterImage(raster_hot,
                 colors = colorNumeric(c("blue","green","yellow","red"), values(raster_hot),
                                       na.color="transparent"),opacity = 0.4, group= "2021 급등지") %>% 
  addLayersControl(baseGroups = c("2021 최고가","2021 급등지"), #래스터이미지 레이어를 바꿀 수 있도록 변경스위치 추가
                   options = layersControlOptions(collapsed=FALSE)) %>%
  addPolygons(data=bnd, weight = 3, stroke=T, color="red", fillOpacity = 0) %>%  
  addCircleMarkers(data = apt_price, lng=unlist(map(apt_price$geometry,1)),
                   lat = unlist(map(apt_price$geometry,2)), radius = 10, stroke = FALSE,
                   fillOpacity=0.6, fillColor=circle.colors, weight=apt_price$py,
                   clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula)))
  
m <- leaflet() %>%
  addTiles(options=providerTileOptions(minZoom=9, maxZoom=18)) %>%
  addRasterImage(raster_high,
                 colors = colorNumeric(c("blue","green","yellow","red"), values(raster_high),
                                       na.color="transparent"),opacity = 0.4, group= "2021 최고가") %>% 
  addRasterImage(raster_hot,
                 colors = colorNumeric(c("blue","green","yellow","red"), values(raster_hot),
                                       na.color="transparent"),opacity = 0.4, group= "2021 급등지") %>% 
  addLayersControl(baseGroups = c("2021 최고가","2021 급등지"),
                   options = layersControlOptions(collapsed=FALSE)) %>%
  addPolygons(data=bnd, weight = 3, stroke=T, color="red", fillOpacity = 0) %>%  
  addCircleMarkers(data = apt_price, lng=unlist(map(apt_price$geometry,1)),
                   lat = unlist(map(apt_price$geometry,2)), radius = 10, stroke = FALSE,
                   fillOpacity=0.6, fillColor=circle.colors, weight=apt_price$py,
                   clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula)))
m

library(shiny)
#install.packages("mapedit")
library(mapedit)
ui <- fluidPage(
  selectModUI("selectmap"),
  "선택은 할 수 있지만 아무런 반응이 없습니다.")

server <- function(input, output) {
  callModule(selectMod,"selectmap",m)}
  
shinyApp(ui, server)

# 반응식을 추가한 샤이니와 맵어플리케이션 구현
ui <- fluidPage(
  selectModUI("selectmap"),
  textOutput("sel")
)
server <- function(input, output, session){
  df <- callModule(selectMod,"selectmap", m)
  output$sel <- renderPrint({df()[1]})
}
shinyApp(ui, server)

# 반응형 지도 애플리케이션 완성하기
library(DT)
library(shiny)
library(mapedit)
library(dplyr)
ui <- fluidPage(
  fluidRow(
    column( 9, selectModUI("selectmap"), div(style="height:45px")),
    column( 3,
           sliderInput("range_area","전용면적", sep="", min=0, max=350,
                       value = c(0,200)),
           sliderInput("range_time", "건축연도", sep="", min=1960, max=2020,
                       value = c(1980,2020)),),
    column(12, dataTableOutput(outputId = "table"), div(style="height:200px"))))

server <- function(input, output, session){
  apt_sel=reactive({
    apt_sel=subset(apt_price, con_year >= input$range_time[1] &
                     con_year <= input$range_time[2] & area >= input$range_area[1] &
                     area <= input$range_area[2])
  return(apt_sel)})
  
  g_sel <- callModule(selectMod,"selectmap",
    leaflet() %>%
    addTiles(options=providerTileOptions(minZoom=9, maxZoom=18)) %>% 
    addRasterImage(raster_high,
        colors = colorNumeric(c("blue","green","yellow","red"),
        values(raster_high), na.color="transparent"),opacity = 0.4,
        group = "2021 최고가") %>%
    addRasterImage(raster_hot,
        colors = colorNumeric(c("blue","green","yellow","red"),
        values(raster_hot), na.color="transparent"),opacity = 0.4,
        group = "2021 급등지") %>%
    addLayersControl(baseGroups = c("2021 최고가","2021 급등지"),
        options = layersControlOptions(collapsed=FALSE)) %>% 
    addPolygons(data=bnd, weight = 3, stroke = T, color = "red", fillOpacity = 0) %>% 
    addCircleMarkers(data=apt_price, lng=unlist(map(apt_price$geometry,1)),
        lat=unlist(map(apt_price$geometry,2)), radius = 10, stroke = FALSE,
        fillOpacity = 0.6, fillColor = circle.colors, weight = apt_price$py,
        clusterOptions = markerClusterOptions(iconCreateFunction=JS(avg.formula))) %>% 
    leafem::addFeatures(st_sf(grid), layerId= ~seq_len(length(grid)), color="grey"))
  
  rv <- reactiveValues(intersect=NULL, selectgrid=NULL) #반응 초깃값 설정(Null)
    observe({
      gs <- g_sel()
      rv$selectgrid <- st_sf(grid[as.numeric(gs[which(gs$selected==TRUE), "id"])])
      if(length(rv$selectgrid) > 0){
        rv$intersect <- st_intersects(rv$selectgrid, apt_sel())
        rv$sel <- st_drop_geometry(apt_price[apt_price[unlist(rv$intersect[1:10]),],])
      } else {
        rv$intersect <- NULL
      }
    })
    
    output$table <- DT::renderDataTable({ #renderDataTable로 필요한 컬럼만 추출 후 output$table로 전달
  dplyr::select(rv$sel, ymd, addr_1, apt_nm, price, area, floor, py) %>% 
  arrange(desc(py))}, extensions="Buttons", options=list(dom='Bfrtip',
  scrollY=300, scrollCollapse=T, paging=TRUE, buttons=c('excel'))) #엑셀파일로 저장                                          
}
shinyApp(ui, server)