function melt(T, melt_factor)
    if T>0
        return T * melt_factor
    else
        return 0.0
    end
end

@assert melt(0, 1) == 0
@assert melt(-10, 1) == 0
@assert melt(1, 1) == 1
@assert melt(4, 7) == 4*7
melt_factor = 0.005
@assert melt(4, melt_factor) == 4*melt_factor

function accumulate(T, P, T_threshold)
    if T<= T_threshold
        P
    else
        return 0.0
    end
end

@assert accumulate(0, 5, 4) > 0
@assert accumulate(5, 5, 4) == 0


function lapse(T, dz, lapse_rate)
    return T + dz * lapse_rate
end

@assert lapse(5, 100, 1) > 5
@assert lapse(5, -100, 1) < 5

function synthetic_T(t)
    return -10*cos(2pi/364 * t) - 8*cos(2pi* t) + 5
end

function synthetic_P(t)
    return 8e-3
end

using Plots
t = 0:1/24:365
plot(t, synthetic_T.(t))

function total_point_balance(dt, Ts, Ps, melt_factor, T_threshold)
    @assert length(Ts)==length(Ps)
    total = 0.0
    for i = 1:length(Ts)
        T, P = Ts[i], Ps[i]
        total = total - melt(T, melt_factor) * dt + accumulate(T, P, T_threshold) * dt
    end
    return total
end

dt = 1/24
t = 0:dt:365
lapse_rate = -0.6/100
melt_factor = 0.005
T_threshold = 4

ele = 1500
Ts = lapse.(synthetic_T.(t), ele, lapse_rate); maximum(Ts)
Ps = synthetic_P.(t);
total_point_balance(dt, Ts, Ps, melt_factor, T_threshold)


function total_glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
    total = 0.0
    total_area = 0.0
    TT = lapse.(Ts, zs[1], lapse_rate)
    for i = 1:length(zs)
        z = zs[i]
        TT = lapse.(Ts, z, lapse_rate)
        total = total + total_point_balance(dt, TT, Ps, melt_factor, T_threshold)
    end
    return total
end

function synthetic_glacier()
    x = 0:500:5000
    elevation = x .* 0.2 .+ 1400
    cell_area = 500*500 # area of one cell
    return elevation, cell_area
end

zs, dA = synthetic_glacier()
Ts = synthetic_T.(t)
total_glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
