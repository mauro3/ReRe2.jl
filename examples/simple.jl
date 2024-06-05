include("../src/GlacierMassBalance.jl")

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
@show smb
