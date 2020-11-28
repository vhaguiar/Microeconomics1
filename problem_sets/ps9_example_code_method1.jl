## Author: Victor H. Aguiar

## questions: slack

## Import packages, make sure to install them.
## Julia version: v"1.5.2"
import JuMP
import Ipopt


## define a model
robinson=JuMP.Model(Ipopt.Optimizer)

# define variables
#coconuts
@JuMP.variable(robinson,c>=0)
#labor
@JuMP.variable(robinson,l>=0)
#wages
@JuMP.variable(robinson,w>=0)

# define parameters
# you must change this values to fit the dataset given to you 
α1=.5
α2=(1-α1)
β = .5
A=60
Lbar=100.0




# Solve model
# each term of the summation is an equation of the system of equations
@JuMP.NLobjective(robinson,Min,(α1/(α2)*(Lbar-l)*w-c)^2+(A*l^β-c)^2+(A*β*l^(β-1)-w)^2)
JuMP.optimize!(robinson)

JuMP.value(c)
JuMP.value(l)
JuMP.value(w)
