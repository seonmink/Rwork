#### Power Analysis ####
# 검증하기에 데이터가 충분한지, 샘플의 데이터 갯수가 부족한지 아닌지 파악하는 
# cohen's d(effective size): 이 데이터로 충분한지 부족한지, 두 집단의 평균차이를 표준편차(두 집단의 표준편차)의 합으로 나눠줌. 
ky <- read.csv('./Data/KY.csv',header = T)
View(ky)

#갯수 확인 
table(ky$group)

##d를 구하기 
#각집단 평균 구하기
mean.1 <- mean(ky$score[which(ky$group==1)])
mean.2 <-  mean(ky$score[ky$group==2])
cat(mean.1,',', mean.2)

#각 집단 표준편차 구하기 
sd.1 <- sd(ky$score[which(ky$group==1)])
sd.2 <- sd(ky$score[ky$group==2])
cat(sd.1,',', sd.2)

#절댓값으로 묶기 abs
effective_size <-abs(mean.1-mean.2)/sqrt((sd.1^2+sd.2^2)/2) #절대값으로 평균 - 평균 하고 각 표준편차 제곱의 평균의 루트
print(effective_size)



install.packages('pwr')
library(pwr)
#데이터 갯수 확인
?pwr.t.test
pwr.t.test(d=effective_size,alternative = 'two.sided',type='two.sample',power=.8,sig.level = .05)
#alternative 가 쉽게 넣을 수 있음. 양측 검증할 것인지, 단측검증을 할 것인지 
#power = 1종, 2종 오류 --> 귀무가설인데 대립가설이라 하는 오류 험할 확률 거의 .8을 씀 
#sig.level --> 유의수준 
# d는 유효 사이즈 --> cohen's d로 구하는 값. 
#실행해 보면 n이 17,  17개만 넘으면 된다는 것(각 그룹의 갯수) 보통 30개 이상 넘으면 문제 없다 생각함. 


#데이터가 충분하다는 가정하에 평균 비교 
#### 사례1 : 두 집단의 평균비교 ####
install.packages('moonBook')
library(moonBook)

#경기도에 소재한 대학변원에서 2년동안 내원한 급성 관상동맥증후군, 실제 환자 데이터
head(acs)
?acs
str(acs)
summary(acs)

### 가설설정 
# 주제: 두 집단(남,여)의 나이차이를 알고 싶다. 
# 귀무가설: 남성과 여성의 평균나이의 대해 차이가 없다.
# 대립가설:남성과 여성의 평균나이의 대해 차이가 있다.

mean.man <- mean(acs$age[acs$sex=='Male'])
mean.woman <- mean(acs$age[acs$sex=='Female'])
cat(mean.man,',', mean.woman)

#t-test를 쓸 수 있는지확인 
#1번은 가능하고 결과변수가 연속형이니
#1번 정규분포여부 
moonBook::densityplot(age~sex,data=acs) #간단하게 그래프를 그려볼 수 있음. 
# 여자는 정규분포가 아님 , 
# 그래프로 확인하기 어려운경우가 있을 수 있음 그럴때는 수치로 shapiro.test

# 가설설정
# 주제 : 두 집단의 정규분포 여부 알고 싶다 
# 귀무가설 : 두 집단이 정규분포이다.
# 대립가설 : 두 집단이 정규 분포가 아니다.

shapiro.test(acs$age[acs$sex  == 'Male'])
# -> 남자 집단은 정규분포이다(p 값이 0.05보다 크기에)
shapiro.test(acs$age[acs$sex  == 'Female'])

## 등분산 여부
# 가설설정
# 주제 : 두 집단의 등분산 여부 알고 싶다 
# 귀무가설 : 두 집단이 등분산이다.
# 대립가설 : 두 집단이 등분선이 아니다.

var.test(age~sex,data=acs)# sex-> 독립변수, age -> 종속변수
# 등분산이다

### 가설검정 
# MWW Test
wilcox.test(age~sex,data=acs)


# 정규분포라 가정하고 티검정 해보자 
#t-test
?t.test
t.test(age~sex,data=acs, alt='two.sided',var.equal=T)

# welch's t-test
t.test(age~sex,data=acs, alt='two.sided',var.equal=F)


