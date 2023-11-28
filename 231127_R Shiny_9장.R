install.packages("shiny")
library(shiny)

ui <- fluidPage("사용자인터페이스") #사용자 인터페이스
server <- function(input, output, session){} #서버
shinyApp(ui, server) #실행

runExample("01_hello")

faithful <- faithful
head(faithful)

# 입력 input() -> 서버 server() -> 출력 output()
ui <- fluidPage(
  titlePanel("샤이니 1번 샘플"), #제목 입력
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins", #입력 아이디
                  label = "막대(bin) 개수:", #텍스트 라벨
                  min=1, max=50, #선택 범위(1~50)
                  value=30)), #기본값 30
      mainPanel(plotOutput(outputId = "distPlot")) #메인 패널 시작
  ))
  
server <- function(input, output, session){
  output$distPlot <- renderPlot({
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out=input$bins + 1)
    hist(x, breaks=bins, col="#75AADB", border="white",
         xlab="다음 분출 때까지 대기 시간(분)",
         main="대기 시간 히스토그램")
  })
}
shinyApp(ui, server) #실행

ui <- fluidPage(
  sliderInput("range","연비",min = 0, max=35, value = c(0,10)), #데이터 입력
  textOutput("value") #결과값 출력
  )
server <- function(input,output, session){
  output$value <- (input$range[1]+input$range[2])
}
shinyApp(ui, server)

install.packages("DT") #데이터테이블을 다루는 패키지
install.packages("ggplot2")
# library(DT)
# library(ggplot2)
mpg <- mpg #mpg데이터 불러오기
mpg

library(shiny)
ui <- fluidPage(
  sliderInput("range", "연비", min = 0, max=35, value = c(0,10)), #데이터 입력
  DT::dataTableOutput("table") #샤이니에서는 입력과 출력 결과의 '연결'이 중요
)
server <- function(input,output, session){
  cty_sel=reactive({
    cty_sel=subset(mpg, cty >= input$range[1] & cty <= input$range[2])
    return(cty_sel)})
  output$table <- DT::renderDataTable(cty_sel())} #ui에 연결. 이름이 같아야함
shinyApp(ui, server)

# 레이아웃 정의하기
ui <-fluidPage(
  fluidRow(
    column(9, div(style = "height:450px; border:4px solid red;", "폭 9")), #<div></div> 구역을 나눠주는 태그
    column(3, div(style = "height:450px; border:4px solid purple;", "폭 3")),
    column(12, div(style = "height:400px; border:4px solid blue;", "폭 12"))
  )
)
server <- function(input, output, session){}
shinyApp(ui, server)

# 탭 페이지 추가
library(shiny)
ui <- fluidPage(
  fluidRow(
    column(9, div(style = "height:450px; border:4px solid red;", "폭 9")),
    column(3, div(style = "height:450px; border:4px solid purple;", "폭 3")),
    tabsetPanel(
      tabPanel("탭1",
               column(4, div(style = "height:300px; border:4px solid red;", "폭 4")),
               column(4, div(style = "height:300px; border:4px solid red;", "폭 4")),
               column(div(style = "height:300px; border:4px solid red;", "폭 4")),),
      tabPanel("탭2",div(style = "height:400px; border:4px solid blue;", "폭 12"))
    )
  )
)
server <- function(input, output, session){} #server의 출력함수를 정의하지 않아 변화 없음
shinyApp(ui, server) #실행