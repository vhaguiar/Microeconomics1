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
α1=.4
α2=(1-α1)
#@JuMP.NLparameter(robinson, β == 1/2)
β = .1
A=50
Lbar=100.0

# function prodfunction(x)
#        try
#              A*x^(β)
#       catch
#             NaN
#       end
# end
#
# function prodfunction_prime(x)
#        try
#              A*β*(x)^(β-1)
#       catch
#             NaN
#       end
# end
#
# function prodfunction_prime_prime(x)
#        try
#               A*β^2*x^(β-2)
#       catch
#             NaN
#       end
# end
#
# function prodfunction_prime_prime_prime(x)
#        try
#               A*β^3*x^(β-3)
#       catch
#             NaN
#       end
# end
prodfunction_prime(x) = A*x^β
prodfunction_prime(x) = A*β*x^(β-1)
prodfunction_prime_prime(x) = A*β^2*x^(β-2)
prodfunction_prime_prime_prime(x) = A*β^3*x^(β-3)
# define equations, here in JuMP we must define them as (nonlinear) constraint
JuMP.register(robinson, :prodfunction, 1, prodfunction, prodfunction_prime,
         prodfunction_prime_prime)

JuMP.register(robinson, :prodfunction_prime, 1, prodfunction_prime, prodfunction_prime_prime,
                  prodfunction_prime_prime_prime)


# FOC of the consumer
@JuMP.NLconstraint(robinson,α1/(α2)*(Lbar-l)*w==c)
#@JuMP.NLconstraint(robinson,α1/(α2)*(Lbar-l)*prodfunction_prime(l+ 1e-7)==c)

# Marginal productivity of labor equal to wage
@JuMP.NLconstraint(robinson,prodfunction_prime(l)==w)

#@JuMP.constraint(robinson,c>=0)
#@JuMP.constraint(robinson,l>=0)
#@JuMP.constraint(robinson,w>=0)
# Budget constraint in equilibrium
@JuMP.NLconstraint(robinson,prodfunction(l)==c)


# Solve model
@JuMP.NLobjective(robinson,Min,1)
JuMP.optimize!(robinson)

JuMP.value(c)
JuMP.value(l)
JuMP.value(w)