#### 사례2 : 집단이 한개인 경우 ####
# 모수를 알고 있는 경우 
#### 가설설정 : A회사의 건전지 수명이 1000 시간일때, 무작위로 뽑아 10개의 건전지 수명에 대해 샘플이 모집단과 다르다고 할 수 있는가?
# 귀무가설: 표본의 평균은 모집단의 평균과 같다.
# 대립가설: 표본의 평균은 모집단의 평균과 다르다.

sample <- c(980,1008,968,1032,1012,1002,996,1017,990,955)
mean.sample <-mean(sample)
mean.sample

#정규분포
shapiro.test(sample)
# 변수가 하나기에 등분산은 볼 필요 없음.. --> 정규분토가 가정되기때문에 t-test 검증 가능 
t.test(sample, mu=1000,alt='two.sided')
#mu -> 모평균 
t.test(sample, mu=1000,alt='less') # 단측으로 해도 유의하지 않음. 왼쪽 
t.test(sample, mu=1000,alt='greater') # 오른쪽




#### 가설설정 : 어떤 학급의 수학 평균 성적이 55점이었다. 0교시 수업을 하고 다시 성적을 살펴보았다 
# 귀무가설: 표본의 평균은 모집단의 평균과 같다.
# 대립가설: 표본의 평균은 모집단의 평균과 다르다.

sample2<- c(57,49,39,99,32,88,62,30,55,65,44,55,57,53,88,42,39) 
mean.sampe2 <-mean(sample2)
mean.sampe2
shapiro.test(sample2) # 정규분포
t.test(sample2, mu=55,alt='two.sided') 
t.test(sample2, mu=55,alt='less')
t.test(sample2, mu=55,alt='greater')


#### 사례3: Paired Sample T-test ####
str(sleep)
head(sleep)
print(sleep)
table(sleep$ID)

#주제: 같은 집단에 대해 수면시간의 증가량 차이가 나느지 알고 싶다 
sleep2 <- sleep[,-3]
sleep2

#두 집단의 수면증가량 평균
mean(sleep2$extra[sleep2$group==1])
mean(sleep2$extra[sleep2$group==2])
#그룹별로 요약 
tapply(sleep2$extra,sleep2$group,mean)

#정규분포 여부
shapiro.test(sleep2$extra[sleep2$group])
with(sleep2,shapiro.test(extra[sleep2$group==1]))
with(sleep2,shapiro.test(extra[sleep2$group==2]))
#moonBook::densityplot(extra~group,data=sleep2)

#등분산
var.test(extra~group,data=sleep2 )

#대응 표본 t검증
t.test(extra ~ group, data=sleep2, paired= T,var.equal=T)

###차이를 그래프로 그려보기 
before <- subset(sleep2,group==1,extra)
before
after <- subset(sleep2,group==2,extra)
after

s_graph1<-cbind(before,after)
s_graph1
plot(s_graph,type='profile')
install.packages('PairedData')
library(PairedData)
s_graph2 <-paired(before,after) #  컬럼명 까지 바꿔줌 
s_graph2
plot(s_graph2,type='profile') + theme_bw()


#### 실습1 ####
# Dummy: 파생변수, 0: 군, 1: 시
# 주제 : 시와 군에 따라서 합계 출산율의 차이가 있는지 알아보려 함.
# 귀무가설: 차이가 없다.
# 대립가설: 차이가 있다. 
mydata <- read.csv('./Data/independent.csv')
mydata
str(mydata)

mean(mydata$birth_rate[mydata$dummy==1])
mean(mydata$birth_rate[mydata$dummy==0])
gun.mean<- with(mydata,mean(birth_rate[dummy==0]))
si.mean<- with(mydata,mean(birth_rate[dummy==1]))
cat(gun.mean,si.mean)

#정규분포
shapiro.test(mydata$birth_rate[sleep2$group])
with(mydata,shapiro.test(birth_rate[mydata$dummy==0]))
with(mydata,shapiro.test(birth_rate[mydata$dummy==1]))
with(mydata,shapiro.test(birth_rate[dummy==0]))
with(mydata,shapiro.test(birth_rate[dummy==1]))#정규분포를 이루지 않음

#등분산
var.test(extra~group,data=sleep2 )
var.test(birth_rate~dummy,data=mydata)
#등분산도 이루지 않음 

#정규분포를 이루지 않음
wilcox.test(birth_rate~dummy,data=mydata)
#           결과값     입력값, 데이터

#t테스트 그냥 해보기
t.test(birth_rate~dummy,data=mydata)
#--> 차이가 있다!!

