# ---------------------
# Define the x-y range and step size for the plot
using Plots
using Random

# Define the x-y range and step size for the plot
xmin, xmax = -10, 10
ymin, ymax = -10, 10
dx, dy = 1, 1

# Define the number of frames in the animation
nframes = 50

# Define a function to generate random points
function generate_points(n, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax)
    x = rand(Float64, n) .* (xmax - xmin) .+ xmin
    y = rand(Float64, n) .* (ymax - ymin) .+ ymin
    return hcat(x, y)
end

# function generate_points(n)
#     Random.seed!(123) # set a random seed for reproducibility
#     [rand(xmin:xmax), rand(ymin:ymax)] for i in 1:n
# end

# Create an empty plot
plotVar = plot()

# Add the x and y axes to the plot
# xaxis = Axis(LinearScale(min=xmin, max=xmax), label="x")
# yaxis = Axis(LinearScale(min=ymin, max=ymax), label="y")
# add!(plotVar, xaxis, yaxis)

# Define a function to update the plot for each frame of the animation
function update_plot(frame)
    x0 = 0
    xf = 6
    pres = 10^4
    g = x -> x^2
    x = rand(Uniform(x0, xf), pres)
    y = rand(Uniform(g(x0), g(xf)), pres)
    fx = range(0, 6, length=100)
    plot(fx, g.(fx))
    xyM = [(x[i], y[i]) for i = 1:3000 if (y[i] > g(x[i]))]
    xym = [(x[i], y[i]) for i = 1:3000 if (y[i] <= g(x[i]))]
    scatter!(first.(xyM), last.(xyM), mc=:red, ms=2, ma=0.5)
    scatter!(first.(xym), last.(xym), mc=:green, ms=2, ma=0.5)
end

# Create the animation
animation = @animate for frame in 1:nframes
    update_plot(plotVar, frame)
end

# Save the animation as an MP4 file
mp4(animation, "random_points.mp4")



using Plots
Plots.animation("my_animation.gif")

function random_points_animation(n; xmax=10, ymax=10; duration=5)
    points = Plot[] # an empty list of plots to create the animation
    for i in 1:duration*24 # creating 24 frames per second
        x_values = rand(1:xmax, n)
        y_values = rand(1:ymax, n)
        current_plot = scatter(x_values, y_values, xlim=(0, xmax), ylim=(0,
                ymax), markersize=5)
        push!(points, current_plot)
    end
    frames = [Plots.Frame(p) for p in points]
    animation = Plots.Animation(frames, fps=24)
    return animation
end

anim = random_points_animation(50, xmax=10, ymax=10, duration=5)
gif(anim, "random_points.gif")

@userplot CirclePlot
@recipe function f(cp::CirclePlot)
    Random.seed!(123) # set a random seed for reproducibility
    xyM = [(x[i], y[i]) for i = 1:3000 if (y[i] > g(x[i]))]
    xym = [(x[i], y[i]) for i = 1:3000 if (y[i] <= g(x[i]))]
    x, y, i = cp.args
    n = length(x)
    inds = circshift(1:n, 1 - i)
    linewidth --> range(0, 10, length=n)
    seriesalpha --> range(0, 1, length=n)
    aspect_ratio --> 1
    label --> false
    # x[inds], y[inds]
    first(xyM[i]), last(xym[i])
end

n = 150
t = range(0, 2π, length=n)
x = sin.(t)
y = cos.(t)

anim = @animate for i ∈ 1:n
    circleplot(x, y, i)
end
gif(anim, "anim_fps15.gif", fps=15)
