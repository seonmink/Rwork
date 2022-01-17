#### 사례1: one yay anova

library(moonBook)
View(acs)
str(acs)

#LDLC: 저밀도 콜레스테롤 수치: 결과변수
#Dx(진단결과): STEMI(급성심근 경색),NSTEMI(만성심금경색), unstable angina(협심증):원인변수

#그래프로 확인
moonBook::densityplot(LDLC ~ Dx,data=acs)

#정규분포
with(acs, shapiro.test(LDLC[Dx=='NSTEMI']))
with(acs, shapiro.test(LDLC[Dx=='STEMI'])) # 정규분포 
with(acs, shapiro.test(LDLC[Dx=='Unstable Angina']))

#정규분포를 확인하는 또 다른 방법 - 한번에 묶어서
out=aov(LDLC~Dx,data=acs)
out
shapiro.test(resid(out)) # resid -> 잔차

#등분산 여부
bartlett.test(LDLC~Dx,data=acs)

#anova 검정(정규분포이고, 등분산일 경우에 사용하는 방법)
out=aov(LDLC~Dx,data=acs)
summary(out) # 별의 갯수로 강도의 차이를 알 수 있음 *** 아주강함, ** 강함, *약하게

#연속변수가 아니거나 정규분포가 아닐경우는??
kruskal.test(LDLC~Dx,data=acs)

#등분산이 아닐경우
oneway.test(LDLC~Dx,data=acs,var.equal = F) #aov와 동일하게 아노바인데 aov에는 없는 인자가 있음.
#진단결과에 따라 콜레스테롤 수치가 차이가 난다. 하지만 어떤게 차이가 난지는 모름 그래서 사후검증이 필요함 

### 사후 검정 

#aov()를 사용했을 경우:TukeyHDS()
TukeyHSD(out)
#unstable - nstrmi만 유의한 차이가 있음. 

#kruskal.test()를 사용한 경우 
install.packages('pgirmess')
library(pgirmess)
kruskalmc(acs$LDLC,acs$Dx) # difference에 참 거짓으로 나옴

# oneway.test()를 사용했을 경우
install.packages('nparcomp')
library(nparcomp)
result<-mctp(LDLC~Dx,data=acs)
summary(result)

#### 실습1 ####
head(iris)
table(iris$Species)
str(iris)

#주제 : 품종별로 sepal.width의 평균차이가 있는가? 
# 만약 있다면 어느 품종과 차이가 있는가? 

moonBook::densityplot(Sepal.Width ~ Species,data=iris)
#정규분포 확인 --> 싹다 정규분포 이룸 
with(iris, shapiro.test(Sepal.Width[Species=='setosa']))
with(iris, shapiro.test(Sepal.Width[Species=='versicolor'])) 
with(iris, shapiro.test(Sepal.Width[Species=='virginica']))
out=aov(Sepal.Width ~ Species,data=iris) 
out
shapiro.test(resid(out))

#등분산 여부 - 등분산가정됨 
bartlett.test(Sepal.Width ~ Species,data=iris)

#anova분석 - 유의한 차이가 있음 
out=aov(Sepal.Width ~ Species,data=iris)
summary(out)

#사후검정
TukeyHSD(out) # 모든 품종끼리 다 유의한 차이를 보임 

# 그래프로 확인 
library(ggplot2)
ggplot(iris,aes(Sepal.Length,Sepal.Width)) + geom_point(aes(colour=Species))

#### 실습2 ####
mydata<-read.csv('./Data/anova_one_way.csv')
mydata
str(mydata)
table(mydata$ad_layer) # x

# 주제: 시,군,구에 따라 합계출산율의 차이가 있는가? 
#있다면 어느 것과 차이가 있는가? 

#정규분포 여부 - 가정 안됨
moonBook::densityplot(birth_rate ~ ad_layer,data=mydata)
with(mydata, shapiro.test(birth_rate[ad_layer=='자치구']))
with(mydata, shapiro.test(birth_rate[ad_layer=='자치군'])) #정규분포
with(mydata, shapiro.test(birth_rate[ad_layer=='자치시'])) #정규분포
out<-aov(birth_rate ~ ad_layer,data=mydata)
out
shapiro.test(resid(out))

