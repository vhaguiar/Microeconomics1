library(readr)
setwd("C:/Users/pegas/Documents/")
names <- read_csv("GitHub/Microeconomics1/finalexam/names.csv")
endowment <- read_csv("GitHub/Microeconomics1/finalexam/endowments.csv")

attach(names)
n.names=length(names$firstname)
set.seed(80)
draw=sample(1:n.names,n.names,replace=FALSE)
firstdraw=names$firstname[draw]
userdraw=names$user[draw]

set.seed(73)
seconddraw=c("treatment","control")[sample(1:2,n.names,replace=TRUE,prob=c(.5,.5))]

attach(endowment)
endowment$names=firstdraw
endowment$group=seconddraw
endowment$email=userdraw

write.csv(endowment,"GitHub/Microeconomics1/finalexam/names_endowment_group.csv")


##emails list
write.csv(paste(endowment$email[endowment$group=="treatment"],"@uwo.ca",sep=""),"GitHub/Microeconomics1/finalexam/treatment_email.csv")
write.csv(paste(endowment$email[endowment$group=="control"],"@uwo.ca",sep=""),"GitHub/Microeconomics1/finalexam/control_email.csv")

## Verification
(mean(endowment$logic[endowment$group=="control"])-mean(endowment$logic[endowment$group=="treatment"]))/mean(endowment$logic[endowment$group=="control"])
(mean(endowment$programming[endowment$group=="control"])-mean(endowment$programming[endowment$group=="treatment"]))/mean(endowment$programming[endowment$group=="control"])
(mean(endowment$modeling[endowment$group=="control"])-mean(endowment$modeling[endowment$group=="treatment"]))/mean(endowment$modeling[endowment$group=="control"])
