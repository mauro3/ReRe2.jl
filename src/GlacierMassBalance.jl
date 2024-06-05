using DelimitedFiles

"""
    melt(T, melt_factor)

Calculate the melt amount given temperature `T` and a `melt_factor`.

# Arguments
- `T`: The temperature.
- `melt_factor`: The factor by which the temperature is scaled to get the melt value.

# Returns
- The computed melt amount. Returns 0 if `T` is less than or equal to 0, otherwise returns `T * melt_factor`.
"""
function melt(T, melt_factor)
    if T>0
        return T * melt_factor
    else
        return 0.0
    end
end



"""
    accumulate(T, P, T_threshold)

Calculate the accumulation given temperature `T`, precipitation `P`, and a temperature threshold `T_threshold`.

# Arguments
- `T`: The temperature.
- `P`: The precipitation.
- `T_threshold`: The temperature threshold for accumulation.

# Returns
- `P` if `T` is less than or equal to `T_threshold`, otherwise returns 0.
"""
function accumulate(T, P, T_threshold)
    if T<= T_threshold
        P
    else
        return 0.0
    end
end



"""
    lapse(T, dz, lapse_rate)

Compute the temperature adjustment using lapse rate for a given elevation change.

# Arguments
- `T::Number`: The initial temperature.
- `dz::Number`: The change in elevation.
- `lapse_rate::Number`: The lapse rate (temperature change per unit elevation change), note <0

# Returns
- The adjusted temperature.
"""
function lapse(T, dz, lapse_rate)
    return T + dz * lapse_rate
end


"""
    total_point_balance(dt, Ts, Ps, melt_factor, T_threshold)

Calculate the total point balance over time for given temperature and precipitation arrays.

# Arguments
- `dt`: The time step.
- `Ts`: Array of temperatures.
- `Ps`: Array of precipitations.
- `melt_factor`: The factor to compute melt amount.
- `T_threshold`: The temperature threshold for accumulation.

# Returns
- The total point balance.
"""
function total_point_balance(dt, Ts, Ps, melt_factor, T_threshold)
    @assert length(Ts)==length(Ps)
    total = 0.0
    for i = 1:length(Ts)
        T, P = Ts[i], Ps[i]
        total = total - melt(T, melt_factor) * dt + accumulate(T, P, T_threshold) * dt
    end
    return total
end



"""
    total_glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)

Calculate the total glacier balance over time and elevation.

# Arguments
- `zs`: Array of elevations.
- `dt`: The time step.
- `Ts`: Array of temperatures.
- `Ps`: Array of precipitations.
- `melt_factor`: The factor to compute melt amount.
- `T_threshold`: The temperature threshold for accumulation.
- `lapse_rate`: The lapse rate (temperature change per unit elevation change).

# Returns
- The total glacier balance.
"""
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

include("utils.jl")
include("data.jl")