#등분산 여부 - 아님 --> 정규분포 가정이 안되었기 때문에 등분산을 가정할 필요 없음.
bartlett.test(birth_rate ~ ad_layer,data=mydata)

#비모수적 방식 anova 
kruskal.test(birth_rate ~ ad_layer,data=mydata) #- 유의한 차이가 있음 - 정규분포가 아닐때 
oneway.test(birth_rate ~ ad_layer,data=mydata,var.equal = F) # 유의한 차이가 있음- 등분산이 아닐때. 

#모수적 방식으로 검증
summary(out)

# 사후검정
#kruskal.test() 썼을 때
library(pgirmess)
kruskalmc(birth_rate ~ ad_layer,data=mydata) #자치구-자치군, 자치구-자치시 에서만 유의한 차이가 있음.

# oneway.test()를 사용했을 경우
install.packages("nparcomp")
library(nparcomp)
result<-mctp(birth_rate ~ ad_layer,data=mydata)
summary(result)

#aov()를 사용했을 경우:TukeyHDS()
TukeyHSD(out)


#### 실습3 ####
library(dplyr)
telco <-read.csv('./Data/Telco-Customer-Churn.csv',header = T)
head(telco)
str(telco)
moonBook::densityplot(TotalCharges ~ PaymentMethod,data=telco)
# 독립변수 : PaymentMethod
# 종속변수 : TotalCharges    

table(telco$PaymentMethod)

# 주제 : 지불 방식별로 총 지불금액이 차이가 있는지?
# 있다면 무엇과 차이가 있는지? 

# 각 지불 방식별로 인원수와 평균 금액 조회회
telco %>% select(PaymentMethod,TotalCharges) %>% group_by(PaymentMethod)%>%
  summarise(count=n(),mean_payment=mean(TotalCharges,na.rm=T))

#정규분포 --> 가정이 안됨. but= 데이터수가 많기 때문에 정규분포로 가정해되 됨.
with(telco, shapiro.test(TotalCharges[PaymentMethod=='Bank transfer (automatic)']))
with(telco, shapiro.test(TotalCharges[PaymentMethod=='Credit card (automatic)'])) 
with(telco, shapiro.test(TotalCharges[PaymentMethod=='Electronic check']))
with(telco, shapiro.test(TotalCharges[PaymentMethod=='Mailed check']))
out <- aov(TotalCharges~PaymentMethod, data=telco)# 데이터가 5천개 넘어가면 정규분포 검사 안해줌. 굳이 하겠다 하면 
out#엔더스 달링 테스트
shapiro.test(resid(out))

#등분산 가정 안됨
bartlett.test(TotalCharges~PaymentMethod, data=telco)

#비모수적-정규분포가 아니라는 상황에서 테스트
kruskal.test(TotalCharges ~ PaymentMethod,data=telco)

#welch's anova
oneway.test(TotalCharges ~ PaymentMethod,data=telco,var.equal = F)

#모수적
summary(out)

#사후검증
library(pgirmess)
kruskalmc(TotalCharges ~ PaymentMethod,data=telco)
#자동이체와 신용카드 간의 차이를 제외하고 유의한 차이가 존재함. 

library(nparcomp)
result<-mctp(TotalCharges ~ PaymentMethod,data=telco)
summary(result)

TukeyHSD(out)

plot(result)

ggplot(telco,aes(telco$PaymentMethod,telco$TotalCharges)) + geom_boxplot()



#### 사례1: two way anova ####
mydata <- read.csv('./Data/anova_two_way.csv')
head(mydata)

#정규분포는 아냐
shapiro.test(resid(out))

#anova
aov(birth_rate ~ad_layer ,data=mydata ) #--> one way
out<-aov(birth_rate ~ad_layer +multichild +ad_layer:multichild,data=mydata ) #--> two way
summary(out)
# ad_layer 별로 차이가 있고, ad_layer:multichild 별로 차이가 있음(상호작용이 있음)

