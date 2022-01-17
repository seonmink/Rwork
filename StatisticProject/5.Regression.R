#### 1. 단일 회귀분석 ####
# 기본 가설 --> y = ax + b

str(women) # 미국여성을 대상으로 키와 몸무게 조사(30~39)
head(women)
plot(weight~height,data=women)
#상관관계는 단순히 관계가 있냐?, 회귀분석은 키가 이러니까 몸무게가 이렇게 된다라는 것, 예측 \\
#최소제곱법 --> 오차를 최소화 하기 위해  -이를 이용해서 최적선을 찾기 위한 함수 lm()! 

#최소제곱법으로 회귀선 그리기
fit<-lm(weight ~ height,data=women)
fit #height --> 기울기, 절편이 나옴 
abline(fit,col='blue') #회귀선 그리기ㅣ

summary(fit) # R-squared 설명계수: 얼마나 잘 설명해주나(상관계수의 제곱)
cor.test(women$weight,women$height) # 상관 계수 구하기
0.9954948^2

#대입해보기 - 키로 몸무게 예측 
85*3.45-87.52 #3.45는 기울기, -87.52는 절편 

#### 2. 4가지 조건을 확인하기 위한 방법 ####

plot(fit) #단순히 산포도만 보여주는게 아님, 두 변수가 아닌 최소제곱으로 구하던 변수를 넣으면 4가지의 조건을 확인할 수 있음(그래프로)

#한번에 보기 
par(mfrow=c(2,2))
plot(fit)
#맨 첫번째- 그래프 선형성을 보는, 특정한 모양을 가지는 것이아니라 무작위 있어야함.
# 그 옆에 Normal Q__Q --> 정규분포 확인 회귀선에 붙을수록 정규분포 
# Scale-Location : 등분산성
#독립성, 상관분석을 이용하든가 다중공성선으로 확인
#Residuals vs Leverage --> 이상치 확인할때 쓰임

par(mfrow=c(1,1))
plot(weight~height,data=women)

shapiro.test(resid(fit))
summary(fit)

### 다항회귀분석(polynomial regression), 정규분포가 아닐때 최대한 보정하는 방식으로
plot(weight~height,data=women)
abline(fit,col='blue') # 직선 그릴때

fit2 <- lm(weight~height +I(height^2),data=women)
fit2
summary(fit2) # 설명계수 증가, 

plot(weight~height,data=women)
lines(women$height,fitted(fit2),col='red') # 현재데이터에서만 잘 설명하기 위해 




#### 실습 1####
# social_welfara: 사회복지시설 
# active_firms: 사업체 수 
# urban_park : 도시 공원
# doctor : 의사
# tris : 폐수 배출 업소
# kindergarten : 유치원
mydata<- read.csv('./Data/regression.csv')
str(mydata)
head(mydata)

# 종속변수 : birth_rate
# 독립변수 : kindergarten

### 가설 : 유치원 수가 많은 지역에 합계 출산율도 높은가? 
###       또는 합계 출산율이 유치원 수에 영향을 주는가? 

fit <- lm(birth_rate~ kindergarten,data=mydata)
summary(fit)
#관계가 있지만 설명력이 약함 즉 약한 관계가 있음. 그렇다면 이게 제대로된 결과를 산출한 것인가?

par(mfrow=c(2,2)) # 그래프 한번에 보기 
plot(fit)
#선형성 어떤 패턴을 안보이니 잘 흩어져 있는 것임 
#Scale-Location 공분산성도 괜찮음
#그러나 Normal qq 정규분포는 살짝 의심스러움 

#정규분포 확인  --> 정규분포가 아님 --> 즉 이 결과를 받아들일 수 없음. 조건이 맞지 않는것. 
shapiro.test(resid(fit))
# 보정을 해야함 --> 다중회귀? 이것은 특수한 경우에 
# 로그 지수를 많이 씀 그러나 절대적인 것은 아님 