#### 실습 2####
#주제: 오토(am== 0), 수동(am==1) 에따라 연비차이(mpg) 

str(mtcars)
head(mtcars)

auto.mean<- with(mtcars,mean(mpg [am ==0]))
sudong.mean<- with(mtcars,mean(mpg [am ==1]))
cat(auto.mean,sudong.mean)

#정규분포
with(mtcars,shapiro.test(mpg[am==0]))
with(mtcars,shapiro.test(mpg[am==1]))

#등분산
var.test(mpg~am,data=mtcars)
var.test(mtcars[mtcars$am==1,1],mtcars[mtcars$am==0,1])

#t검증 
t.test(mpg~am,data=mtcars)

t.test(mpg~am,data=mtcars,alt='two.sided',var.equal=T)
t.test(mpg~am,data=mtcars,alt='less',var.equal=T) # less로 보면 작은쪽이니까 차이가 있다라고 나오는데
t.test(mpg~am,data=mtcars,alt='greater',var.equal=T) # 차이가 없다 나온다? greater는 큰쪽이니까 차이가 없다로 나옴
#즉 단측 검정할때는 어느쪽으로 할지 잘 파악을 해야함.


#### 실습3 ####
#주제 쥐의 몸무게가 전과 후가 차이가 있는지 없는지 알고 싶다.

data <- read.csv('./Data/pairedData.csv')
data

#두 집단의 평균
berfore <- mean(data$before)
after<-mean(data$After)
cat(berfore,after)

#정규분포 여부 --> 하려면 long형으로 
shapiro.test(data$before)
shapiro.test(data$After)

#하나의 집단이기 때문에 굳이 등분산을 살펴볼 필요가 없음. 
var.test(data$before,data$After)

#롱형이 아니라 ~ 를 쓸 수 없음
t.test(data$before,data$After,paired = T)
# 상당한 차이

#~으로 하기 위해서는 long형으로 바꿔야함. 
library(reshape2)
data1 <- melt(data,id='ID',variable.name = 'GROUP',value.name = 'RESULT')
data1

shapiro.test(data1$RESULT[data1$GROUP== 'before'])
shapiro.test(data1$RESULT[data1$GROUP== 'After'])

t.test(RESULT~GROUP,data=data1,paired = T)

# 또 다른 long형 변경법
install.packages('tidyr')
library(tidyr)
data2 <- gather(data,key='GROUP',value='RESULT',-ID) # 필요없는 칼럼은 삭제 가능 
data2
shapiro.test(data1$RESULT[data2$GROUP== 'before'])
shapiro.test(data1$RESULT[data2$GROUP== 'After'])

t.test(RESULT~GROUP,data=data2,paired = T)

#그래프
library(PairedData)
before<-data$before
after<-data$After

s_graph <- paired(before,after)
s_graph
plot(s_graph)
plot(s_graph,type='profile') + theme_bw()
s_graph

library(moonBook)
moonBook::densityplot(RESULT~GROUP, data=data1)


#### 실습4 ####
# 주제 : 시별로 2010년도와 2015년도의 출산율 차이가 있는가?
data <- read.csv('./Data/paired.csv')
data
data1 <- melt(data,id='ID',variable.name = 'GROUP',value.name = 'RESULT')
data1
birth_2015<-mean(data$birth_rate_2015 )
birth_2010<-mean(data$birth_rate_2010 )
cat(birth_2015,birth_2010)

shapiro.test(data$birth_rate_2015)
shapiro.test(data$birth_rate_2010)

var.test(data$birth_rate_2015,data$birth_rate_2010)
t.test(data$birth_rate_2015,data$birth_rate_2010,paired = T)

#long 형으로 바꾸기 
data1 <- gather(data, key='GROUP',value='RESULT',-c(ID,cities))
data1
with(data1,shapiro.test(RESULT[GROUP=='birth_rate_2010']))
with(data1,shapiro.test(RESULT[GROUP=='birth_rate_2015']))
#정규분포 가정 안됨.

wilcox.test(RESULT~GROUP, data=data1,paired=T)
t.test(RESULT~GROUP, data=data1,paired=T)

#### 실습5 ####
# 주제1: 남녀별로 각 시험에 대해 평균차이가 있는지 알고 싶다. 
summary(mat$G1)
summary(mat$G2)
summary(mat$G3)
table(mat$sex)

