## Read data
t, Ts = read_campbell(weather_fl)
dem,_ = ASCIIrasters.read_ascii(dem_fl)
mask,_ = ASCIIrasters.read_ascii(mask_fl)


## Run the model for one year for the whole glacier
zs = dem[mask.==1] .- z_weather_station
dt = diff(t)[1]
Ps = 0.005 .+ Ts*0; # just a constant in m/day
@show Ps[1]*365
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