#사후검증
result<-TukeyHSD(out)
result

#그래프 그리는 것이 더 결과 파악하는데 도움이 됨.
ggplot(mydata,aes(birth_rate,ad_layer,col=multichild)) + geom_boxplot()

#### 실습1 ####
telco <-read.csv('./Data/Telco-Customer-Churn.csv',header = T)
head(telco)
str(telco)
# 독립변수: PaymentMethod, Contract (약정)
# 종속변수: TotalCharges 
# 지불 방식과 약정에 따라 지불 금액의 차이 파악해보기 
table(telco$Contract)
table(telco$PaymentMethod)

#정규분포 --> 정규분포 가정이 안됨. 그러나 7000개의 데이터로 정규분포로 가정함
with(telco,shapiro.test(TotalCharges[PaymentMethod=='Bank transfer (automatic)']))
with(telco,shapiro.test(TotalCharges[PaymentMethod=='Credit card (automatic)']))
with(telco,shapiro.test(TotalCharges[PaymentMethod=='Electronic check']))
with(telco,shapiro.test(TotalCharges[PaymentMethod=='Mailed check']))
with(telco,shapiro.test(TotalCharges[Contract=='Month-to-month']))
with(telco,shapiro.test(TotalCharges[Contract=='One year']))
with(telco,shapiro.test(TotalCharges[Contract=='Two year']))

#anova 검증
model2 <-aov(TotalCharges~PaymentMethod+Contract+PaymentMethod*Contract,data=telco)
#단순히 추가만 하는 것이 아니라 상호작용도 넣어 줘야함 *로도 가능. 
model2
summary(model2)

#등분산 가정 안됨 --> 데이터가 7천개 이상이라 정규분포라 봄., 아노바에서 등분산은 그렇게 크게 필요치 않음. 
bartlett.test(TotalCharges~PaymentMethod+Contract+PaymentMethod:Contract,data=telco)

#사후검증
result<-TukeyHSD(model2)
result

#그래프로 보기 
plot(result)
library(ggplot2)
ggplot(data=telco,aes(PaymentMethod,TotalCharges,col=Contract))+geom_boxplot()

#### 사례 4: RM anova ####
# 구형성(Sphericity) :이미 독립성이 깨졌으므로 최대한 독립성과 무작위를 확보하기 위한 조건 
# 가정: 반복 측정된 자료들의 시차에 따른 분산이 동일 
#     1) Mouchly의 단위행렬 검정: p-value 값이 .05 보다 커야함.
#     2) 만약 .05보다 작다면 Greenhouse를 사용한다. : 값이 1에 가까울수록 구형성이 타당
df=data.frame()
df= edit(df)
df # --> 이제 종속변수가 3개임

means <- c(mean(df$pre),mean(df$three_month),mean(df$six_month))
means
plot(means,type='o',lty =2,col=2)

install.packages('car')
library(car)

#먼저 직선의 방정식을 구해야 함.
multimodel<-lm(cbind(df$pre, df$three_month, df$six_month) ~ 1)
multimodel

fact<-factor(c('pre','three_month','six_month'),ordered = F)
model1<-Anova(multimodel, idata=data.frame(fact), idesign = ~fact, type='III')
model1
summary(model1,mulivarate=F)

str(df2)
df2$id<-factor(df2$id)
str(df2)



#사후검정 
library(reshape2)
#long형으로 바꾸기 
df2<- melt(df,id.vars = 'id')
df2
colnames(df2) <-c('id','time','value') # 칼럼명 바꾸기
df2

#그래프 확인
ggplot(df2,aes(time,value)) + geom_line(aes(group=id,col=id))+geom_point(aes(col=id))

library(dplyr)
df2.mean<-df2%>%group_by(time)%>%
  summarise(mean=mean(value),sd=sd(value))
df2.mean

ggplot(df2.mean,aes(time,mean)) +geom_point() + geom_line(group=1)
#어디서 차이가 클까?


#반복 측정 사후검증 pairwise.t.test,,p.adjust.method 오차를 보정하는 방식 
with(df2,pairwise.t.test(value,time,paired=T,p.adjust.method = 'bonferroni'))