library(dplyr)
mat%>%select(sex,G1,G2,G3)%>% group_by(sex)%>%
  summarise(mean_g1=mean(G1),mean_g2=mean(G2),mean_g3=mean(G3),
            cnt_g1=n(),cnt_g2=n(),cnt_g3=n(),
            sd_g1=sd(G1),sd_g2=sd(G2),sd_g3=sd(G3))
with(mat,shapiro.test(G1[sex=='F']))
with(mat,shapiro.test(G1[sex=='M']))
with(mat,shapiro.test(G2[sex=='F']))
with(mat,shapiro.test(G2[sex=='M']))
with(mat,shapiro.test(G3[sex=='F']))
with(mat,shapiro.test(G3[sex=='M']))
#하지만 데이터수가 400개가 넘으니 정규분포를 가정해도 됨 집단간 30개 정도면 정규분포라 봐도 무관 

var.test(G1~sex,data=mat)
var.test(G2~sex,data=mat)
var.test(G3~sex,data=mat) # 등분산은 가정됨.

wilcox.test(G1~sex,data=mat) # 차이 없다.
wilcox.test(G2~sex,data=mat) # 차이 있다.
wilcox.test(G3~sex,data=mat) # 차이 있다. 

t.test(G1~sex,data=mat, var.equal=T,alt='two.sided') #차이가 없다. 경계선적
t.test(G2~sex,data=mat, var.equal=T,alt='two.sided') #차이가 없다. 경계선적
t.test(G3~sex,data=mat, var.equal=T,alt='two.sided') #차이가 있다.

#단측방향 검증을 한다면 less를 해야함. 왼쪽이(여자) 작기 때문, 해석의 차이로 방향 선택하면 댐.
t.test(G1~sex,data=mat, var.equal=T,alt='less')
t.test(G2~sex,data=mat, var.equal=T,alt='less')
t.test(G3~sex,data=mat, var.equal=T,alt='less')


#와이드형 
g1_f<-with(mat,mean(G1[sex=='F']))
g1_M <-with(mat,mean(G1[sex=='M']))

cat(g1_f,g1_M)

with(mat,shapiro.test(G1[sex=='F']))
with(mat,shapiro.test(G1[sex=='M']))

wilcox.test(G1~sex,data=mat)
#g1은 남녀 차이 없음

g1_f2<-with(mat,mean(G2[sex=='F']))
g1_M2<-with(mat,mean(G2[sex=='M']))


cat(g1_f2,g1_M2)

with(mat,shapiro.test(G2[sex=='F']))
with(mat,shapiro.test(G2[sex=='M']))
wilcox.test(G2~sex,data=mat) # 차이 있음 남자가 더 높음

g1_f3<-with(mat,mean(G3[sex=='F']))
g1_M3<-with(mat,mean(G3[sex=='M']))
cat(g1_f3,g1_M3)

with(mat,shapiro.test(G3[sex=='F']))
with(mat,shapiro.test(G3[sex=='M']))

wilcox.test(G3~sex,data=mat) # g3도 차이 있음. 


# 주제2: 같은 사람에 대해서 성적차이가 있는지(첫번째, 세번째 시험, 시험은 G1,2,3)
mat <-read.csv('./Data/student-mat.csv',header=T)
head(mat)
str(mat)

mean1 <-mean(mat$G1)
mean3 <-mean(mat$G3)
cat(mean1,mean3)

shapiro.test(mat$G1)
shapiro.test(mat$G3)

wilcox.test(mat$G1,mat$G3) 
wilcox.test(mydata$RESULT~mydata$GROUP,data=mydata,paired=T)
#차이가 없음, 비모수는 값이 아닌 순위를 가지고 하는 것임. 값을 활용을 잘 못함., 데이터가 소량일때 주로 쓰임


# 롱형으로 바꿔서 
library('tidyr')
mydata <- gather(mat,key='GROUP',value='RESULT','G1','G3')
t.test(mydata$RESULT~mydata$GROUP,data=mydata,paired=T)

mat %>% select(G1,G3) %>% summarise(mean_g1=mean(G1),mean_g3=mean(G3))
                                   
wilcox.test(mydata$RESULT~mydata$GROUP,data=mydata,paired=T)                    
#단측검증
# 기폴트는 항상 왼쪽 
t.test(mydata$RESULT~mydata$GROUP,data=mydata,paired=T,alt='less') 

t.test(mydata$RESULT~mydata$GROUP,data=mydata,paired=T,alt='greater') 
