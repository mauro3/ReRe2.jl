## To run the tests, execute this file from within the directory

include("../src/GlacierMassBalance.jl")
using Test

@test melt(0, 1) == 0
@test melt(-10, 1) == 0
@test melt(1, 1) == 1
@test melt(4, 7) == 4*7
melt_factor = 0.005
@test melt(4, melt_factor) == 4*melt_factor


@test accumulate(0, 5, 4) > 0
@test accumulate(5, 5, 4) == 0


@test lapse(5, 100, 1) > 5
@test lapse(5, -100, 1) < 5

# with no melt, accumulation is equal precip
melt_factor = 0
T_threshold = 10
@test total_point_balance(1, 1, 1.54, melt_factor, T_threshold)==1.54

# also test example
include("../examples/simple.jl")
@test total_massbalance ≈ -0.11096645178976892

# utils.jl testing
@test startswith(make_sha_filename("test", ".png"), "test-")
@test endswith(make_sha_filename("test", ".png"), ".png")