fit2 <-lm(log(birth_rate)~ log(kindergarten),data=mydata)
summary(fit2) #그래도 설명계수가 좋아졌어 

plot(fit2) # 정규분포 훨씬 좋아짐 
shapiro.test(resid(fit2)) # 정규분포 검증 결과 가정됨. 
#정규분포로 만들어 줘도 유치원수가 출산율을 설명해주 인과관계로 보기에는 무리가 있음 설명계수가 .04382로 다소 약하기 때문에 

fit3 <- lm(birth_rate~ dummy,data=mydata) # 시군구 해보기 
summary(fit3)

shapiro.test(resid(fit3))

#### 실습 2 ####
# 출처 : www.kagle.com : House sales price in kings count, USA

house <- read.csv('./Data/kc_house_data.csv',header = T)
str(house)

### 가설 : 거실의 크기와 집 가격이 서로 관계가 있는가? ###
# 종속변수 : price
# 독립변수 : sqft_living

fit <-lm(price ~ sqft_living,data=house)
summary(fit)
par(mfrow=c(2,2))
plot(fit)

shapiro.test(resid(fit)) # 5000개 넘으니 안됨

plot(house$sqft_living,house$price)

ggplot(data=mpg,aes(x=cty,y=hwy)) + geom_point()
ggplot(data=midwest,aes(x=poptotal,y=popasian))+geom_point()+xlim(0,500000)+ylim(0,1000)
df_mpg<-mpg%>%group_by(drv)%>%summarise(mean_hwy=mean(hwy))
df_mpg
df_mpg<-df_mpg%>%filter(!is.na(drv))
df_mpg
mpg<-as.data.frame(ggplot2::mpg)
df_mpg<-mpg%>%group_by(drv)%>%summarise(mean_hwy=mean(hwy))
df_mpg
ggplot(data=df_mpg,aes(x=drv,y=mean_hwy))+geom_col()
ggplot(data=df_mpg,aes(x=reorder(drv,-mean_hwy),y=mean_hwy))+geom_col()
ggplot(data=mpg,aes(x=hwy))+geom_bar()
head(mpg,1)
df<-mpg%>%filter(class=='suv')%>%group_by(manufacturer)%>%summarise(mean_cty=mean(cty))
df
ggplot(data=df,aes(x=reorder(manufacturer,-mean_cty),y=mean_cty))+geom_col()
ggplot(data=mpg,aes(x=class))+geom_bar()
ggplot(data=economics,aes(x=date,y=unemploy))+geom_line()
head(economics)
ggplot(data=economics,aes(x=date,y=psavert ))+geom_line()

ggplot(data=mpg,aes(x=drv,y=hwy))+geom_boxplot()
boxplot(x=mpg$drv,y=mpg$hwy)

mpg3<-mpg%>%filter(class %in% c('compact','subcompact','suv'))
ggplot(data=mpg3,aes(x=class,y=cty))+geom_boxplot()


library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)
raw_welfare <-read.spss('./Data/Koweps_hpc10_2015_beta1.sav',to.data.frame = T)
raw_welfare
head(raw_welfare)




#### 2. 다중회귀 분석 ####
#가설
# y=a1x1 + a2x2 + ... + b 

house <- read.csv('./Data/kc_house_data.csv',header = T)
str(house)


# 종속 변수 : price
# 독립 변수 : sqft_living(거실크기), floor, waterfront --> 3개의 변수 

fit2<-lm(price~ sqft_living + floors+waterfront,data=house)
summary(fit2)


#데이터에 변수가 20개가 넘기 때문에 어떻것이 유의한지 변수들을 넣고 빼보면서 어떤 변수가 집값을 나타낼때 큰 영향력을 나타내는지 알아봐야함.
#추가한 변수가 제대로 된 것인지 확인하는 것이 가장 큰일이라 볼 수 있음 
#변수를 측정하는 단위가 다름 --> 비표준화 계수 같은 단위로 표준화 시킬 필요가 있음 --> 표준화 계수로 살펴보기 

