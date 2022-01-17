#### 기본 내장 그래프 ####

### plot() - 산포도 
# plot(y축 데이터, 옵션)
# plot(x축 데이터, y축 데이터, 옵션)

y <-c(1,1,2,2,3,3,4,4,5,5) 
plot(y) # x축은 자동으로 1,2,3,4,5... 

x<-1:10
y<-1:10
plot(x,y)

# 옵션
?plot
# xlim =() x값의 범위 조정지정
plot(x,y,xlim=c(0,20))
plot(x,y,xlim=c(0,20),ylim=c(0,30))
plot(x,y,xlim=c(0,20),ylim=c(0,30),main = 'Graph') # 제목 설정 main

# type: 그래프의 선표시 모양 : 'p','l','b','o','n'
plot(x,y,xlim=c(0,20),ylim=c(0,30),main = 'Graph',type='o')

#pch 그래프 점의 모양(숫자로 지정) 
plot(x,y,xlim=c(0,20),ylim=c(0,30),main = 'Graph',type='o',pch=4)

#cex: 점의 크기를 비율로 지정
plot(x,y,xlim=c(0,20),ylim=c(0,30),main = 'Graph',type='o',pch=2,cex=3.5)

# col: 점의 색(문자로 지정)
plot(x,y,xlim=c(0,20),ylim=c(0,30),main = 'Graph',type='o',pch=2,cex=3.5, col='blue')

#lty : 선의 스타일, 'blank','solid','dashed','dotted','longdash','twodash'
plot(x,y,xlim=c(0,20),ylim=c(0,30),main = 'Graph',type='o',pch=2,cex=1.5, col='red',lty='dashed')

str(cars)
head(cars)
plot(cars) #양의 상관관계를 띔 
plot(cars$dist,cars$speed) # x,y순서를 지정할 수 있음.

# 같은 속도일때 제동거리가 다를 경우 대체적인 추세를 알기 어렵다. 
# 속도에 대한 평균 제동거리를 구해서 그래프로 그려보자. 
tapply(cars$dist, cars$speed, mean) #뭐를 알고 싶나?, 무엇을 기준으로?, 어떤거를(집계 함수) 그룹별로 집계함수 구하기 용이
plot(tapply(cars$dist, cars$speed, mean),xlab='speed',ylab='dist') # xlab , ylab -> x축, y축 레이블 지정 가능 

head(mtcars)
table(mtcars$cyl)
#실린더 별로 mpg의 평균dms? 
tapply(mtcars$mpg, mtcars$cyl, mean)
plot(tapply(mtcars$mpg, mtcars$cyl, mean))


### points()
head(iris)
str(iris)

plot(iris$Sepal.Width,iris$Sepal.Length) # 폭이 커질 수록 높이가 커지나 살펴보기 
plot(iris$Petal.Width,iris$Petal.Length) # 꽃잎과 높이 상관

# 매번 데이터 iris$ 하기 싫을 때 . with로 먼저 묶어 준다
with(iris,{
  plot(Sepal.Width, Sepal.Length) 
  plot(Petal.Width, Petal.Length)
 }
)

#points 는 기본 그래프에 추가해주는 것 
with(iris,{
  plot(Sepal.Width,Sepal.Length) 
  points(Petal.Width,Petal.Length)
}
)

### lines() 선그래프 
plot(cars)
lines(cars) # 기존의 산포도에 선을 이어줌 
lines(lowess(cars)) # 가장 평균적인 선을 이어줌 lowess 회귀선?

### barplot(), hist(), pie(), mosaicplot(), persp(), contour(), ... ## 기본 bar 그래프
#angle, density, col :막대를 칠하는 선분의 각도, 선분의 수, 선분의 색을 지정 
#legend :오른쪽 상단에 범례를 그림 
# names:각 막대의 라벨을 정하는 문자열 벡터를 지정 
# width:각 막대의 상대적인 폭을 벡터로 지정 
# space:각 막대 사이의 간격을 지정 
# beside: TRUE를 지정하면 각각의 값마다 막대를 그림 
# horiz : TRUE를 지정하면 막대를 옆으로 눕혀서 그림
x<- c(1,2,3,4,5)
barplot(x)
barplot(x,horiz=T) 
barplot(cars$speed)


