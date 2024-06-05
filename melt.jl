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

function accumulate(T, P_h)
    if T<=4
        P_h
    else
        return 0.0
    end
end

@assert accumulate(0, 5) > 0
@assert accumulate(5, 5) == 0


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