# 표준화 계수 : 변수들의 영향력을 확인해볼 수 있음. 
install.packages('lm.beta')
library(lm.beta)
fit3<-lm.beta(fit2)
summary(fit3) # Standardized 가 표준화 계수 ,     - 이 데이터는 달라지지 않음. 

### 변수들 간의 상관관계를 확인해봐야함 --> 변수들 간의 독립성을 유지해야하기 때문에 
### 다중공선성
#     1) 원인:독립변수들끼리 너무 많이 겹쳐서 발생하는 문제, 설명이 과해짐. 
#     2) 확인 방법 
#       - 산포도, 상관계수 : 상관계수가 0.9를 넘게 되면 다중공선성 문제(가장 강력하게 의심 해봐야 함)
#       - VIF(Variance Inflation Factor): 분산팽창지수
#           일반적으로 10보다 크면 문제가 있다고 판단(연속형 변수)
#           더미변수 일 경우에는 3이상이면 문제가 있다고 판단. 
#           sqrt(VIF) > 2 --> vif를 제곱근해서 
#     3) 해결 방법
#       - 일단 데이터에 대해서 잘 알아야함. 
#       - 유의한지 여부 --> 다중공선성이 크다해서 무조건 빼는것은 능사가 아님. 충분한 영향력을 주고 있다면 그냥 나두는 것도 하나의 방법
#       - 변수 제거 
#       - 주성분 분석 --> 일종의 중복되는 것을 빼버리는 것임. 
#       - 다중공선성이 발생한 독립변수들을 합치기 
#       - ...

# 독립변수 : sqft_living, bathrooms, sqft_lot,floors --> 묶어서 한번에 상관분석 
attach(house)#with를 써도 댐 
x <- cbind(sqft_living, bathrooms, sqft_lot,floors)
cor(x)#sqft_living  -bathrooms,      floors   - bathrooms 상관계수 높음 

#각 변수와 가격과의 상관분석
cor(x,price)

#가장 상관이 큰 거실 크기와 선형회귀
reg1<- lm(price~ sqft_living, data=house)
summary(reg1) # 나쁘지 않은 결과 설명력 49%

#거실 크기와 floors를 묶어서 회귀 분석석
reg2 <-lm(price~ sqft_living +floors, data=house)
summary(reg2) # --> floors는 경계선적으로 유의한데 조금 그래 그래서 더 살펴보자. 영향을 끼칠꺼 같은데? 그냥 버리기는 아쉬워
#그렇다면 p값을 높여보자 --> 이때 많이 사용하는게 매개변수, 조절변수, 상호변수 를 넣어보자

### 상호변수(상호작용?, 매개변수?,조절변수?- 반드시 넣어야 하는 것은 아님)을 살펴보면 p 값이 유의미해짐.
reg2_1 <-lm(price~ sqft_living +floors+sqft_living*floors, data=house)
summary(reg2_1)
# 그러나 t 값을 보면 p값은 유의하긴 한데 음수(-)임. 그렇다면 층수가 높아질수록 집 값이 떨어진다? 이런 말도 안되는 해석을 해야 함.
# 이 때 고려해봐야 하는게 다중공선성을 강하게 의심할 수 있음, 설명이 지나쳤나보다. 조절변수 빼야함. 

#다중공선성 확인 
install.packages('car')
library(car)
vif(reg2_1)
#sqft_living:floors : 21.987677  --> 어마어마한 수치 

#제곱근으로도 검증 가능 
sqrt(vif(reg2_1)) # 2 이상 넘어가니까 다중 공선성이 높은것 

#다른 변수 확인 
x <- cbind(floors,bedrooms)
cor(x) # 상관이 그렇게 높지 않네? 선형회귀 돌려보자
reg3 <- lm(price ~ floors+bedrooms, data=house)
summary(reg3) # 비표준화 계수가 양수값 괜찮네? 다중공선성 확인해보자 
vif(reg3) # 3보다 작고 10보다도 작네 괜찮쿤 --> 이렇게 찾아 가는 것임 


