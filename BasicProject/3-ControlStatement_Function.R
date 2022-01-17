#### 조건문 ####

### 난수 
?runif
x <- runif(1) #0과 1 사이의 난수를 구해라 
x

# x가 0.5 보다 크면 출력해라 
if(x >.5){
  print(x)
}

# x가 0.5보다 작으면 1-x를 출력하고 그렇지 않으면 x를 출력 
if(x < 0.5){
  print(1-x)
}else{
  print(x)
}

#한줄일때는 이렇게 한줄로 해도 됨.
if(x < 0.5) print(1-x) else print(x)

####if, else를 좀 더 쉽게 쓸 수는 없을까? 해서 나온게 ifelse()
ifelse(x<.5,1-x,x) #조건이 이럴때, 이것을 출력하고, 그렇지 아니면 요것을 출력해라

#### 다중 조건문
avg <-scan()

if(avg >= 90){
  print('당신의 학점은 A입니다.')
}else if(avg >=80){
  print('당신의 학점은 B입니다.')
}else if(avg >=70){
  print('당신의 학점은 C입니다.')
}else if(avg >=60){
  print('당신의 학점은 D입니다.')
}else{
  print('당신의 학점은 F입니다.')
}

### which(): 값의 위치(index)를 찾아주는 함수
#vector 에서 사용 
x <-c(2:10)
which(x==3)

#값을 꺼내오기
x[which(x==3)]

#matrix 에서 사용 
m <- matrix(1:12,3,4)
m

?which
which(m%%3 ==0)# 위치가 아니라 값자체를 가져온것
which(m%%3 ==0, arr.ind = F)
which(m%%3 ==0, arr.ind = T)#위치를 알려줌


#data.frame에서 사용
no <-c(1:5)
name <-c('츄','솜','윈터','카리나','슬기')
score <- c(85,78,98,90,74)
exam <-data.frame(학번=no,이름=name,성적=score)
exam

#이름이 장비인 사람을 검색
which(exam$이름=='윈터') # 위치가 나옴 
exam[which(exam$이름=='윈터'),] #값들 전체 
exam[4,] # 값들 전체 

# which의 파생 함수, which.min() 숫자만 가능 
# 가장 높은 점수를 가진 학생을 찾아라 
which.max(exam$성적)
exam[which.max(exam$성적),]

### any(): or 연산, all():and 연산
x <- runif(5)
x
# x 값들 중에서 .8이상이 있는가?(or)
any(x>=.8)

# x 값들이 모두(and) .7이하인가?
all(x <=.7)



#### 반복문 ####

# 1 부터 10까지 합계
sum <- 0 # 초기값 설정 #seq는 range와 동일한 역할
for(i in seq(1,10)){
  sum <- sum+i
}
print(sum)

sum <- 0
for(i in 1:10) sum <-sum +i
print(sum)
seq(1,10)
xx
#### 함수 ####
test1 <-function(){
  x<-10
  y<-20
  
  print(x * y)
}
test1()

test1 <-function(){
  x<-10
  y<-20
  
  #print(x * y)
  return(x*y)
}
v<-test1()
v

### 인자 있는 함수
test2 <- function(x,y){
  a<-x
  b<-y
  
  return(a-b)
}

test2(20,100)
test2(y=300,x=10) # 변수명을 넣어 주면 순서 상관 없이 입력 가능

### 가변 인수: ...
test3<-function(...){
  print(list(...))
}
test3(10)
test3(10,20,30)
test3('3','츄',30)

test3 <-function(...){
  for(i in list(...)){
    print(i)
  }
}
test3(10)
test3(10,20,30)
test3('3','츄',30)

getwd()
setwd('C:/Users/Administrator/Downloads/seonmin/Rwork')

#### 문자열 함수 ####

### 정규 표현식(Regular Expression)
#: 특정한 규칙을 가진 문자열의 집합을 표현하는데 사용하는 형식 언어
install.packages('stringr')
library(stringr)

str1 <- '츄45김선민45카리나53윈터30슬기27'
#여기서 숫자만 뽑아내고 싶다? 어떻게?

str_extract(str1,"\\d{2}")# 하나만 뽑는 것
str_extract_all(str1,'\\d{2}')
class(str_extract_all(str1,'\\d{2}'))
#벡터형으로 변환
unlist(str_extract_all(str1,'\\d{2}'))

#문자열 가져오기
str_extract_all(str1,'[가-힣]+')

str2<- 'Chuu1400karina10004winter400신예은0055'
str_extract_all(str2,'[a-zA-Z가-힣]+')

str2 <- "hongkd105leess1002you25TOM400강감찬2005"
str_extract_all(str2,'[a-zA-Z가-힣]+')
unlist(str_extract_all(str2,'[a-zA-Z가-힣]+'))
#길이 구하기 
length(str2) # 하나의 데이터로 취급 
str_length(str2)

#위치
str_locate(str2,'신예은')

#추가하기 
str_c(str2,'슬기29') #--> 새로운 객체를 만드는 것

str2 # --> 원본에서는 추가가 안되어 있음 

#원본에도 추가하려면 
str2 <- str_c(str2,'슬기29') 

str3 <- 'Chuu1400,karina10004,winter400,신예은0055'
str_split(str3,',')




