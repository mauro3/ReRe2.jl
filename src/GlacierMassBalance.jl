function melt(T, melt_factor)
    if T>0
        return T * melt_factor
    else
        return 0.0
    end
end

function accumulate(T, P, T_threshold)
    if T<= T_threshold
        P
    else
        return 0.0
    end
end

function lapse(T, dz, lapse_rate)
    return T + dz * lapse_rate
end

function synthetic_T(t)
    return -10*cos(2pi/364 * t) - 8*cos(2pi* t) + 5
end

function synthetic_P(t)
    return 8e-3
end


function total_point_balance(dt, Ts, Ps, melt_factor, T_threshold)
    @assert length(Ts)==length(Ps)
    total = 0.0
    for i = 1:length(Ts)
        T, P = Ts[i], Ps[i]
        total = total - melt(T, melt_factor) * dt + accumulate(T, P, T_threshold) * dt
    end
    return total
end

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
