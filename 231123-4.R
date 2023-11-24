library(dplyr)
library(readxl)
library(ggplot2)]

#1. 주어진 엑셀 데이터를 읽어 R데이터프레임 smokers로 저장하여라
smokers <- read_excel("C:/workspace/easy_r/data/smoke.xlsx")
smokers

#2. smokers에서 자료의 수(레코드의 수)를 구하시오
View(smokers)
nrow(smokers)

#3. smokers 자료의 옆에서부터 10개의 레코드를 출력하여라
head(smokers,10)
smoker[1:10,] #열 전체

#4. 자료에서 여자와 남자의 수를 구하시오
table(smokers$Gender)

aggregate(smokers$Age, list(smokers$Gender), length)

#5. 자료에서 흡연자의 수와 흡연비율을 구하시오
n_smokers = table(smokers$Smoker)[2]
n_smokers
n_smokers/nrow(smokers)

n_smokers1=sum(smokers$Smoker=="yes")
n_smokers1/nrow(smokers)

#6. 자료에서 성별 흡연자의 수와 흡연비율을 구하시오
tx=table(smoker=smokers$Smoker, Gender=smokers$Gender)
prop.table(tx,2)

tx[2,]/table(smokers$Gender) #yes만 선택

#7. BMI(체질량지수)는 몸무게를 키의 제곱으로 나눈 값이다. 자료에서 BMI를 구하여라
smokers$BMI = smokers$Weight/(smokers$Height/100)^2
head(smokers)

#8. 성별 BMI의 평균과 표준편차를 구하라
mean(smokers$BMI)

mean(smokers$BMI[smokers$Gender=="F"]) #여자들만
mean(smokers$BMI[smokers$Gender=="M"]) #남자들만

aggregate(BMI ~ Gender, data=smokers,mean)

aggregate(smokers$BMI, list(smokers$Gender), mean)
aggregate(smokers$BMI, list(smokers$Gender), sd)

#9. 성별 BMI를 상자그림으로 그려라
boxplot(BMI ~ Gender,data = smokers, ylab="BMI", xlab = "Gender")

#10. 흡연 및 비흡연자의 BMI의 평균과 표준편차를 구하라
mean(smokers$BMI[smokers$Smoker=="yes"])
mean(smokers$BMI[smokers$Smoker=="no"])
aggregate(BMI ~ Gender, data = smokers, sd)

#11. 흡연 및 비흡연자의 BMI를 상자그림으로 그려라
# HOWLong 흡연기간
# Cigarettes 일흡연량(개피)
boxplot(BMI~smoker,data = smokers,ylab="BMI", xlab = "smoker")