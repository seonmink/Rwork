#### 실습 1 ####

#주제: 담배값 인상전의 월별 매출액과 인상 후 월별 매줄엑의 관계가 있는가?
# 담배값과 매출액의 관계가 있는가?

x <-c(70,72,62,64,71,76,0,65,75,72)
y <-c(70,74,65,68,72,74,61,66,76,75)

cor(x,y,method = 'pearson')
#0.3 이하 상관이 약함, .5 이상 중간 그 이상은 강함

cor(x,y,method = 'spearman')
cor(x,y,method = 'kendal')

# 조금 더 자세히 알고 싶다면 cor.test(x,y,method=)
cor.test(x,y,method = 'pearson')


#### 실습2 ####
#pop_growth : 인구증가율
#elderly_rate: 65세 이상 노령인구 비율 
#finance: 재정 자립도
#cultural_center: 인구 10만명 당 문화 기반 시설 수 
mydata <- read.csv('./Data/cor.csv')
str(mydata)
head(mydata)

# 주제: 인구 증가율과 노령인구 비율간의 관계가 있는가 ?
plot(mydata$pop_growth,mydata$elderly_rate)

cor(mydata$pop_growth,mydata$elderly_rate) # method 생략하면 pearson임 
# 인구가 증가할 수록 노년인구는 감소경향 

x<-cbind(mydata$pop_growth,mydata$elderly_rate,mydata$finance,mydata$cultural_center) # 변수 전체의 상관을 살펴볼때
cor(x)

#### 실습3 ####
install.packages('UsingR')
library(UsingR)
str(galton)

#그래프 그려보기
plot(galton$parent,galton$child,data=galton)
plot(child~parent,data=galton)

cor(galton$parent,galton$child)
cor.test(galton$parent,galton$child)

#흐트러 트려주기 jitter
plot(jitter(child,5)~jitter(parent,5),data=galton)
sunflowerplot(galton)

install.packages('SwissAir')
library(SwissAir)
View(AirQual)
Ox <- AirQual[ , c("ad.O3", "lu.O3", "sz.O3")] + 
  AirQual[ , c("ad.NOx", "lu.NOx", "sz.NOx")] -
  AirQual[ , c("ad.NO", "lu.NO", "sz.NO")]

names(Ox) <-c('ad','lu','sz')
Ox
plot(lu~sz,data=Ox) # 중복된 데이터가 많아서 진하게 막 나옴 이를 보기좋게 하기 위해
install.packages('hexbin')
library(hexbin)
plot(hexbin(Ox$lu,Ox$sz,xbins=50))

#부드러운 스캐터 그래프 
smoothScatter(Ox$lu,Ox$sz)

install.packages('IDPmisc')
library(IDPmisc)
iplot(Ox$lu,Ox$sz)


