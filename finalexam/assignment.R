library(readr)
setwd("C:/Users/pegas/Documents/")
names <- read_csv("GitHub/Microeconomics1/finalexam/names.csv")
endowment <- read_csv("GitHub/Microeconomics1/finalexam/endowments.csv")

attach(names)
n.names=length(names$firstname)
set.seed(80)
firstdraw=names$firstname[sample(1:n.names,n.names,replace=FALSE)]

set.seed(73)
seconddraw=c("treatment","control")[sample(1:2,n.names,replace=TRUE,prob=c(.5,.5))]

attach(endowment)
endowment$names=firstdraw
endowment$group=seconddraw

write.csv(endowment,"GitHub/Microeconomics1/finalexam/names_endowment_group.csv")

## Verification
(mean(endowment$logic[endowment$group=="control"])-mean(endowment$logic[endowment$group=="treatment"]))/mean(endowment$logic[endowment$group=="control"])
(mean(endowment$programming[endowment$group=="control"])-mean(endowment$programming[endowment$group=="treatment"]))/mean(endowment$programming[endowment$group=="control"])
(mean(endowment$modeling[endowment$group=="control"])-mean(endowment$modeling[endowment$group=="treatment"]))/mean(endowment$modeling[endowment$group=="control"])