# 변수 더 추가해보자 
attach(house)
x <- cbind(floors,bedrooms,waterfront)
cor(x)

#집값과 변수들 간의 상관분석 확인 
cor(x,price) # 세 변수 다 어느정도 영향력이 있음.
reg4 <- lm(price~ floors+bedrooms+waterfront,data=house)
summary(reg4) # 다 유의하나 설명력이 떨어짐 
vif(reg4) # 다중 공선성도 다 낮네?? 세 변수는 같이 사용해도 되겠다.
sqrt(vif(reg4))

#방이 많으면서 수영장도 있으면?
reg5 <- lm(price~ floors+bedrooms+waterfront+bedrooms*waterfront,data=house)
summary(reg5) # 이렇게 하니까 수영장의 영향력이 유의하긴 하나 비표준 계수가 음수 수영장이 없을 수록 가격이 올라가? --> 다중공선성 의심
vif(reg5) # 다중공선성 10 넘어감 이 조절변수 못쓰겠네 

# 층수가 높으면서 수영장이 있으면?
reg6 <- lm(price~ floors+bedrooms+waterfront+floors*waterfront,data=house)
summary(reg6) # 좀 괴안네?
vif(reg6) # 다중공선성 다소 높긴 한데 그래도 p값이 유의하고 해석 가능한 결과가 나오기 때문에 이 변수들을 가지고 집값을 논할 수 있겠음

#### 실습 1 ####
head(state.x77)

states <- as.data.frame(state.x77[,c('Murder','Population','Income','Illiteracy','Frost')])
str(states)

fit <- lm(Murder ~ Population+ Illiteracy+ Income+Frost, data=states)
summary(fit)# 가장 유의한 것은 Illiteracy,  그 다음으로는   Population 가 유의함. 그 외는 유의하지 않음(income,frost)

#다중 공선성 검증 결과 굉장히 낮음. 
vif(fit)
sqrt(vif(fit)) # 그렇다면 이 결과를 그대로 받아 들여야 하는 것인가? 더 설득력 있게 할 수 는 없는가? 

### 이상치(이상치가 있는지 없는지)# 결측치는 이미 처리가 되어 있어야 함. 
# 1) 이상치(outlier) : 표준편차보다 2배 이상 크거나 작은 값 - y 축 기준 
# 2) 큰 지레점(High leverage points) --> 높은 영향력 점수? : p(절편을 포함한 인수들의 숫자(개수))/n 의 값이 2~3배 이상 되는 관측치가 있다면: 이상치로 의심해봐야함. // 인자의 갯수는 회귀계수- 기울기를 뜻함. 절편을 포함하니까 4개의 독립 1개의 절편 총 5개 / 행의 갯수 50 = 0.1 이것보다 2~3배 이상의 값은 이상치  --> x축 기준
# 3) 영향 관측치(Influential Obsevation, Cook's D) --> 원의 크기가 클 수록 이상치에 가까운 것임. 
#       독립변수의 수 / (샘플 수 - 예측인자의 수(회귀 계수)-1) 보다 클 경우 이상치 
#       4 / 50-4(회귀계수의 수)-1 = 0.08510638 반올림해서 0.1보다 크다면 이상치 
4/(50-3)

# 이 세가지를 한번에 보는 법
par(mfrow=c(1,1))
influencePlot(fit, id=list(method='identify'))
#평균은 0 으로 그래프에 표시댐 
# 그래프의 원을 누르고 finish를 누르면 그 데이터가 뭔지 알려줌. 

#이상치 확인하고 이제 회귀 분석을 돌린다.
#### 회귀모델의 교정 ####

fit <- lm(Murder ~ Population+ Illiteracy+ Income+Frost, data=states)
summary(fit) # 이 결과를 자신있게 설명을 하려면 제반 조건을 확인해야함