#### 실습 1: 시간에 따른 차이검증(반복 측정 RM anova)
# onewaysample.csv
# 주제: 7명의 학생이 총 4번의 시험을 보았다. 평균차이가 있는가?
# 있다면 어느것과 차이가 있는가?
rm <-read.csv('./Data/onewaySample.csv',header = T)
rm <- rm[,2:6]
rm

#각 시험별 평균 
means <- c(mean(rm$score0),mean(rm$score1),mean(rm$score3),mean(rm$score6))
means

plot(means,type='o',lty=2,col=2)

#먼저 직선의 방정식을 구해야 함.
multimodel<-lm(cbind(rm$score0 , rm$score1 , rm$score3,rm$score6) ~ 1)
multimodel

fact<-factor(c('score0','score1','score3','score6'),ordered = F)

#anova 분석
library(car)
model1<-Anova(multimodel, idata=data.frame(fact), idesign = ~fact, type='III')
model1
summary(model1,mulivarate=F)

#사후검증 
#long 형으로 데이터 바꿔서 하는게 좋음
library(tidyr)
rmlong <- gather(rm,key='ID',value='score')
rmlong

#id는 필요 없음 
rmlong <- rmlong[8:35,]
rmlong

#사후검증
# 1.
with(rmlong,pairwise.t.test(score,ID,paired=T,p.adjust.method = 'bonferroni'))
#1-3이 가장 큰 차이가 남

#2. 두번째 방법
#정규분포 여부 확인
out <- aov(score~ ID,data=rmlong)
shapiro.test(resid(out)) #정규분포
TukeyHSD(out) # --> 5%
.05/4 #--> 이것보다 크면 영가설, 작으면 연구가설, .05를 4번 반복 측정한것이기 때문에


#### 사례3: 비모수일경우(즉, 서열변수이거나 정규분포가 아닐경우)####
?friedman.test
RoundingTimes <-
  matrix(c(5.40, 5.50, 5.55,
           5.85, 5.70, 5.75,
           5.20, 5.60, 5.50,
           5.55, 5.50, 5.40,
           5.90, 5.85, 5.70,
           5.45, 5.55, 5.60,
           5.40, 5.40, 5.35,
           5.45, 5.50, 5.35,
           5.25, 5.15, 5.00,
           5.85, 5.80, 5.70,
           5.25, 5.20, 5.10,
           5.65, 5.55, 5.45,
           5.60, 5.35, 5.45,
           5.05, 5.00, 4.95,
           5.50, 5.50, 5.40,
           5.45, 5.55, 5.50,
           5.55, 5.55, 5.35,
           5.45, 5.50, 5.55,
           5.50, 5.45, 5.25,
           5.65, 5.60, 5.40,
           5.70, 5.65, 5.55,
           6.30, 6.30, 6.25),
         nrow = 22,
         byrow = TRUE,
         dimnames = list(1 : 22,
                         c("Round Out", "Narrow Angle", "Wide Angle")))
RoundingTimes
#long형으로 바꾸기 
library(reshape2)
rt<-melt(RoundingTimes)
rt
rt1 <- aov(value~ Var2 ,data=rt)
shapiro.test(resid(rt1))

boxplot(value~ Var2 ,data=rt)

# 정규분포가 아니기때문에 anova를 사용하면 안됨
friedman.test(RoundingTimes) # 차이는 있음.

# 사후검증
#https://www.r-statistics.com/2010/02/post-hoc-analysis-for-friedmans-test-r-code/ 함수

