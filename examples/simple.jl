include("../src/GlacierMassBalance.jl")

## Define the synthetic weather and glacier

"""
    synthetic_T(t)

Generate synthetic temperature for a given time `t`.

# Arguments
- `t`: The time.

# Returns
- The synthetic temperature.
"""
function synthetic_T(t)
    return -10*cos(2pi/364 * t) - 8*cos(2pi* t) + 5
end



"""
    synthetic_P(t)

Generate synthetic precipitation for a given time `t`.

# Arguments
- `t`: The time.

# Returns
- The synthetic precipitation (constant value 8e-3).
"""
function synthetic_P(t)
    return 8e-3
end


"""
    synthetic_glacier()

Generate synthetic glacier elevation.

# Returns
- Array of elevations
"""
function synthetic_glacier()
    x = 0:500:5000
    elevation = x .* 0.2 .+ 1400
    return elevation
end

## Some constants
lapse_rate = -0.6/100
melt_factor = 0.005
T_threshold = 4
dt = 1/24
t = 0:dt:365

## Plot the synthetic weather
using Plots; pyplot()
plot(t, synthetic_T.(t), xlabel="time (d)", ylabel="T (C)")
savefig(make_sha_filename("results/synthetic_T", ".png"))

## Run the model for one year at a point
ele = 1500
Ts_ele = lapse.(synthetic_T.(t), ele, lapse_rate)
Ps = synthetic_P.(t);
total_point_balance(dt, Ts_ele, Ps, melt_factor, T_threshold)

## Run the model for one year for the whole glacier
zs = synthetic_glacier()
Ts = synthetic_T.(t)
smb = total_glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)

## Generate output table
# make a table for different temperature offsets and store it
out = []
for dT = -4:4
    Ts_ = synthetic_T.(t) .+ dT
    smb_ = total_glacier_balance(zs, dt, Ts_, Ps, melt_factor, T_threshold, lapse_rate)
    push!(out, [dT, smb_])
end
using DelimitedFiles
mkpath("results")
writedlm(make_sha_filename("results/deltaT_impact", ".csv"), out, ',')
