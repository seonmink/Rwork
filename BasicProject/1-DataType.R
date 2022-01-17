#여기다가 코드를 작성
#r 도 파이썬과 마찬가지로 모두 객체임--> class?, 설계도, 함수 묶음, 객체에 접근은 메모리를 사용한다는 것 .을 이용하여 변수, 함수 
#파이써는 프로그램 성격이 강해서 class를 직접 만들어야 하지만 r은 직접 만들지 않음 이미 만들어져 있는 것을 가져다 쓰기만 하면 됨됨

##### 변수 #####  
#앞 뒤로 # 4개면 그룹화를 할 수 있음 보고 싶을때 보게 하는 

chuu = '김지우'
# 변수 사용시 객체 형태로 사용하는 것을 권장 
chuu.name ='이달의 소녀'
chuu.code ='지켜츄'
chuu.price = 600000

chuu.name
# 객체로 접근하는 것이 아니라 하나의 변수로 사용

#값을 대입할때는 = 보다는 <-를 사용한다. 
chuu.name <-'이달의 소녀'
chuu.code <-'지켜츄'
chuu.price <- 600000
chuu.name

#데이터 타입 확인 함수
class(chuu.name)
class(chuu.price)
mode(chuu.name)
mode(chuu.price)

# 파이썬에서는 str, int, float, list, tuple, dict, bool, set


#### Vector ####

#c() 백터를 만들어주는 함수
v <- c(1,2,3,4,5)
v
class(v)
mode(v)

#변수 설정하고 부르고 싶다면
(v <-c(1,2,3,4,5))
#괄호를 묶어주면 됨, 프린트함수와 동일한 역할 

c(1:5)
#연속적일 때는 범위 연산자 사용 

c(1,2,3,4,'5') # 모든 데이터가 문자로 바귐

#### seq()
#어떤 함수나 객체의 ?seq 를하면 도움말이 나옴
?seq
seq(from=1, to=10, by=2)
#1 부터 10까지 2씩 증가하는 백터를 만들어라
seq(1,10,2)#생략 가능

#### rep() 반복
rep(1:3,3)# 1에서 3까지 3번 반복해라 

#### 벡터의 접근
v <- c(1:50)
v[10:45] #인덱스를 사용해서 슬라이싱 가능 10번째 부터 45번째 까지
length(v) #길이 확인 

v[10 : (length(v)-5)] # length v =50, 50-5=45 --> 10:45
v[10: length(v) -5] #10:length 에서 5 빼서 계산

v1<-c(13, -5, 20:23,12,-2:3)
v1

v1[1] # 데이터가 0부터 시작하지 않는다. 1부터 시작 
v1[c(2,4)]
v1[c(4,5:8,7)]
v1[-1] # 파이썬에서는 인덱스 - 값 주면 뒤에서 부터였는데, 얘는 첫번째꺼 빼고 나머지. 그래서 13이 없어지고 -5부터 나옴. 
v1[-2] # 인덱스 2를 빼고 나머지 반환 그래서 -5가 빠진 나머지 

v1[c(-2,-4)] # 여러개를 뺄 때는 벡터를 사용하여 처리하면 됨됨
v1[- c(2,4)]

#### 집합 연산
x <-c(1,3,5,7)
y<- c(3,5)

union(x,y) #합집합
setdiff(x,y) #차집합
intersect(x,y) #교집합

union(x,y);setdiff(x,y);intersect(x,y)

#### 칼럼명 지정 
age <- c(30,35,40)
names(age) <- c('츄','카리나','윈터')
age


#### 변수의 제거 
age <- NULL #데이터를 지우는게 아니라 주소를 지우는 것 
age


#### 벡터 생성의 또 다흔 표현
x <- c(2,3)
x <- (2:3) #범위로 만들 때 c를 생략 할 수 있음.
x
x<-(2,3) ## 단 ,로 구분 되는건 안된다. 
y <-(2:3)
class(x)# 
class(y) # 실제 어떤 타입으로 저장되어 있는지  

mode(x) #물리적 타입 mode
mode(y)


#### factor #####
#데이터 형식 
#숫자(양적) - 연속(셀수 없는것,계속 시간이 지나가는)  문자(질적) -명목
    # - 이산(셀수 있는 변수)                                     -서열: 숫자는 아니지만 순서를 따질 수 있는 
# 명목--> 범주 데이터 
#e.g. 22,23,28,37,39,40 연속 데이터 
# but 20대 30대 40대로 묶으면?  질적 데이터가 됨. 이렇게 해주는 것이 factor !!!! 
like <-c('chuu','winter','winter','chuu','chuu')
like
class(like)
mode(like)
is.factor(like) #이 변수가 팩터이냐? 
plot(like) # 벡터 자체는 그래프를 그릴 수 없음. 

# 요약된 형태로 봐보자 츄와 윈터로
nlike <- as.factor(like)
nlike
class(nlike) # 어떤 클레스로 만들어졌냐
mode(nlike) #실제 적용되는 형식을 파악(숫자냐 문자냐)
is.factor(nlike)
plot(nlike)
table(nlike) # 빈도표 확인할 수 있음
#요약이 됬기 때문에 가능한것 

