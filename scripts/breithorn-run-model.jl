## Read data
t, Ts = read_campbell(weather_fl)
dem,_ = ASCIIrasters.read_ascii(dem_fl)
mask,_ = ASCIIrasters.read_ascii(mask_fl)


## Run the model for the whole glacier on time with index 4382
zs = dem[mask.==1] .- z_weather_station
dt = diff(t)[1]
Ps = 0.005 .+ Ts*0; # just a constant in m/day
total, points = glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
out = dem.*NaN
out[mask.==1] .= points
heatmap(out)
savefig(make_sha_filename(joinpath(results_dir, "breithorn_melt_field"), ".png"))

## Generate output table
# make a table for smb of different temperature offsets and store it
out = []
for dT = -4:4
    Ts_ = Ts .+ dT
    smb_, _ = glacier_balance(zs, dt, Ts_, Ps, melt_factor, T_threshold, lapse_rate)
    push!(out, [dT, smb_])
end
using DelimitedFiles
writedlm(make_sha_filename("../../results/deltaT_impact", ".csv"), out, ',')