### 그래프 배열 - 한번에 여러개 그래프 
head(mtcars)
?mtcars
str(mtcars)

## 그래프 4개를 동시에 그리기
par(mfrow=c(2,2)) # 먼저 4개를 그릴거라는 바닥을 만들어주면 됨

plot(mtcars$wt,mtcars$mpg)
plot(mtcars$wt,mtcars$disp)
hist(mtcars$wt)
boxplot(mtcars$wt)

#다시 하나로 그리고 싶을 때!
par(mfrow=c(1,1))
plot(mtcars$wt,mtcars$mpg)

# 행 또는 열마다 그래프 수를 다르게 설정 --> 배열 수를 마음대로지정 
?layout
layout(matrix(c(1,1,2,3),2,2,byrow = T))  # 2,2 는 전체적인 크기 c(1,1,2,3) 첫번째 그래프를 1,1-> 1,2 면에 그리겠다 나머지
plot(mtcars$wt,mtcars$mpg)
plot(mtcars$wt,mtcars$disp)
hist(mtcars$wt)

layout(matrix(c(1,2,1,3),2,2,byrow = T)) 
plot(mtcars$wt,mtcars$mpg)
plot(mtcars$wt,mtcars$disp)
hist(mtcars$wt)

layout(matrix(c(2,3,1,1),2,2,byrow = T)) 
plot(mtcars$wt,mtcars$mpg)
plot(mtcars$wt,mtcars$disp)
hist(mtcars$wt)

#다시 원래대로 
par(mfrow=c(1,1))

#### 특이한 그래프 ####

### arrows 
x <- c(1,3,6,8,9)
y <-c(12,56,78,82,9)

plot(x,y)
arrows(3,56,1,12) # 시작, 끝 방향으로 화살 모양 선 그려짐
text(6,40, '이것은 샘플입니다', srt=60) #srt는 각도 기울기 

###꽃잎 그래프 
x <- c(1,1,1,2,2,2,2,2,2,3,3,4,5,6,6,6)
y <- c(2,1,4,2,3,2,2,2,2,2,1,1,1,1,1,1)
plot(x,y) # 값이 많은데 별로 안나온 것은 중복이 되어서 생략된것 

?sunflowerplot
z<- data.frame(x,y)
z
sunflowerplot(z) # 데이터가 겹치는 것을 알려줌 겹치는 데이터 수 = 꽃입 수

### 별 그래프 
# 데이터의 전체적인 윤곽을 살펴보는 그래프
# 데이터 항목에 대한 변화의 정도를 한눈에 파악 
str(mtcars)

stars(mtcars[1:4]) # 데이터[열]      ,,,,이렇게만 하면 어느게 강한건지 모르기에 범례를 지정해워야함. 
stars(mtcars[1:4],key.loc = c(13,2.0)) #key.loc는 범례
stars(mtcars[1:4],key.loc = c(13,2.0),flip.labels = T) # 레이블 겹치지 않게, 짧으면 보기 좋게 한줄로 쓰는 것이 좋음. 
stars(mtcars[1:4],key.loc = c(13,2.0),flip.labels = F, draw.segments = T) # draw.segments --> 나이팅 게일, 한눈에 알아보기 쉽게

### symbols
x<- c(1,2,3,4,5)
y<- c(2,3,4,5,6)
z<- c(10,5,100,20,10)
symbols(x,y,z) # x,y에 따라 데이터 크기를 시각적으료 표현하는 것. 

#### ggplot2 ####
# stars(mtcars[1:4],key.loc = c(13,2.0),flip.labels = T)  도움 사이트

# 레이어 지원
# 1) 배경 설정
# 2) 그래프 추가(점, 선, 막대,....)
# 3) 설정 추가(축,범위, 범례, 색, 표식,...)

library(ggplot2)
head(mpg)

### 산포도
mpg <- ggplot2 :: mpg
head(mpg)

