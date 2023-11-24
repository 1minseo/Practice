#11-1. 미국 주별 강력 범죄율 단계 구분도 만들기

install.packages("mapproj") #ggiraphExtra패키지를 이용하는데 필요
install.packages("ggiraphExtra") #단계구분도 만들기
library(ggiraphExtra)

str(USArrests) #1973년 미국 주별 강력 범죄율 데이터
head(USArrests) #컬럼명이 따로 없음을 확인
library(tibble) #dplry의 내장 라이브러리
crime <- rownames_to_column(USArrests, var="state")
crime$state <- tolower(crime$state) #대문자 -> 소문자
View(crime)

library(ggplot2)
states_map <- map_data("state") #주 경계 위도경도 데이터 삽입
str(states_map)
View(states_map)

ggChoropleth(data=crime, aes(fill=Murder, map_id=state), map = states_map, interactive = T)