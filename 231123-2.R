# install.packages("remotes")

# 대한민국 시도별 인구 단계구분도 그리기
install.packages("stringi") #지도정보를 파일에서 가져올 때 씀
install.packages("devtools") #깃허브에서 다운받는 패키지
devtools::install_github("cardiomoon/kormaps2014", force = TRUE)
#--------------------
library(kormaps2014)
str(korpop1)
# korpop1 <- changeCode(korpop1)
# kormap1 <- changeCode(kormap1)
library(dplyr)
#--------------------
View(korpop1)
korpop1 <- rename(korpop1, pop=총인구_명, name=행정구역별_읍면동)
korpop1$name <- iconv(korpop1$name, "UTF-8","CP949")
library(ggplot2)
library(ggiraphExtra)
library(tibble)

ggChoropleth(data = korpop1,
             aes(fill = pop,
                 map_id = code,
                 tooltip = name),
             map=kormap1,
             interactive = T)
#--------------------
View(tbc)
tbc$name <- iconv(tbc$name, "UTF-8", "CP949")
ggChoropleth(data = tbc,
             aes(fill = NewPts,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)
#--------------------
# 12-1. plotly 패키지로 인터랙티브 그래프 만들기
install.packages("plotly")
library(plotly)
library(ggplot2)
p <- ggplot(data=mpg, aes(x=displ, y=hwy, col=drv))+geom_point()
ggplotly(p)

b <- ggplot(data=diamonds,aes(x=cut, fill=clarity))+geom_bar(position = "dodge")
ggplotly(b)

?diamonds

# 12-2. dygraps 패키지로 인터랙티브 시계열 그래프 만들기
install.packages("dygraphs")
library(dygraphs)
economics <- ggplot2::economics
library(xts)
eco <- xts(economics$unemploy, order.by=economics$date)
head(eco)
dygraph(eco) %>% dyRangeSelector()

# 저축율
eco_a <- xts(economics$psavert,
             order.by = economics$date)
# 실업자수
eco_b <- xts(economics$unemploy/1000,
             order.by = economics$date)
e <- cbind(eco_a, eco_b)
colnames(e) <- c("psavert","unemploy")
head(e)
dygraph(e) %>% dyRangeSelector()