#그래프로 확인
par(mfrow=c(2,2))
plot(fit)

#정규분포 확인 --> 정규분포임 
shapiro.test(resid(fit))

### if 정규성을 만족하지 않을 경우(결과 변수에 람다승(임의의 수를 제곱해준다)을 해준다.) -> 해볼 수 있는 방법 중 하나
# 보통 대푯값으로 -2,-1,-0.5,0,0.5,1,2
powerTransform(states$Murder) #--> 실행 결과 --> 머더에 0.6을 제곱해주는게 어떠냐 하는 것임, 실제로 0.6을 제곱하는 것은 아님
summary(powerTransform(states$Murder))# 자세한 결과확인 할때, 이미 정규분포기 때문에 p값 차이가 없음.
#함수로 계산할때 는  y* 0.5 는 루트

### 선형성을 만족하지 않을 때 y=x^2
boxTidwell(Murder ~Population+ Illiteracy,data=states)


###  등분산을 만족 하지 않을 때 
#일단 등분산을 확인해보자
ncvTest(fit) # -> 확인 결과 등분산이 가정됨 

# 등분산이 가정이 안된다면 
spreadLevelPlot(fit) # 제곱을 얼마 해봐라 제안을 해주는 것임.


#### 좋은 변수들만 가지고 돌려보자 --> 근데 어떤게 좋은지 어떻게 알아??  자동으로 해주는게 있어

#### 회귀모델의 선택 ####
# AIC(Akaike's Infomation Criterion) - 수치, 이 값이 높고 낮은 것을 빼거나 추가하거나 
# Backward Stepwise Regression
#     - 모든 독립변수를 대상으로 하나씩 빼는 방법 
# Forward Stepwise Regression
#     - 변수를 하나씩 추가하면서 AIC 값을 측정 

fit1 <- lm(Murder~.,data=states) # . 은 모든 변수를 추가하겠다.
summary(fit1)

fit2 <- lm(Murder~Population+ Illiteracy, data=states)
summary(fit2)

AIC(fit1,fit2) # --> aic는 수치가 작아질수록 좋은 성능임. 

#### Backward Stepwise Regression, 가장 성능이 좋지 않을 것 같은 것부터 빼줌
full.model <-lm(Murder~.,data=states)
reduced.model<-step(full.model,direction = 'backward')
reduced.model

#### Forward Stepwise Regression, 가장 성능이 좋을 것 같은 것부터 추가해줌
min.model <-lm(Murder~ 1,data=states)
fwd.model <-step(min.model,direction = 'forward',
                 scope = (Murder~Population+ Illiteracy+ Income+Frost)) # 어떤 변수를 추가할지 입력해야함.
fwd.model

### All Subset Regression --> 다 돌려보는것 중간에 aic 값이 늘어나서 시도도 안하는 것도 다 돌려준다. 
install.packages('leaps')
library(leaps)

result <- regsubsets(Murder~.,data=states,nbest=4) # nbest=4 최대 몇개의 변수가 들어가는지 안려주는 것
result # 결과는 그래프로 확인 해야함.
par(mfrow=c(1,1))
plot(result,scale = 'adjr2') # scale -> adjr: 수정된 r  수정된 설명계수를 가지고 한 것 aic아님 



#### 실습 ####

mydata <- read.csv('./Data/regression.csv')
str(mydata)

# 가장 영향력이 있는 변수들은 무엇인가? 
# 정규성 검증, 보정하기 방법,  등분산성 검증, 다중공선성 검증 
# 어떤 독립변수들이 출산율과 관계가 있는가? 

# Backward, Forward
full.model2 <- lm(birth_rate ~.,data=mydata)
summary(full.model2)
str(mydata)
table(is.na(mydata))
head(mydata,1)


fit4<-lm(birth_rate~cultural_center + social_welfare +active_firms + pop + urban_park +doctors  + tris +kindergarten,data=mydata)