friedman.test.with.post.hoc <- function(formu, data, to.print.friedman = T, to.post.hoc.if.signif = T,  to.plot.parallel = T, to.plot.boxplot = T, signif.P = .05, color.blocks.in.cor.plot = T, jitter.Y.in.cor.plot =F)
{
  # formu is a formula of the shape:     Y ~ X | block
  # data is a long data.frame with three columns:    [[ Y (numeric), X (factor), block (factor) ]]
  # Note: This function doesn't handle NA's! In case of NA in Y in one of the blocks, then that entire block should be removed.
  # Loading needed packages
  if(!require(coin))
  {
    print("You are missing the package 'coin', we will now try to install it...")
    install.packages("coin")
    library(coin)
  }
  if(!require(multcomp))
  {
    print("You are missing the package 'multcomp', we will now try to install it...")
    install.packages("multcomp")
    library(multcomp)
  }
  if(!require(colorspace))
  {
    print("You are missing the package 'colorspace', we will now try to install it...")
    install.packages("colorspace")
    library(colorspace)
  }
  # get the names out of the formula
  formu.names <- all.vars(formu)
  Y.name <- formu.names[1]
  X.name <- formu.names[2]
  block.name <- formu.names[3]
  if(dim(data)[2] >3) data <- data[,c(Y.name,X.name,block.name)]    # In case we have a "data" data frame with more then the three columns we need. This code will clean it from them...
  # Note: the function doesn't handle NA's. In case of NA in one of the block T outcomes, that entire block should be removed.
  # stopping in case there is NA in the Y vector
  if(sum(is.na(data[,Y.name])) > 0) stop("Function stopped: This function doesn't handle NA's. In case of NA in Y in one of the blocks, then that entire block should be removed.")
  # make sure that the number of factors goes with the actual values present in the data:
  data[,X.name ] <- factor(data[,X.name ])
  data[,block.name ] <- factor(data[,block.name ])
  number.of.X.levels <- length(levels(data[,X.name ]))
  if(number.of.X.levels == 2) { warning(paste("'",X.name,"'", "has only two levels. Consider using paired wilcox.test instead of friedman test"))}
  # making the object that will hold the friedman test and the other.
  the.sym.test <- symmetry_test(formu, data = data,    ### all pairwise comparisons
                                teststat = "max",
                                xtrafo = function(Y.data) { trafo( Y.data, factor_trafo = function(x) { model.matrix(~ x - 1) %*% t(contrMat(table(x), "Tukey")) } ) },
                                ytrafo = function(Y.data){ trafo(Y.data, numeric_trafo = rank, block = data[,block.name] ) }
  )
  # if(to.print.friedman) { print(the.sym.test) }
  if(to.post.hoc.if.signif)
  {
    if(pvalue(the.sym.test) < signif.P)
    {
      # the post hoc test
      The.post.hoc.P.values <- pvalue(the.sym.test, method = "single-step")    # this is the post hoc of the friedman test
      # plotting
      if(to.plot.parallel & to.plot.boxplot)    par(mfrow = c(1,2)) # if we are plotting two plots, let's make sure we'll be able to see both
      if(to.plot.parallel)
      {
        X.names <- levels(data[, X.name])
        X.for.plot <- seq_along(X.names)
        plot.xlim <- c(.7 , length(X.for.plot)+.3)    # adding some spacing from both sides of the plot
        if(color.blocks.in.cor.plot)
        {
          blocks.col <- rainbow_hcl(length(levels(data[,block.name])))
        } else {
          blocks.col <- 1 # black
        }
        data2 <- data
        if(jitter.Y.in.cor.plot) {
          data2[,Y.name] <- jitter(data2[,Y.name])
          par.cor.plot.text <- "Parallel coordinates plot (with Jitter)"
        } else {
          par.cor.plot.text <- "Parallel coordinates plot"
        }
        # adding a Parallel coordinates plot
        matplot(as.matrix(reshape(data2,  idvar=X.name, timevar=block.name,
                                  direction="wide")[,-1])  ,
                type = "l",  lty = 1, axes = FALSE, ylab = Y.name,
                xlim = plot.xlim,
                col = blocks.col,
                main = par.cor.plot.text)
        axis(1, at = X.for.plot , labels = X.names) # plot X axis
        axis(2) # plot Y axis
        points(tapply(data[,Y.name], data[,X.name], median) ~ X.for.plot, col = "red",pch = 4, cex = 2, lwd = 5)
      }
      if(to.plot.boxplot)
      {
        # first we create a function to create a new Y, by substracting different combinations of X levels from each other.
        subtract.a.from.b <- function(a.b , the.data)
        {
          the.data[,a.b[2]] - the.data[,a.b[1]]
        }
        temp.wide <- reshape(data,  idvar=X.name, timevar=block.name,
                             direction="wide")     #[,-1]
        wide.data <- as.matrix(t(temp.wide[,-1]))
        colnames(wide.data) <- temp.wide[,1]
        Y.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, subtract.a.from.b, the.data =wide.data)
        names.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, function(a.b) {paste(a.b[2],a.b[1],sep=" - ")})
        the.ylim <- range(Y.b.minus.a.combos)
        the.ylim[2] <- the.ylim[2] + max(sd(Y.b.minus.a.combos))    # adding some space for the labels
        is.signif.color <- ifelse(The.post.hoc.P.values < .05 , "green", "grey")
        boxplot(Y.b.minus.a.combos,
                names = names.b.minus.a.combos ,
                col = is.signif.color,
                main = "Boxplots (of the differences)",
                ylim = the.ylim
        )
        legend("topright", legend = paste(names.b.minus.a.combos, rep(" ; PostHoc P.value:", number.of.X.levels),round(The.post.hoc.P.values,5)) , fill =  is.signif.color )
        abline(h = 0, col = "blue")
      }
      list.to.return <- list(Friedman.Test = the.sym.test, PostHoc.Test = The.post.hoc.P.values)
      if(to.print.friedman) {print(list.to.return)}
      return(list.to.return)
    }    else {
      print("The results where not significant, There is no need for a post hoc test")
      return(the.sym.test)
    }
  }
  # Original credit (for linking online, to the package that performs the post hoc test) goes to "David Winsemius", see:
  # http://tolstoy.newcastle.edu.au/R/e8/help/09/10/1416.html
}