?factor
gfactor <- factor(like, levels=c('chuu','winter'),ordered=TRUE)
gfactor
plot(gfactor)





#### Matrix ####
#백터만 c 라는 함수 나머지는 본인 이름의 함수 존재
# matrix()
m <-matrix(c(1:5))
m
m <-matrix(1:5)
m
# 백터를 범위로 생성할 때는 c 생략 가능험

m <- matrix(1:11,nrow = 2) # 짝이 안맞는다고 경고하지만 에러는 아님 짝이 맞지 않는 것은 맨 처음 값으로 넣어줌. 
m
m<-matrix(1:10, nrow = 2)
m
m<-matrix(c(1:10), nrow = 2, byrow = TRUE)
m
#파이썬에서 트루 펄스 앞문자만 대문자로 했는데 r에서는 다 대문자로 해줘야 함 
m<-matrix(1:10, nrow = 2,byrow = T)
m
class(m)
mode(m)

#rbind(), cbind() -> 두개의 벡터 합쳐서 행렬 만들기 
x1 <- c(3,4,50:52)
x2 <- c(30,5,6:8,7,8)
x1
x2

mr <-rbind(x1,x2) # 행으로 합치기 
mr

mc <-cbind(x1,x2) # 열로 합치기
mc

# matrix 차수 확인
x <- matrix(c(1:9),ncol = 3) # 
x
length(x) # 길이 
nrow(x) #행 
ncol(x) #열
dim(x) # 차원

#칼럼명 지정 
colnames(x) <-c('츄','윈터','카리나')
x
#칼럼 이름만 가져오기
colnames(x)

# apply(변수,margin, 함수) 파이썬 map과 매칭을 하는 역할을 함
?apply
apply(x, 1, max)
# margin -> 1 는 행 기준 , 2는 열 기준
apply(x, 2, max)


#### data.frame ####

# data.frame()
no <- c(1,2,3)
name <- c('chuu','winter','karina')
pay <- c(150.25,250.18,300.34)
#서로 다른 형태기 때문에 matrix 로는 합칠 수가 없음 그래서 데이터 프레임 사용
#data.frame(필드명= 변수, 필드명= 변수,....)
emp <- data.frame(No=no, NAME=name, PAYMENT = pay)
emp

# read.csv(), read.table(), read.delim() 파일로 부터 읽어온다. 

getwd()#알아내겠다 work directory 를를
txtemp<-read.table('C:/Users/Administrator/Downloads/seonmin/Rwork/Data/emp.txt')  #이건 절대 경로 근데 이러면 너무 길어
txtemp
# 상위 폴더로 나가서 불러오기
txtemp<-read.table('../Data/emp.txt')
txtemp

#작업 위치 변경 
setwd('../Data')
#작업 위치 확인
getwd()
#그러면 가져올 파일이 지금 작업 위치기 때문에 파일명만 써도 가져올 수 있음.
txtemp<-read.table('emp.txt')
class(txtemp)

#칼럼명이 데이터에 들어가 있음. 
#그걸 처리하기 위해 어떻게 하냐면 불러올 때 header = T라 하면 댐
txtemp <- read.table('emp.txt',header = T)
txtemp

#기본 값이기에 생략된 것이 있음. 콤마로 구분되어 있냐 아니면 공백으로 되어있냐 하는 것들이 생략되어 있음.
txtemp <- read.table('emp.txt',header = T,sep=' ')#sep= ' ' 가  디폴트이기 때문에 생략되어 있음
txtemp

csvemp1 <- read.table('emp.csv', header=T)
csvemp1
#콤마로 데이터가 있네? 불편하네??
#sep로 구분하자
csvemp1 <- read.table('emp.csv', header=T, sep=',')
csvemp1

#어차피 콤마로 구분할껀데 왜 read.table로 쓰냐? read.csv로 쓰쟈!
csvemp2 <- read.csv('emp.csv')
csvemp2

#칼럼명을 바꾸고 싶은데... 따로 바꾸려면 번거로우니 불러올때 부터 바꾸쟈!!
cavemp3 <- read.csv('emp.csv',col.name=c('사번','이름','급여'))
cavemp3

#칼럼명이 없는 파일을 불러올때
csvemp3 <- read.csv('emp2.csv')
csvemp3
#어라? 첫번째 데이터가 칼럼명이 되네??
#그러면 header를 f로 놓자 디폴트가 트루라서 올라간거임 
csvemp3 <- read.csv('emp2.csv', header=F)
csvemp3
#칼럼명도 바꿔보쟈 
csvemp3 <- read.csv('emp2.csv', header=F,col.name=c('사번','이름','급여'))
View(csvemp3)

#read.delim() 똑같은 함수임 그냥 있다고 알면 됨 
aws <- read.delim('AWS_sample.txt',sep='#')
aws