summary(fit4)
library(lm.beta)
fit5 <- lm.beta(fit4)
summary(fit5)
vif(fit4)
sqrt(vif(fit4))
attach(mydata)
x<-cbind(cultural_center,social_welfare,active_firms,pop,urban_park,doctors,tris,kindergarten)
cor(x)
cor(x,birth_rate)

#가장 상관이 큰 두 변수 선형 회귀
reg4 <-lm(birth_rate~kindergarten+pop,data=mydata)
summary(reg4)
reg5 <-lm(birth_rate~kindergarten+pop+kindergarten*pop,data=mydata)
summary(reg5)
reg6<-lm(birth_rate~social_welfare+active_firms+tris, data=mydata)
summary(reg6)
vif(reg4)
par(mfrow=c(1,1))
influencePlot(fit4, id=list(method='identify'))
par(mfrow=c(2,2))
plot(fit4)

#정규그래프가 아님
shapiro.test(resid(fit4))
powerTransform(mydata$birth_rate) 
summary(powerTransform(mydata$birth_rate) )

#등분산도 아님
ncvTest(fit4) 
spreadLevelPlot(fit4) 


full.model2 <-lm(birth_rate~cultural_center + social_welfare +active_firms + pop + urban_park +doctors  + tris +kindergarten,data=mydata)
reduced.model2<-step(full.model2,direction = 'backward')
reduced.model2
#birth_rate ~ social_welfare + active_firms + pop + tris + kindergarten

#### Forward Stepwise Regression, 가장 성능이 좋을 것 같은 것부터 추가해줌
min.model2 <-lm(birth_rate~1,data=mydata)
fwd.model2 <-step(min.model2,direction = 'forward',
                 scope = (birth_rate~cultural_center + social_welfare +active_firms + pop + urban_park +doctors  + tris +kindergarten)) # 어떤 변수를 추가할지 입력해야함.
fwd.model2
#birth_rate ~ pop + doctors + active_firms + tris + social_welfare + kindergarten


### All Subset Regression --> 다 돌려보는것 중간에 aic 값이 늘어나서 시도도 안하는 것도 다 돌려준다. 
install.packages('leaps')
library(leaps)

result <- regsubsets(birth_rate~cultural_center + social_welfare +active_firms + pop + urban_park +doctors  + tris +kindergarten,data=mydata,nbest=8) # nbest=4 최대 몇개의 변수가 들어가는지 안려주는 것
result # 결과는 그래프로 확인 해야함.
par(mfrow=c(1,1))
plot(result,scale = 'adjr2') # scale -> adjr: 수정된 r  수정된 설명계수를 가지고 한 것 aic아님 

head(mydata,1)
mydata<-mydata[,-1]
head(mydata)
fit6 <- lm(birth_rate~.,data=mydata)
summary(fit6)

#백야드로 살펴보기
full.model3 <-lm(birth_rate~.,data=mydata)
reduced.model3<-step(full.model3,direction = 'backward')
reduced.model2
#social_welfare + active_firms + pop + tris + kindergarten

#### Forward Stepwise Regression, 가장 성능이 좋을 것 같은 것부터 추가해줌
min.model3 <-lm(birth_rate~1,data=mydata)
fwd.model3 <-step(min.model3,direction = 'forward',
                  scope = (birth_rate~dummy+cultural_center + social_welfare +active_firms + pop + urban_park +doctors  + tris +kindergarten)) # 어떤 변수를 추가할지 입력해야함.
fwd.model2
#birth_rate ~ pop + doctors + active_firms + tris + social_welfare + kindergarten


### All Subset Regression --> 다 돌려보는것 중간에 aic 값이 늘어나서 시도도 안하는 것도 다 돌려준다. 
install.packages('leaps')

result <- regsubsets(birth_rate~.,data=mydata,nbest=9) # nbest=4 최대 몇개의 변수가 들어가는지 안려주는 것
result # 결과는 그래프로 확인 해야함.
par(mfrow=c(1,1))
plot(result,scale = 'adjr2')
library(leaps)