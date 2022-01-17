#### 기술통계량 ####

### table()
aws <-read.delim('./Data/AWS_sample.txt',sep="#")
getwd()
setwd('C:/Users/Administrator/Downloads/seonmin/Rwork')
head(aws)
tail(aws)
str(aws)
aws

# 데이터 개수 확인
table(aws$AWS_ID)
?table

table(aws$AWS_ID,aws$X.)
View(aws)

table(aws[,c('AWS_ID','X.')])

aws[2500:3100,'X.']='modified'
aws[2500:3100,'X.']

table(aws$AWS_ID,aws$X.)

#비율로 데이터 확인하기 
prop.table(table(aws$AWS_ID))
prop.table(table(aws$AWS_ID))*100

### mean():평균, medien():중앙값, var(): 분산, sd():표준편차,quntil():사분위수, summary()...

#### 데이터 처리를 위한 도\구두 ####

### plyr
### dplyr # 패키지 설치해야함 
install.packages('dplyr')
library(dplyr)
?dplyr

exam <- read.csv('./Data/csv_exam.csv')
exam

### filter()

# 1반 학생들의 데이터 추출 
subset(exam, exam$class==1)
exam[exam$class==1,]

filter(exam,class==1)
exam %>% filter(class==1)
# 순서를 

#2반이면서 영어 점수가 80이상인 데이터만 추출
subset(exam,exam$class==2 & exam$english >=80)
exam[exam$class==2 &exam$english>=80,]
exam %>% filter(class==2 & english >= 80)
exam %>% filter(class %in% c(2,3) &english >=80)
#1,3,5 반에 해당하는 데이터만 추출 
exam %>% filter(class ==1 | class==3 | class==5) #| or
# 같거나 or 는 in을 사용 
exam %>% filter(class %in% c(1,3,5))

library()
### select() sql의 셀렉트와 동일함 
#내가 원하는 컬럼만 선택할 수있음 

#수학점수만 추출
exam[,3] # 벡터를 리턴 
exam %>% select(math) # 데이터 프레임을 리턴

#반, 수학,영어점수 추출 
exam[,c(2,3,4)] #가독성이 떨어짐 
exam %>% select(class,math,english)

#수학점수를 제외한 나머지 칼럼을 추출
exam %>% select(-math)

# 1반 학생들의 수학점수만 추출(2명까지만 표시)
#select math from exam where class= 1 limit 2;#sql
exam %>% filter(class==1) %>% select(class,math) %>% head(2)


### arrange() 정렬
exam %>% arrange(math) #기본이 오름 차순
exam %>% arrange(desc(math)) # 내림차순 
exam %>% arrange(class,math) # 반부터 정렬하고 그안에서 수학점수를 정렬 

###mutate()
# 각 과목의 합계 
# 기존 방법 
exam$sum <-exam$math + exam$english + exam$science
exam
#평균 
exam$mean <- exam$sum/3
exam
summart
#열지우기 
exam <- exam[,-c(6,7)]
exam

#mutate()활용
exam %>% mutate(sum=math+english+science,mean=sum/3) # 원본에 저장은 안됨 그래서 할당을 해줘야 함 
exam 

exam<-exam %>% mutate(sum=math+english+science,mean=sum/3)
exam

### summarise()
exam %>% summarise(mean_math= mean(math)) #하나의 수학 평균점수로 요약 해버린것 
exam %>% mutate(sum=math+english+science,mean=sum/3) %>% arrange(desc(mean))
###groupby() 가장 핵심
exam %>% group_by(class)%>% summarise(mean_math=mean(math),sum_math=sum(math),median_math=median(math),count=n())

###left_join(), bind_rows()
test1 <- data.frame(id=c(1,2,3,4,5), mditerm=c(60,70,80,90,85))
test2 <- data.frame(id=c(1,2,3,4,5), mditerm=c(70,83,65,95,80))

left_join(test1,test2, by='id')
bind_rows(test1,test2)


#### 연습문제 1 ####
install.packages('ggplot2')
library(ggplot2)
head(ggplot2::mpg)
table(ggplot2::mpg$drv)
table(ggplot2::mpg$fl) 연료 

mpg <- as.data.frame(ggplot2::mpg)
str(mpg)
tail(mpg)
table(mpg$manufacturer)
names(mpg)
View(mpg)

# 배기량(displ)이 4이하인 차량의 모델명, 배기량, 생산년도 조회
mpg %>% filter(displ<=4) %>% select(model,displ,year)

# 통합연비 파생변수(total)를 만들고 통합연비로 내림차순 정렬을 한 후에 3개의 행만 선택해서 조회
# 통합연비 : total <- (cty + hwy)/2
mpg <- mpg %>% mutate(total=(cty+hwy)/2) %>% arrange(desc(total))
head(mpg,3)

mpg %>% mutate(total=(cty+hwy)/2, 
               grade= if(total >= 30){'A'}else if(total >=25){'B'}else{'C'})
                #total은 벡터      1개  --> 그래서 에러가 남 

