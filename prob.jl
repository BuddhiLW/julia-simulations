using Random, Distributions, Plots

a = Binomial(12, 1 / 6)

outcomes = rand(a, 10^8)
two = filter(x -> x == 2, outcomes)
morethantwo = filter(x -> x >= 2, outcomes)

length(two) / length(outcomes)
length(morethantwo) / length(outcomes)

function binomial(n, k, p)
    return (factorial(n) / (factorial(k) * factorial(n - k))) * (p^k) * ((1 - p)^(n - k))
end

function binomialMC(n, k, p)
    outcomes = rand(Binomial(n, p), 5 * 10^6)
    condition = filter(x -> x == k, outcomes)
    return length(condition) / length(outcomes)
end

# x = rand(Uniform(0,1),1000)
# y = rand(Uniform(0,1),1000)
# total = length(x)*length(y)
# condition = [(x[i],y[i]) for i=1:1000 if (x[i]^2 + y[i]^2 <= 1)]

function areaF(xf, f, x0=0, pres=10^4)
    x = rand(Uniform(x0, xf), pres)
    y = rand(Uniform(f(x0), f(xf)), pres)
    # total = length(x)*length(y)
    condition = [(x[i], y[i]) for i = 1:pres if (y[i] <= f(x[i]))]
    return (length(condition) / length(x)) * (xf - x0) * (f(xf) - f(x0))
end

x0 = 0
xf = 6
pres = 10^4
g = x -> x^2
x = rand(Uniform(x0, xf), pres)
y = rand(Uniform(g(x0), g(xf)), pres)
total = length(x) * length(y)

fx = range(0, 6, length=100)
fy = g.(fx)
# plot(fx, g.(fx))
# xyM = [(x[i], y[i]) for i = 1:3000 if (y[i] > g(x[i]))]
# xym = [(x[i], y[i]) for i = 1:3000 if (y[i] <= g(x[i]))]
# scatter!(first.(xyM), last.(xyM), mc=:red, ms=2, ma=0.5)
# scatter!(first.(xym), last.(xym), mc=:green, ms=2, ma=0.5)
# savefig("montecarlo.png")
# Area aproximation (Integral)
function areaRet(f, x, dx=0.005)
    return f(x) * dx
end

function areaIntegral(f, x0, xf, dx=0.005)
    return sum(map(x -> areaRet(f, x, dx), range(x0, xf, step=dx)))
end

areaIntegral(x -> sin(x), 0, pi / 4, 0.000005)
cos(0) - cos(pi / 4)

# Imperative Version
#
# function areaIntegral(f,x0,xf,dx=0.005)
#     I = 0
#     for xi in range(x0,xf, step=dx)
#         I += areaRet(f,xi,dx)
#     end
#     return I
# end

# function partial(f,a...)
#   (b...) -> f(a...,b...)
# end

# using Javis, Animations, Colors

# function ground(args...)
#     background("black")
#     sethue("white")
# end


xyM = [(x[i], y[i]) for i = 1:3000 if (y[i] > g(x[i]))]
xym = [(x[i], y[i]) for i = 1:3000 if (y[i] <= g(x[i]))]
# scatter!(first.(xyM), last.(xyM), mc=:red, ms=2, ma=0.5)
# scatter!(first.(xym), last.(xym), mc=:green, ms=2, ma=0.5)

# video = Video(600, 400)

# actions = [
#     Action((args...) -> circle(O, 5, :fill),
#         Translation(Point(-100, 0), Point(first(xym[40]), 0))
#     )
# ]

# javis(
#     video,
#     [BackgroundAction(1:200, ground), actions...],
#     pathname="images/loading.gif",
# )

function g(p,q,f)
    return p*log(1+f) + q*log(1-f)
end

fs = range(0,0.5, 100)

function gl(p, q, f)
    return (p-q-f)/((1-f)*(1+f))
end


function gll(p,q,f)
    return (-p/(1+f)^2) + (-q/(1-f)^2)
end

p1=plot(fs,g.(0.6, 0.4,fs), title="Expectativa(aposta)", xlabel="f: aposta", ylabel="g(f): expectativa")
scatter!([0.2],[g(0.6,0.4,0.2)], mc=:red)
annotate!(0.2, 0.021, text("Max", :bottom, 8))
annotate!(0.2, 0.018, text("(x,y) = (0.2, 0.0201)", :top, 8))
p2=plot(fs, gl.(0.6,0.4,fs), title="Derivada primeira")
scatter!([0.2], [0], mc=:red)
annotate!(0.2, 0.02, text("deriv=0", :bottom, 8))
annotate!(0.2, -0.02, text("(x,y) = (0.2, 0.0)", :top, 8))
p3=plot(fs, gll.(0.6,0.4,fs), title="Derivada segunda")
plot(p1,p2,p3)
savefig("expectativa.png")
plot(p2)


moeda_viciada = Binomial(1, 6/10)
p = plot()
for m=1:10
    v0=400
    n=1000
    jogadas = rand(moeda_viciada, n)
    v=zeros(n)
    v[1]=v0
    for i=1:n-1
        if jogadas[i] == 1
            v[i+1] = v[i] + 1*(0.1*v[i])
        else
            v[i+1] = v[i] - 1*(0.1*v[i])
        end
    end
    plot!(v[1:n], yaxis=:log)
end

for m=1:10
    v0=400
    n=1000
    jogadas = rand(moeda_viciada, n)
    v=zeros(n)
    v[1]=v0
    for i=1:n-1
        if jogadas[i] == 1
            v[i+1] = v[i] + 1*(0.2*v[i])
        else
            v[i+1] = v[i] - 1*(0.2*v[i])
        end
    end
    plot!(v[1:n], yaxis=:log)
end

plot(p, title="Vários jogos de 1000 coin-flips", xlabel="Estratégia, aposta 10% vs 20% (moeda 60% viciada)", ylabel="Valor da banca (escala log)", legend=false)

savefig("estrategia-moeda-viciada.png")
