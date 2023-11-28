load("./06_geodataframe/06_apt_price.rdata") #실거래 데이터
load("./07_map/07_kde_high.rdata") #최고가 래스터 이미지
#install.packages("sf")
library(sf)
grid <- st_read("C:/workspace/R_shiny/01_code/01_code/sigun_grid/seoul.shp") #서울시 그리드

install.packages("tmap")
install.packages("htmltools", version = "0.5.7")
library(tmap)
tmap_mode("view")
tm_shape(grid)+tm_borders()+tm_text("ID", col="red")+
 tm_shape(raster_high)+tm_raster(palette=c("blue","green","yellow","red"),alpha=.4) +
 tm_basemap(server=c('OpenStreetMap'))

#installed.packages("dplyr")
library(dplyr)
apt_price <- st_join(apt_price, grid, join=st_intersects)
apt_price <- apt_price %>% st_drop_geometry()
all <- apt_price
sel <- apt_price %>% filter(ID == 81016) #개포동 추출
dir.create("08_chart")
save(all, file="./08_chart/all.rdata") #저장
save(sel, file="./08_chart/sel.rdata")
rm(list=ls())

load("./08_chart/all.rdata") #전체지역
load("./08_chart/sel.rdata") #관심지역
max_all <- density(all$py);max_all <- max(max_all$y)
max_all
max_sel <- density(sel$py);max_sel <- max(max_sel$y)
plot_high <- max(max_all, max_sel)
rm(list=c("max_all", "max_sel"))
avg_all <- mean(all$py) #전체지역 평당 평균가 계산
avg_sel <- mean(sel$py) #관심지역 평당 평균가 계산
avg_all; avg_sel; plot_high #전체/관심 평균가, y축 최댓값

plot(stats::density(all$py), ylim=c(0,plot_high), #ylim(limits): 차트의 y축 제한 설정
     col="blue", lwd=3, main=NA) #전체 지역 밀도 함수
#lty(line type: 선의 모양, lwd: 선의 굵기, col: 선의 색상
abline(v=mean(all$py),lwd=2, col="blue", lty=2) #전체 지역 평균 수직선
text(avg_all+(avg_all)*0.15, plot_high*0.1,
     sprintf("%.0f", avg_all), srt=0.2, col="blue")

lines(stats::density(sel$py), col="red", lwd=3)
abline(v=avg_sel, lwd=2, col="red", lty=2) #abline(): 좌표에 직선을 그리는 함수
text(avg_sel+avg_sel*0.15, plot_high*0.1,
     sprintf("%0f", avg_sel), srt=0.2, col="red")

# 회귀분석 : 이 지역은 일년에 얼마나 오를까?
install.packages("lubridate")
library(lubridate)
all <- all %>% group_by(month = floor_date(ymd, "month")) %>% 
  summarise(all_py=mean(py))
sel <- sel %>% group_by(month = floor_date(ymd, "month")) %>%
  summarise(sel_py=mean(py))


fit_all <- lm(all$all_py ~ all$month) #전체지역 회귀식(종속변수,독립변수 순으로)
fit_sel <- lm(sel$sel_py ~ sel$month) #관심지역 회귀식
coef_all <- round(summary(fit_all)$coefficients[2],1)*365 #전체 회귀 계수
coef_sel <- round(summary(fit_sel)$coefficients[2],1)*365 #관심 회귀 계수

#----------분기별 평당 가격 변화 주석 만들기----------
install.packages("grid")
library(grid)
grob_1 <- grobTree(textGrob(paste0("전체지역:", coef_all,
                                   "만원(평당)"), x=0.05, y=0.88,
                            hjust=0, gp=gpar(col="blue", fontsize=13, fontface="italic")))
grob_2 <- grobTree(textGrob(paste0("관심지역:", coef_sel,
                                   "만원(평당)"), x=0.05, y=0.95,
                            hjust=0, gp=gpar(col="red", fontsize=16, fontface="bold")))
#----------관심 지역 회귀선 그리기----------
install.packages("pak")
pak::pkg_install("ggpmisc")
library(ggpmisc)
library(ggplot2)
gg <- ggplot(sel, aes(x=month, y=sel_py))+
  geom_line()+xlab("월")+ylab("가격")+
  theme(axis.text.x=element_text(angle=90))+
  stat_smooth(method="lm", colour="dark grey", linetype="dashed")+
  theme_bw()
#----------전체 지역 회귀선 그리기----------
gg + geom_line(color="red", size=1.5)+
  geom_line(data=all,aes(x=month, y=all_py), color="blue", size=1.5)+
  annotation_custom(grob_1)+
  annotation_custom(grob_2)
rm(list = ls()) #메모리 정리하기

install.packages("ggpmisc")
install.packages("ggplot2")
install.packages("raster")
install.packages("lubridate")
install.packages("magrittr")
install.packages("dplyr")
library(ggpmisc)
library(ggplot2)
library(raster)
library(lubridate)
library(magrittr)
library(dplyr)

pak::pkg_install("ggpmisc", upgrade = TRUE)
install.packages('ggpmisc')

load("./08_chart/sel.rdata") #관심지역 데이터 불러오기
pca_01 <- aggregate(list(sel$con_year, sel$floor, sel$py, sel$area),
          by=list(sel$apt_nm), mean) #아파트별 평균값 구하기
colnames(pca_01) <- c("apt_nm", "신축", "층수", "가격", "면적")
m <- prcomp(~ 신축 +층수+가격+면적,data=pca_01, scale=T) #주성분 분석
#Principal Component Analysis(PCA)
summary(m)

install.packages("ggfortify")
library(ggfortify)
autoplot(m, loadings.label=T, loadings.label.size=6)+
  geom_label(aes(label=pca_01$apt_nm), size=4)