fngrade <- function(tot){
  if(tot>=30){
    return('A')
  }else if(total>=25){
    return('B')
  }else{
    return('C')
  }
}
mpg %>% mutate(total=(cty+hwy)/2, grade=fngrade(total))
mpg %>% mutate(total=(cty+hwy)/2,
               grade=ifelse(total>=30,'A',ifelse(total>=20,'B','C')))
# 회사별로 "suv"차량의 도시 및 고속도로 통합연비 평균을 구해 내림차순으로 정렬하고 1위~5위까지 조회
mpg <- mpg[,-12]
mpg
mpg %>%group_by(manufacturer)%>%summarise(total=(cty+hwy)/2)%>%arrange(desc(total))%>%head(5)
mpg %>% filter(class=='suv')%>%group_by(manufacturer)%>%summarise(total=(cty+hwy)/2)%>%arrange(desc(total))%>%head(5)
mpg %>% filter(class == "suv") %>% group_by(manufacturer) %>% summarise(mean_cty=mean(cty), mean_hwy=mean(hwy)) %>% arrange(desc(mean_cty)) %>% head(5)
# 어떤 회사의 hwy연비가 가장 높은지 알아보려고 한다. hwy평균이 가장 높은 회사 세곳을 조회
mpg %>% group_by(manufacturer)%>%summarise(mean_hwy=mean(hwy)) %>% arrange(desc(mean_hwy)) %>% head(3)
  

# 어떤 회사에서 compact(경차) 차종을 가장 많이 생산하는지 알아보려고 한다. 각 회사별 경차 차종 수를 내림차순으로 조회



# 연료별 가격을 구해서 새로운 데이터프레임(fuel)으로 만든 후 기존 데이터셋과 병합하여 출력.
# c:CNG = 2.35, d:Disel = 2.38, e:Ethanol = 2.11, p:Premium = 2.76, r:Regular = 2.22
# unique(mpg$fl)



# 통합연비의 기준치를 통해 합격(pass)/불합격(fail)을 부여하는 test라는 이름의 파생변수를 생성. 이 때 기준은 20으로 한다.



# test에 대해 합격과 불합격을 받은 자동차가 각각 몇대인가?



# 통합연비등급을 A, B, C 세 등급으로 나누는 파생변수 추가:grade
# 30이상이면 A, 20~29는 B, 20미만이면 C등급으로 분류

#### 연습문제 2 ####
### 미국 동북구 473개 지역의 인구 통계정보 
midwest <-as.data.frame(ggplot2::midwest)
str(midwest)

# 전체 인구대비 미성년 인구 백분율(ratio_child) 변수를 추가


# 미성년 인구 백분율이 가장 높은 상위 5개 지역(county)의 미성년 인구 백분율 출력


# 분류표의 기준에 따라 미성년 비율 등급 변수(grade)를 추가하고, 각 등급에 몇개의 지역이 있는지 조회
# 미성년 인구 백분율이 40이상이면 "large", 30이상이면 "middel", 그렇지않으면 "small"


# 전체 인구 대비 아시아인 인구 백분율(ratio_asian) 변수를 추가하고 하위 10개 지역의 state, county, 아시아인 인구 백분율을 출력


#-----------------------------------------------------------------------

### 1. 데이터 탐색

## 변수명 바꾸기
df_raw <- data.frame(var1=c(1,2,3), var2=c(2,3,2))
df_raw

# 기본 내장함수
df_raw1 <-df_raw
names(df_raw1) <-c('v1','v2')
df_raw1
library(dplyr)
df_raw2<-df_raw
df_raw2 <- rename(df_raw2,v1=var1,v2=var2)
df_raw2

### 2. 결측치 확인

dataset1<- read.csv('./Data/dataset.csv',header = T)
getwd()
setwd("C:/Users/Administrator/Downloads/seonmin/Rwork")
dataset1
#데이터 탐색
str(dataset1)
head(dataset1)
##참고
# resident : 1 ~ 5까지의 값을 갖는 명목변수로 거주지를 나타낸다.
# gender : 1 ~ 2까지의 값을 갖는 명목변수로 남/녀를 나타냄
# job : 1 ~ 3까지의 값을 갖는 명목변수. 직업을 나타냄
# age : 양적변수(비율) : 2 ~ 69
# position : 1 ~ 5까지의 값을 갖는 명목변수. 직위를 나타냄
# price : 양적변수(비율) : 2.1 ~ 7.9
# survey : 만족도 조사 : 1 ~ 5까지 명목변수

#가격만 뽑아서 보기 
y<-dataset1$price
plot(y)
x <-dataset1$age
plot(x)

#결측치 쉽게 확인할 수 있는 방법들 
summary(dataset1$price)
summary(dataset1$job)

# 결측치 제거 
sum(dataset1$price) # 총합을 보고 싶을때 이렇게 sum을 쓰지만 결측치가 있으면 계산이 되지 않는다. 
sum(dataset1$price,na.rm=T) # sum에는 자동으로 결측치를 잠시 미뤄두고 합계 구해주는 인자 na.rm=T, 완전히 결측치 제거는 아님 
mean(dataset1$price)
mean(dataset1$price,na.rm = T)

#완전히 결측치 제거
price2<-na.omit(dataset1$price)
summary(price2)

