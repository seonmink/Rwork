#### 키보드 입력 ####
# scan() : 벡터 입력
# edit() : 데이터 프레임 입력 

a <-scan() # 숫자형식의 데이터 입력, 입력을 중단할 경우 빈칸에 엔터
a

b<- scan(what = character())# 문자형식을 입력할 때는 인자값을 넣어야함
b

df <- data.frame()
df <-edit(df)
df

#### 파일로부터 입력 ####
# read.csv()
# read.table() csv이외의 것
# read.xlsx()
# read.spss() 원래는 .sav인데 r에서 불러올때

#### read.table ####
?read.table
student1 <-read.table('./student.txt')
student1
getwd()

student1 <- read.table('./student1.txt',header = T)
student1

#file.choose --> 직접 파일 선택 
student2 <-read.table(file.choose(),header=T,sep = ';')
student2

student3 <- read.table('./student3.txt',header=T)
student3 # - 를 결측치로 만들고 싶을 때 na.strings=
student3 <- read.table('./student3.txt',header=T,na.strings = '-')
student3
#여러개를 묶을려면 무조건 백터를 써야함
student3 <- read.table('./student3.txt',header=T, na.strings = c('-','&','+'))
student3

### read.xlsx()
#r에서는 없기 때문에 패키지 설치를 해야함. 
install.packages('xlsx')

#파이썬의 import와 같은 것 library
library(rJava)
library(xlsx)                  

studentx <- read.xlsx(file.choose(),sheetIndex = 1)
studentx

studentx <- read.xlsx(file.choose(),sheetName = '데이터')
studentx

### read.spss()
library(foreign)

raw_welfare <-read.spss('C:/Users/Administrator/Downloads/seonmin/Rwork/Data/Koweps_hpc10_2015_beta1.sav',to.data.frame = T)
raw_welfare
getwd()


#### 화면 출력 ####
# 변수명
#(식) 프린트 함수가 앞에 생략 된것 
#print()
#cat()
x<-10
y<-20
z<-x+y

z

(z<-x+y)

print(z)
print(z<-x+y)
print('안녕?',1,'하세요') # 안됨. 
print('x+y의 결과는',as.character(z),'입니다.') #안됨
cat('x+y의 결과는',z,'입니다.')

#### 파일 출력 ####
# write.csv() 
# write.table()
# write.xlsx()
setwd('C:/Users/Administrator/Downloads/seonmin/Rwork/') #작업경로 변경
getwd() #작업경로 확인
studentx <- read.xlsx('./Data/studentexcel.xlsx',sheetName = 'emp2')
studentx
class(studentx)

#엑셀을 메모장으로 읽을 수 있도록 저장하기 
write.table(studentx,'./Data/study1.txt') # 구분자를 않썼기 때문에 기본은 공백임 
read.table('./Data/study1.txt')
write.table(studentx,'./Data/study2.txt',row.names = F) #인덱스(행번호)를 빼고 데이터만 저장하고 싶을 때 
read.table('./Data/study2.txt')

#데이터에 " "를 업애고 싶을 떄
write.table(studentx,'./Data/study2.txt',row.names = F, quote = F) 
#원래 파일은 stud1,2,3 이거임 ! 

write.csv(studentx,'./Data/stud4.csv',row.names = F, quote = F) 

# 엑셀로 불러온 파일을 엑셀로 저장하기 
library(rJava)
library(xlsx) 
write.xlsx(studentx,'./Data/stud5.xlsx')

#### r 전용 파일로 저장하는 방식 rda ####
# 메모장으로는 읽을 수 없음. 
# save()
# load()
studentx
save(studentx,file='./Data/stud6.rda')

rm(studentx) #일단 삭제해보자 
studentx
load('./Data/stud6.rda')
studentx


