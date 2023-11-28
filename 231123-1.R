#11-1. �̱� �ֺ� ���� ������ �ܰ� ���е� �����

install.packages("mapproj") #ggiraphExtra��Ű���� �̿��ϴµ� �ʿ�
install.packages("ggiraphExtra") #�ܰ豸�е� �����
library(ggiraphExtra)

str(USArrests) #1973�� �̱� �ֺ� ���� ������ ������
head(USArrests) #�÷����� ���� ������ Ȯ��
library(tibble) #dplry�� ���� ���̺귯��
crime <- rownames_to_column(USArrests, var="state")
crime$state <- tolower(crime$state) #�빮�� -> �ҹ���
View(crime)

library(ggplot2)
states_map <- map_data("state") #�� ��� �����浵 ������ ����
str(states_map)
View(states_map)

ggChoropleth(data=crime, aes(fill=Murder, map_id=state), map = states_map, interactive = T)