# 결측치 대체: 0으로 대체 조건문 이용 
price3<-ifelse(is.na(dataset1$pric),0, dataset1$price)
#              데이터 베이스 프라이스가 결측치이면, 0으로 바꾸고, 그렇지 않으면 그냥 냅둬라 
summary(price3)
sum(price3)
mean(price3)

#결측치 대체: 평균으로 대체 
price4 <-ifelse(is.na(dataset1$price),mean(),dataset1$price)

price4<-ifelse(is.na(dataset1$price), 
               round(mean(dataset1$price, na.rm = T),2),
               dataset1$price)
summary(price4)
head(price4)

mean0<-mean(dataset1$price, na.rm=T)
price4 <- ifelse(is.na(dataset1$price), mean0, dataset1$price)
summary(price4)


### 3. 이상치 처리
## 양적변수와 질적변수의 구별 

## 질적변수 : 도수분포표, 분할표 --> 막대그래프(두개의 변수), 원 그래프 ...
table(dataset1$gender)
pie(table(dataset1$gender)) #--> 파이그래프, 그래프를 그려보면 이상치 확인이 쉬움. 

## 양적변수 : 산술평균, 조화평균, 중앙값 -> 히스토그램(막대긴하나 연속적인 변화값을 보여줌, 단일 변수), boxplot, 시계열 도표, 산포도...
summary(dataset1$price)
length(dataset1$price)
str(dataset1)
plot(dataset1$price)# 산포도
#그럼 어디까지를 이상치로 볼것인가?
boxplot(dataset1$price)

## 이상치 처리 -잘라내기
dataset2<-subset(dataset1,price >=2 & price<=8)# 범위 지정 
length(dataset2$price)
plot(dataset2$price)
boxplot(dataset2$price) #중앙값,최대, 최소값, 어디에 많이 분포되어 있는지 나옴 

### 4. Feature & Engineering
View(dataset1)

## 가독성을 위해 resident 데이터 변경(1->서울,2->인천,3->대전,4->대구,5->시구군)
dataset2$resident2[dataset2$resident==1] <-'1.서울특별시'
dataset2$resident2[dataset2$resident==2] <-'2.인천광역시'
dataset2$resident2[dataset2$resident==3] <-'3.대전광역시'
dataset2$resident2[dataset2$resident==4] <-'1.대구광역시'
dataset2$resident2[dataset2$resident==5] <-'1.시구군'

head(dataset2)

##  Binning: 척도 변경(양적 --> 질적)
# 나이 변수를 청년층(30세 이하), 중년층(31~55이하), 장년층(56~)
dataset2$age2[dataset2$age<=30] <-'청년층'
dataset2$age2[dataset2$age>30 & dataset2$age <=55] <-'중년층'
dataset2$age2[dataset2$age>55] <-'장년층'
head(dataset2)

## Dummy 척도변경(질적 --> 양적) 보통 0 or 1로 변경 가중치를 주지 않기 위해 
user_data <- read.csv('./Data/user_data.csv',header = T)
user_data 

# 거주 유형: 단독주택(1), 다가주주택(2), 아파트(3), 오피스텔(4), 1,2를 0으로 34,를 1로
user_data$house_type2<-ifelse(user_data$house_type==1 | user_data$house_type ==2, 0,1)
table(user_data$house_type2)


## 데이터의 구조 변경(wide type, long type)
# reshape, reshape2, tidyr...

install.packages("reshape2")
library(reshape2)

data()

str(airquality)
head(airquality)
#컬럼별로 데이터가 퍼져있는 상태 wide , long형으로 바꾸기 --> melt,  cast : -->wide 형으로 변환 

me <-melt(airquality, id.vars = c('Month','Day')) #롱형
me
#변수 이름 따로 주고 싶을 떄 
me1<-melt(airquality, id.vars = c('Month','Day'),
          variable.name = 'climate')
me1

# long --> wide로  cast()
?dcast
dc1 <- dcast(me1, Month+Day ~ climate)
dc1

data <- read.csv('./Data/data.csv')
data
data1 <-dcast(data, Customer_ID ~ Date)
data1

data2 <-melt(data1, id.vars = 'Customer_ID',variable.name = 'Date',
             value.name = 'Buy')
data2

data <- read.csv('./Data/pay_data.csv')
data
#product_type을 wide하게 변경
data_wide <-dcast(data,user_id ~ product_type)
data_wide <-dcast(data,user_id ~ product_type,mean)
data_wide

#wide 하게 여러가지 변수를 묶어서 기준을 세울 수 있음. 
type_data1 <-dcast(data, user_id + pay_method +price ~ product_type)
type_data1


#### 연습문제 3 ####
## 극단적 선택의 비율을 어느 연령대 가 가장 높은가?(사망 원인 통계)
death <- read.csv('./Data/사망원인_103항목__성_연령_5세_별_사망자수__사망률_20211014155157.csv',header=T)
library(xlsx) 
death1 <-read.xlsx('./Data/사망원인_103항목__성_연령_5세_별_사망자수__사망률_20210506164121.xlsx')
str(death)
summary(death)
head(death)