friedman.test.with.post.hoc(value~Var2 | Var1,rt)
#본페르니 보정
#반복측정이기 때문에 .05에서 세번 반복이기에 나눠줘야함. 
.05/3


### 실행되는 것. 
#### 사례4: Two way RM anova ####

df <- read.csv('./Data/10_rmanova.csv',header=T)
df
str(df)

# long형으로 바꾸기
df1<-melt(df,id=c('group','id'),variable.name = 'time',vlaue.name='month')
df1

#그래프 그리기
?interaction.plot
str(df1)

df1$group <-factor(df1$group)
df1$id <-factor(df1$id)
str(df1)

interaction.plot(df1$time, df1$group, df1$month)

#정규분포확인
out <-aov(month ~ group*time, data=df1)
summary(out)

shapiro.test(resid(out))

# 사후검증
#시점별로 쪼개서 t검증을 해야함. 
df1

df_0 <-df1[df1$time =='month0']
df_1 <-df1[df1$time =='month1']
df_3 <-df1[df1$time =='month3']
df_6 <-df1[df1$time =='month6']

t.test(month ~ group, data=df_0)
t.test(month ~ group, data=df_1)
t.test(month ~ group, data=df_3)
t.test(month ~ group, data=df_6)

#본페르니 보정(본페르니는 반복측정)
.05/6 # 4c2

#### 사례4 : Two Way RM anova ####

df <- read.csv("./Data/10_rmanova.csv", header=T)
str(df)
df

# long형으로 변경
df1 <- melt(df, id=c("group", "id"), variable.name = "time", value.name = "month")
df1

# 그래프 그리기
?interaction.plot
str(df1)

df1$group <- factor(df1$group)
df1$id <- factor(df1$id)
str(df1)

interaction.plot(df1$time, df1$group, df1$month)


out <- aov(month ~ group*time, data=df1)
summary(out)

shapiro.test(resid(out))

# 사후 검정
df1

df_0 <- df1[df1$time == "month0", ]
df_1 <- df1[df1$time == "month1", ]
df_3 <- df1[df1$time == "month3", ]
df_6 <- df1[df1$time == "month6", ]

t.test(month ~ group, data=df_0)
t.test(month ~ group, data=df_1)
t.test(month ~ group, data=df_3)
t.test(month ~ group, data=df_6)

# 4C2
0.05/6 # 0.008
