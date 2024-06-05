include("../src/GlacierMassBalance.jl")


"""
    synthetic_T(t)

Generate synthetic temperature for a given time `t`.

# Arguments
- `t::Number`: The time.

# Returns
- `Number`: The synthetic temperature.
"""
function synthetic_T(t)
    return -10*cos(2pi/364 * t) - 8*cos(2pi* t) + 5
end



"""
    synthetic_P(t)

Generate synthetic precipitation for a given time `t`.

# Arguments
- `t::Number`: The time.

# Returns
- `Number`: The synthetic precipitation (constant value 8e-3).
"""
function synthetic_P(t)
    return 8e-3
end


"""
    synthetic_glacier()

Generate synthetic glacier elevation.

# Returns
- `AbstractVector{Number}`: array of elevations
"""
function synthetic_glacier()
    x = 0:500:5000
    elevation = x .* 0.2 .+ 1400
    return elevation
end


using Plots
t = 0:1/24:365
plot(t, synthetic_T.(t))

dt = 1/24
t = 0:dt:365
lapse_rate = -0.6/100
melt_factor = 0.005
T_threshold = 4

ele = 1500
Ts = lapse.(synthetic_T.(t), ele, lapse_rate); maximum(Ts)
Ps = synthetic_P.(t);
total_point_balance(dt, Ts, Ps, melt_factor, T_threshold)

zs, dA = synthetic_glacier()
Ts = synthetic_T.(t)
smb = total_glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)

# make a table for different temperature offsets and store it
out = []
for dT = -4:4
    Ts = synthetic_T.(t) .+ dT
    smb = total_glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
    push!(out, [dT, smb])
end
using DelimitedFiles
writedlm(make_sha_filename("deltaT_impact", ".csv"), out, ',')