#전체 데이터를 엑셀처럼 깔끔하게 보여주는 함수
View(aws)

#접근
aws[1,1] #[행의 인데스, 열의 인덱스] 즉 하나의 행의 하나의 열을 불러와라

x1 <-aws[1:3,2:4]
x1

x2 <-aws[9:11,2:4]
x2

#두 개의 변수 합치기(cbind,rbind  반드시 같은 형식끼리 합쳐줘야한다.즉 matrix에서만 사용하는게 아니다. 무조건 합치는 것) 
cbind(x1,x2) # 행으로 합치기
class(cbind(x1,x2))

rbind(x1,x2)#열로 합치기 
class(rbind(x1,x2))

aws[,1]
class(aws[,1])

aws $AWS_ID
class(aws$AWS_ID)#백터 즉, 데이터 프레임은 서로 다른 각각의 백터의 열들이 합쳐진것(데이터들의 열만 형식이 같으면 된다는것, r에서는 모든 데이터를 백터로 생각해야 함.)

# 구조 확인 
str(aws) #각각의 열의 형식 한번에 알려줌, 데이터 요약

#기본 통계량 
summary(aws)

#apply() 데이터 프레임에서도 많이 쓰임 
df <-data.frame(x=c(1:5),y=seq(2,10,2),z=c('a','b','c','d','e'))
df

apply(df[,c(1,2)],1,sum) # 변수 df[,c(1,2)]에 대해 행을 기준으로 합계를 구해라
apply(df[,c(1,2)],2,sum)
#변수 df[,c(1,2)]에 대해 열을 기준으로 합계를 구해라.

# 데이터의 일부 추출(전체 데이터가 없어 필요한 것만,subset())
x1 <- subset(df,x>=3)
x1

x2 <- subset(df,x>=2 & y<=6)
x2

# 병합(기존 컬럼을 기준으로 합치기)
height <- data.frame(id=c(1,2),h=c(180,175))
weight <- data.frame(id=c(1,2),h=c(80,75))
# id는 동일함 ribind나 cbind를 쓰면 중복이 됨 

merge(height,weight, by.x = 'id',by.y = 'id')
#height 가 x weight가 y라 생각 하면 됨, merge를 쓰면 중복된 열을 피할 수 있음. 


#### array ####

v <- c(1:12)
v

arr<-array(v,c(4,2,3))#데이터 행 열 면 순, 데이터가 모자르면 처음 데이터로 채워짐.

# 접근 
arr[,,1]
arr[,,2]
arr[,,3]

#6이라는 값을 추출하기
arr[2,2,1] #2행, 2열의 1면 
arr[,,1][2,2] # 먼저 면을 가져오고 행열을 가져오는 방법도 있음

#### list ####

x1 <- 1
x2 <- data.frame(var1=c(1,2,3),var2=c('a','b','v'))
x3 <- matrix(c(1:12),ncol=2)
x4 <- array(1:20,dim=c(2,5,2))

x5 <-list(c1=x1,c2=x2,c3=x3,c4=x4)
x5 # 한번에 이렇게 사용하는 경우는 거의 없음

x5$c1#컬럼 이름이 있으니 $로 접근할 수 있음
x5$c2

x5$c4[,,1]

#연습
list1 <- list(c('lee','kim'),'이순신',95)
list1

#lee 와 kim 추출
#칼럼이름이 없다면 []로 해주면 됨
list1[[1]]
#lee 만 추출
list1[[1]][1]
#kim만 추출
list1[[1]][2]
list1[[2]]

list1<-list('lee','이순신',95)
list1 #복잡해,불편해
un <- unlist(list1) # 3차원을 1차원으로 변경하기 
un # 리스트는 그대로 사용하지 않고 보통 1,2 차원으로 변경해서 사용
class(un)

#apply()에서 파생된 : lapply(),sapply()
#lapply(): 3차원 이상의 데이터만 입력을 받는다. 
#sapply(): 반환형이 vactor 또는 matrix(lapply의 wrapper)
a <-list(c(1:5))
a
b <- list(c(6:10))
b

c <-c(a,b)
c
?list
#현재 데이터에서 가장 큰값 apply를 사용하면 되는데 apply는 2차원에서 사용가능하기 때문에 list에서는 사용할 수 없음
apply(c,1,max) #사용 못함
x<-lapply(c,max) #3차원 이상일때 사용
x
#다시 간단히 풀어야 쓰기 편함
x1 <-unlist(x)
x1

#이를 한번에 하기 
y <-sapply(c,max)
y

#### 날짜 데이터 타입 ####
Sys.Date()
Sys.time()
a <-'21/10/12'
a
class(a)

b<-as.Date(a)
b
class(b)

c <- as.Date(a,'%y/%m/%d')
c

( 2, 3 ) * ( 3, 2 )
( 2, 1 ) * ( 1, 4 )
( 2, 4 ) * ( 4, 3 )
( 2, 2 ) * ( 3, 2 )

x <-c(2,3)
y <-c(3,2)
x*y
