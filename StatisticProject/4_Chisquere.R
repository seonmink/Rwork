#### 실습 ####

str(mtcars)
head(mtcars)

#주제: 자동차의 실린더 수와 변속기의 관계가 있는지 알고 싶다. -- 둘다 명목 변수
table(mtcars$cyl, mtcars$am)

#테이블의 가독성을 높이기 위해 전처리 
mtcars$tm <- ifelse(mtcars$am ==0,'auto','manual')
result <-table(mtcars$cyl, mtcars$tm)
result

barplot(result)
barplot(result,ylim=c(0,20))# y축 눈금 늘리기
barplot(result,ylim=c(0,20), legend=rownames(result)) # 범례 추가 

#범례 알아보기 용이하게 
mylegend <- paste(rownames(result),'cyl')
mylegend
barplot(result,ylim=c(0,20), legend=mylegend)

#막대그래프 수직으로 볼때 
barplot(result,ylim=c(0,20), legend=mylegend,beside = T)

#수평으로 보고 싶을 때
barplot(result,ylim=c(0,20), legend=mylegend,beside = T,horiz=T)
barplot(result,ylim=c(0,20), legend=mylegend,horiz=T)

#색 넣기 
barplot(result,ylim=c(0,20), legend=mylegend,beside = T,horiz=T,
        col=c('tan1','coral2','firebrick2'))



#행과 열의 합계 자동으로 넣어주는 함수
result
addmargins(result)


#카이제곱 검증
chisq.test(result)
# 경고메시지가 나오는데 --> 데이터 수가 충분하지 않기 때문 --> Fisher's exact test 써야함
fisher.test(result)


####실습 2 ####
mydata <- read.csv('./Data/anova_two_way.csv')
str(mydata)
head(mydata)

### 주제 : add_layer(시,군,구)와 multichild(다가구 자녀지원 조례)가 관계가 있는가?
table(mydata$ad_layer, mydata$multichild)
result <-table(mydata$ad_layer, mydata$multichild)
chisq.test(result)
fisher.test(result)
barplot(result,ylim=c(0,250))
#--> 카이스퀘어 검즘 결과 관계가 없음 


#### 실습3 ####
install.packages("foreign")
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_welfare <- read.spss('./Data/Koweps_hpc10_2015_beta1.sav', to.data.frame = T)
welfare <- rename(raw_welfare, sex=h10_g3, birth=h10_g4, marriage=h10_g10,
                  religion=h10_g11, income=p1002_8aq1, code_job=h10_eco9,
                  code_region=h10_reg7)
welfare <- welfare[, c("sex", "birth", "marriage", "religion", "income",
                       "code_job", "code_region")]
str(welfare)
head(welfare)

### 주제: 성별과 종교는 서로 연관성이 있는가?
result<-table(welfare$sex,welfare$religion)

chisq.test(result) # 남자가 더 연관을 미치는지는 알아볼 것. 


#### 실습 4: Cocran-Armitage Trend Test ####

library(moonBook)
str(acs)
head(acs)
#### 주제: 흡연여부와 고혈압의 유무가 서로 관련이 있는가?

acs$smoking <-factor(acs$smoking, levels=c('Never','Ex-smoker','Smoker'))#순서가 있을 경우
result<-table(acs$HBP, acs$smoking)
result
barplot(result,ylim = c(0,400))
chisq.test(result)
?prop.trend.test

#고혈압이 발생한 사람의 수(x)
result[2,]

#smoking 시도 횟수(n)
colSums(result)#-> 전체 
prop.trend.test(result[2,],colSums(result))
# 관계가 있다는 것이지 담배를 많이 피면 고혈압에 걸린다라는 것은 아님 
# --> 즉 인과관계는 알 수 없음. 

# 그래프로 확인해보기 
mosaicplot(result)
mosaicplot(result,col=c('snow1','snow3','violet'))

#색상 코드
colors()
demo('colors') # 색상 확인하기

#t(result) 행열 바꾸기 
mosaicplot(t(result),col=c('snow1','snow3','violet'))

#X,Y 라벨 붙이기
mosaicplot(t(result),col=c('snow1','snow3','violet'),
           xlab = 'Smoking',ylab='Hypertension')

#해석 --> 단순히 담배 많이 필수록 고혈압 적게걸리나? 말도 안되는 결과임 해석할 수 없음(회귀분석에서나 가능), 중요 변수 빠져 있음.

mytable(smoking~age,data=acs) #age 를 조정변수, 여러개의 변수를 다양하게 넣고 봐야함.
