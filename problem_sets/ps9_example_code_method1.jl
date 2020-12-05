## Author: Victor H. Aguiar

## questions: slack

## Import packages, make sure to install them.
## Julia version: v"1.5.2"
import JuMP
import Ipopt


## define a model
robinson=JuMP.Model(Ipopt.Optimizer)
#Knitro
# define variables
#coconuts
@JuMP.variable(robinson,c>=0)
#labor
@JuMP.variable(robinson,l>=0)
#wages
@JuMP.variable(robinson,w>=0)

# define parameters
# you must change this values to fit the dataset given to you
α1=.4
α2=(1-α1)
β = .1
A=50
Lbar=100.0




# Solve model
# each term of the summation is an equation of the system of equations
tax=0
@JuMP.NLobjective(robinson,Min,(α1/(α2)*(Lbar-l)*w-c)^2+(A*l^β*(1-tax)-c)^2+(A*β*l^(β-1)*(1-tax)-w)^2)
JuMP.optimize!(robinson)

JuMP.value(c)
JuMP.value(l)
JuMP.value(w)


taxvec=collect(0:.01:.99)
revenuevec=zeros(length(taxvec))
for t in 1:length(taxvec)
    tax=taxvec[t]
    @JuMP.NLobjective(robinson,Min,(α1/(α2)*(Lbar-l)*w-c)^2+(A*l^β*(1-tax)-c)^2+(A*β*l^(β-1)*(1-tax)-w)^2)
    JuMP.optimize!(robinson)
    revenuevec[t]=A*JuMP.value(l)^β*tax
end

sol=findmax(revenuevec)
taxvec[sol[2]]
