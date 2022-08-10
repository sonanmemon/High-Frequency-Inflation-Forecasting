using QuantEcon
using LinearAlgebra, Statistics
using DataFrames, Parameters, Plots, Printf, QuantEcon, Random
#using PyPlot
using Dates
using LaTeXStrings
gr(fmt = :png);
using Distributions
using CSV

df = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\ML and Inflation Prediction\\Data\\quarterly_cpi_yony.csv", DataFrame)

print(df)


df_monthly = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\ML and Inflation Prediction\\Data\\CPI_Monthly.csv", DataFrame)

print(df_monthly)

#The above df_monthly has monthly YonY CPI which starts at Jan 1958 and ends at June 2022. CPI_YonY


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


#global date = DateFormat("y-m-d")
#for i = 1:3:10
#    dt_i = Date("1958-i-01", date)
#end

#d = Dates.Date(1958, 4, 1):Dates.Month(3):Dates.Date(2020, 7, 1)
#print(d)

#df$d = d
#print(df)

quarterly_cpi_yony = df."CPI_Quarterly_YonY"
print(quarterly_cpi_yony)


monthly_cpi_yony = df_monthly."CPI_YonY"
print(monthly_cpi_yony)

#The above df_monthly has monthly YonY CPI which starts at Jan 1958 and ends at June 2022 (774 months). CPI_YonY

#inflation = deleterows!(inflation_annualized, 201:205)
#xaxis= 1:1/100:250
xaxis_month = 1:1/3:250 #monthly xaxis definition
#xaxis_week = 1:1/4:841.25
xaxis_week = 1:1/4:774
summary(xaxis_week)#weekly xaxis definition 3093 total
xaxis_day = 1:1/30:774
summary(xaxis_day) #23191 observations
xi_quarter=collect(1:1:250)
xi_month = collect(1:1:774)

quarter = Dates.Date(1958, 4, 1):Dates.Month(3):Dates.Date(2020, 7, 1)
month = Dates.Date(1958, 4, 1):Dates.Month(1):Dates.Date(2020, 7, 1)
week = Dates.Date(1958, 1, 1):Dates.Week(1):Dates.Date(2022, 6, 1)
summary(week)
month_actual = Dates.Date(1958, 1, 1):Dates.Month(1):Dates.Date(2022, 6, 1)

yi_quarter=quarterly_cpi_yony[1:1:250]
yi_month = monthly_cpi_yony[1:1:774]

CubicNatural(xi_quarter,yi_quarter)
naturalspline=map(z->CubicNaturalEval(z,xi_quarter),xaxis_month)


tick_quarters = Date.([Dates.Date(1958, 4), Dates.Date(1968, 4),
Dates.Date(1978, 4), Dates.Date(1988, 4), Dates.Date(1998, 4),
Dates.Date(2008, 4), Dates.Date(2014, 7), Dates.Date(2020, 7)])
DateTick = Dates.format.(tick_quarters, "yyyy-m")
scat = scatter(quarter, yi_quarter, label="Data", xticks = false)
plot!(month,naturalspline, title = "Interpolated Inflation Series (Monthly)",
label="Natural Cubic Spline", xticks = false)
plot!(xticks = (tick_quarters,DateTick), xtickfontsize = 5)
xlabel!("Quarters (1958Q2 to 2020Q3)")
ylabel!("Quarterly/Monthly Inflation Rate (CPI and YonY)")
savefig("monthlyinflation_naturalcubicspline.pdf")

#xlims!(Dates.Date(1958, 4, 1), Dates.Date(2020, 7, 1))
#https://github.com/kbarbary/Dierckx.jl



#3093 Weeks Interpolated Below

CubicNatural(xi_month,yi_month)
naturalspline=map(z->CubicNaturalEval(z,xi_month),xaxis_week)
summary(naturalspline)


scat = scatter(xi_month, yi_month, label="Data")
plot!(xaxis_week,naturalspline, title = "Interpolated Inflation Series (Weekly)",
label="Natural Cubic Spline")
xlabel!("Months (1958-Jan to 2022-June)")
ylabel!("Monthly/Weekly Inflation Rate (CPI and YonY)")
savefig("weeklyinflation_naturalcubicspline.pdf")





#Daily 23191 observations. Average 30 days per month applied
CubicNatural(xi_month,yi_month)
naturalspline=map(z->CubicNaturalEval(z,xi_month),xaxis_day)
summary(naturalspline)


scat = scatter(xi_month, yi_month, label="Data")
plot!(xaxis_day,naturalspline, title = "Interpolated Inflation Series (Daily)",
label="Natural Cubic Spline")
xlabel!("Months (1958-Jan to 2022-June)")
ylabel!("Monthly/Daily Inflation Rate (CPI and YonY)")
savefig("dailyinflation_naturalcubicspline.pdf")






#CubicNatural(xi_month,yi_month)
#z->CubicNaturalEval(z,xi_month, bc = "nearest")
#naturalspline=map(z->CubicNaturalEval(z,xi_month),xaxis_week)
#scat = scatter(month_actual, yi_month, label="Data", xticks = false)
#plot!(week,naturalspline, title = "Interpolated Inflation Series (Weekly)",
#label="Natural Cubic Spline", xticks = false)
#plot!(xticks = (tick_quarters,DateTick), xtickfontsize = 5)
#xlabel!("Months (1958-Jan to 2022-June)")
#ylabel!("Monthly/Weekly Inflation Rate (CPI and YonY)")
#savefig("weeklyinflation_naturalcubicspline.pdf")


#Anonymous functions can be created using the
#-> syntax. This is useful for passing functions to higher-order functions,
#such as the map function.
