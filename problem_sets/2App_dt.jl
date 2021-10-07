#Version Julia "1.1.1"
using DataFrames
using MathProgBase
using CSV
using LinearAlgebra
################################################################################
## Setting-up directory
tempdir1=@__DIR__
repdir=tempdir1[1:findfirst("ReplicationAK",tempdir1)[end]]
diroutput=repdir*"/Output_all"
dirdata=repdir*"/Data_all"

## Data
# Sample size
const n=154
# Number of time periods
const T=50
# Number of goods
const K=3
# Read csv files
dum0=CSV.read(dirdata*"/rationalitydata3goods.csv",DataFrame)
# break the dataset into subdatasets by individual
splitdum0=groupby(dum0,:id)
@eval  splitp=$splitdum0
#Initialize array of effective prices
rho=zeros(n,T,K)
#Initialize array of consumption
cve=zeros(n,T,K)
# Fill the arrays
# Columns 10:12 correspond to prices
# Columns 4:6 correspond to consumption bundles
for i=1:n
    dum0=convert(Array,splitp[i])
    rho[i,:,:]=dum0[1:T,10:12]
    cve[i,:,:]=dum0[1:T,4:6]
end


################################################################################
## Deterministic
ind=1
p=rho[ind,:,:]
q=cve[ind,:,:]

function rdmatrix(;p=p,q=q)
    rdmatrixfill=zeros(T,T)
    for t=1:T, s=1:T
      if (p[t,:]'*q[t,:])[1]>=(p[t,:]'*q[s,:])[1]
        rdmatrixfill[t,s]=1
      end
    end
    rdmatrixfill
end

function tclosure(;m=m)
    n0=size(m)[2]
    for k=1:n0, i=1:n0, j=1:n0
      if  m[i,k]==1 && m[k,j]==1
        m[i,j]=1
      end
    end
    m
end

function garpok(;p=p,q=q)
    garpmatrixfill=zeros(T,T)
    m=tclosure(m=rdmatrix(p=p,q=q))
    for t=1:T
        for s=1:T
            if m[t,s]==1 && ((p[s,:]'*q[s,:])[1]>(p[s,:]'*q[t,:])[1])
                garpmatrixfill[t,s]=1
            end
        end
    end

    maximum(garpmatrixfill)
    ## output of zero is a pass, no violation of GARP
end

function testgarp(;rho=rho,cve=cve)
    garpresults=zeros(n)
    for ind=1:n
      garpresults[ind]=garpok(p=rho[ind,:,:],q=cve[ind,:,:])
    end
    garpresults
end
garpresults=testgarp(rho=rho,cve=cve)
rate=1-sum(garpresults)/n

## Pass Rate
ratev=["pass-garp" rate]
DFsolv=convert(DataFrame,ratev)
CSV.write(diroutput*"/2App_dt_rr.csv",DFsolv)
