# 13-2. t 검정-두 집단의 평균 비교
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg) #ggplot2안에 있는 mpg데이터
library(dplyr)
mpg_diff <- mpg %>% 
  select(class, cty) %>% 
  filter(class %in% c("compact","suv"))
mpg_diff

t.test(data=mpg_diff, cty ~ class, var.equal=T)

mpg_diff2 <- mpg %>% 
  select(fl, cty) %>% 
  filter(fl %in% c("r","p")) #r: regular, p: premium
t.test(data=mpg_diff2, cty ~ fl, var.equal=T)

# 13-3. 상관분석-두 변수의 관계성 분석
economics  <- as.data.frame(ggplot2::economics)
cor.test(economics$unemploy, economics$pce) #unemploy: 실업자 수, pce: 개인 소비 지출

# 상관행렬 히트맵 만들기
# mtcars: 자동차 32종의 11개 속성에 대한 정보를 담고 있는 R에 내장된 데이터
head(mtcars)
car_cor <- cor(mtcars) #cor(): 상관행렬 만들기
round(car_cor,2) #소수점 둘째자리까지
install.packages("corrplot")
library(corrplot)
corrplot(car_cor)
corrplot(car_cor,method = "number") #숫자로 바꾸고싶을 때

col <- colorRampPalette(c("#BB4444","#ee9988","#FFFFFF","#77aadd","#4477aa"))
corrplot(car_cor, method = "color", #색깔로 표현
         col=col(200), #색상 200개 선정
         type = "lower", #왼쪽 아래 행렬만 표시
         order="hclust", #유사한 상관계수끼리 군집화
         addCoef.col = "black", #상관계수 색깔
         tl.col = "black", #변수명 색깔
         tl.str = 45, #변수명 45도 기울임
         diag = F) #대각행렬 제외