ggplot(data= mpg, aes(x=displ, y=hwy)) # 배경설정 
ggplot(data= mpg, aes(x=displ, y=hwy)) + geom_point()
ggplot(data= mpg, aes(x=displ, y=hwy)) + geom_point() +xlim(3,6)
ggplot(data= mpg, aes(x=displ, y=hwy)) + geom_point() +xlim(3,6) + ylim(10,30) # 경고 메시지는 범위를 줄여서 다 못보여주고 있다고 걱정하는 거임 ㅎ
ggplot(data= mpg, aes(displ, hwy)) + geom_point() +xlim(3,6) + ylim(10,30)#aes -> 는 차피 x와 y 순이니까 생략 가능 

# midwest 데이터를 이용해서 전체인구(poptotal) 아시아인구(popasian) 간에 
# 어떤관계가 있는지 알고 싶다. 

head(midwest)
ggplot(data=midwest,aes(poptotal,popasian)) + geom_point() +xlim(0,300000) +ylim(0,10000)
# 양의 상관, 전제인구가 많을 수록 아시안 인구도 증가하는 경향이 있다. 

#x축 지수를 숫자로 표현하기
options(scipen=99)
ggplot(data=midwest,aes(poptotal,popasian)) + geom_point() +xlim(0,300000) +ylim(0,10000)

### 막대그래프 : geom_col(), 히스토그램 : geom_bar() 둘의 차이는? 연속데이터와 범주데이터, 막대는 떨어져 있고, 히스토그램은 떨어져 있음
# 막대는 변수가 2개, 히스토그램은 변수 1개

# mpg 데이터에서 구동방식(drv) 별로 고속도로 평균연비(hwy)를 조회하고 그 결과를 표시 
head(mpg)
library(dplyr)
df_mpg<-mpg%>% group_by(drv)%>% summarise(mean_hwy=mean(hwy))
df_mpg
df_mpg2<-tapply(mpg$hwy, mpg$drv, mean)
df_mpg2
ggplot(data=df_mpg, aes(drv,mean_hwy)) + geom_col()

#막대의 정렬을 하고 싶다면? reorder(x,y) 오름 차순, 내림차순 정렬기준변수 y 에 - 기호 붙여주면 됨
ggplot(data=df_mpg, aes(reorder(drv,mean_hwy),mean_hwy)) + geom_col() # 오름차순
ggplot(data=df_mpg, aes(reorder(drv,-mean_hwy),mean_hwy)) + geom_col() # 내림차순

ggplot(mpg,aes(drv)) +geom_bar()
ggplot(mpg,aes(hwy)) +geom_bar()

# 어떤 회사에서 생산한 "suv" 차종의 도시연비가 높은지 알아보려 한다.
# 'suv' 차종을 대상으로 평균 cty가 가장 높은 회사 다섯곳을 그래프로 표시
head(mpg)
df_suv <- mpg%>% filter(class=='suv')%>%group_by(manufacturer)%>%summarise(mean_cty =mean(cty)) %>% arrange(desc(mean_cty))%>%head(5)
df_suv
ggplot(data=df_suv,aes(manufacturer,mean_cty)) +geom_col()
ggplot(data=df_suv,aes(reorder(manufacturer,mean_cty),mean_cty)) +geom_col()

# 자동차 중에서 어떤 종류가(class)가 가장 많은지 알고 싶다.
# 자동차 종류별 빈도를 그래프로 그려라 
table(mpg$class)
ggplot(mpg,aes(class)) + geom_bar()


### 선 그래프: geom_line()
str(economics)
head(economics)
tail(economics)

ggplot(economics,aes(date,unemploy)) + geom_line()
ggplot(economics,aes(date,psavert)) + geom_line()

### 상자 그래프: geom_boxplot()
ggplot(mpg,aes(drv,hwy)) + geom_boxplot() # 최대값, 이상치, 중앙값 들을 한번에 볼 수 있음 

library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
mpg
c:CNG = 2.35, d:Disel = 2.38, e:Ethanol = 2.11, p:Premium = 2.76, r:Regular = 2.22

fuel <- data.frame(fl = c('c','d','e','p','r'), price_fl = c(2.35,2.38,2.11,2.76,2.22)
mpg2<-cbind(mpg,ful)
                   