## Author: Victor H. Aguiar

## questions: slack

## Import packages, make sure to install them.
## Julia version: v"1.5.2"
import JuMP
import Ipopt
using CSV, DataFrames

################################################################################
## Setting-up directory
tempdir1=@__DIR__
repdir=tempdir1[1:findfirst("Microeconomics1",tempdir1)[end]]
diroutput=repdir*"\\finalexam\\programming\\results"
dirdata=repdir*"/finalexam\\programming\\data"


## Definition of countries
I=30


σ=1/2

#import data
# trade frictions
t=Matrix(CSV.read(dirdata*"/tij.csv"))
# Income vector
y=Matrix(CSV.read(dirdata*"/y.csv"))'


# world income
yw=sum(y)

#shares
θ=zeros(I)
for i in 1:I
    θ[i]=y[i]/yw
end

θ

## Solving the model
gravity=JuMP.Model(Ipopt.Optimizer)
# Use JuMP.@NLobjective

## Compute demand, no need to optimize



## Estimation


lxhat=Matrix(CSV.read(dirdata*"/lxhat.csv"))'

#####################################################################

##Model

sigmaestim=JuMP.Model(Ipopt.Optimizer)


## linear objective here
# Use JuMP.@objective

z=zeros(I,I)

for i in 1:I
    for j in 1:I
        z[i,j]=lxhat[i,j]-log(y[i])-log(y[j])
    end
end
