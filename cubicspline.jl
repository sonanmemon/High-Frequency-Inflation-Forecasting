using QuantEcon
using LinearAlgebra, Statistics
using DataFrames, Parameters, Plots, Printf, QuantEcon, Random
#using PyPlot
using LaTeXStrings
gr(fmt = :png);
using Distributions
using CSV

df = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\ML and Inflation Prediction\\Data\\pakistan_inflation1970.csv", DataFrame)

print(df)

function CubicNatural(x::Array,y::Array)
m=length(x) # m is the number of data points
n=m-1
global a=Array{Float64}(undef,m)
global b=Array{Float64}(undef,n)
global c=Array{Float64}(undef,m)
global d=Array{Float64}(undef,n)
for i in 1:m
a[i]=y[i]
end
h=Array{Float64}(undef,n)
for i in 1:n
h[i]=x[i+1]-x[i]
end
u=Array{Float64}(undef,n)
u[1]=0

for i in 2:n
u[i]=3*(a[i+1]-a[i])/h[i]-3*(a[i]-a[i-1])/h[i-1]
end
s=Array{Float64}(undef,m)
z=Array{Float64}(undef,m)
t=Array{Float64}(undef,n)
s[1]=1
z[1]=0
t[1]=0
for i in 2:n
s[i]=2*(x[i+1]-x[i-1])-h[i-1]*t[i-1]
t[i]=h[i]/s[i]
z[i]=(u[i]-h[i-1]*z[i-1])/s[i]
end
s[m]=1
z[m]=0
c[m]=0
for i in reverse(1:n)
c[i]=z[i]-t[i]*c[i+1]
b[i]=(a[i+1]-a[i])/h[i]-h[i]*(c[i+1]+2*c[i])/3
d[i]=(c[i+1]-c[i])/(3*h[i])
end
end

function CubicNaturalEval(w,x::Array)
m=length(x)
if w<x[1]||w>x[m]
return print("error: spline evaluated outside its domain")
end
n=m-1
p=1
for i in 1:n
if w<=x[i+1]
break
else
p=p+1
end
end
# p is the number of the subinterval w falls into, i.e., p=i
# means w falls into the ith subinterval $(x_i,x_{i+1}),
# and therefore the value of the spline at w is
# a_i+b_i*(w-x_i)+c_i*(w-x_i)^2+d_i*(w-x_i)^3.
return a[p]+b[p]*(w-x[p])+c[p]*(w-x[p])^2+d[p]*(w-x[p])^3
end







function diff(x::Array,y::Array)
m=length(x) # here m is the number of data points. the degree
# of the polynomial n is m-1
a=Array{Float64}(undef,m)
for i in 1:m
a[i]=y[i]
end
for j in 2:m
for i in reverse(collect(j:m))
a[i]=(a[i]-a[i-1])/(x[i]-x[i-(j-1)])
end
end
return(a)
end





function newton(x::Array,y::Array,z)
m=length(x) # here m is the number of data points, not the
# degree of the polynomial
a=diff(x,y)
sum=a[1]
pr=1.0
for j in 1:(m-1)
pr=pr*(z-x[j])
sum=sum+a[j+1]*pr
end
return sum
end






xaxis=-5:1/100:5
f(x)=1/(1+x^2)
runge=f.(xaxis)
xi=collect(-5:1:5)
yi=map(f,xi)
CubicNatural(xi,yi)
naturalspline=map(z->CubicNaturalEval(z,xi),xaxis)
interp=map(z->newton(xi,yi,z),xaxis) # Interpolating polynomial for the data

p4 = scatter(xi, yi, label="Data")
plot!(xaxis,runge,label=L"1/(1+x^2)")
plot!(xaxis,interp,label="Newton Interpolation")
plot!(xaxis,naturalspline,label="Natural Cubic Spline")
savefig("interpolation_runge_function.pdf")
#legend(loc="upper center");




#x = 1:10; y = rand(10, 2) # 2 columns means two lines
#plot(x, y, title = "Two Lines", label = ["Line 1" "Line 2"], lw = 3)



inflation_annualized = df."quarterly_annualized_inflation"
print(inflation_annualized)
#inflation = deleterows!(inflation_annualized, 201:205)
xaxis= 1:1/100:200
xi=collect(1:1:200)
yi=inflation_annualized[1:1:200]
CubicNatural(xi,yi)
naturalspline=map(z->CubicNaturalEval(z,xi),xaxis)

scat = scatter(xi, yi, label="Data")
plot!(xaxis,naturalspline,label="Natural Cubic Spline")
savefig("inflation_naturalcubicspline.pdf")



#Anonymous functions can be created using the
#-> syntax. This is useful for passing functions to higher-order functions,
#such as the map function.
