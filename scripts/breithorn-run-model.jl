## Read data
t, Ts = read_campbell(weather_fl)
dem,_ = ASCIIrasters.read_ascii(dem_fl)
mask,_ = ASCIIrasters.read_ascii(mask_fl)

## Visualize input data
plot(t, Ts, xlabel="time (d)", ylabel="T (C)")
savefig(make_sha_filename(joinpath(results_dir, "breithorn_T"), ".png"))
heatmap(mask)
savefig(make_sha_filename(joinpath(results_dir, "breithorn_mask"), ".png"))
heatmap(dem)
savefig(make_sha_filename(joinpath(results_dir, "breithorn_dem"), ".png"))

## Run the model for the whole Breithorn glacier
zs = dem[mask.==1] .- z_weather_station # use elevation of weather station as datum
dt = diff(t)[1]
Ps = 0.005 .+ Ts*0; # just a constant [m/day]
total_massbalance, point_massbalance = glacier_balance(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
point_massbalance_map = dem.*NaN
point_massbalance_map[mask.==1] .= point_massbalance
heatmap(point_massbalance_map)
savefig(make_sha_filename(joinpath(results_dir, "breithorn_massbalance_field"), ".png"))

## Generate output table
# make a table for massbalance of different temperature offsets and store it
out = []
for dT = -4:4
    Ts_ = Ts .+ dT
    massbalance_, _ = glacier_balance(zs, dt, Ts_, Ps, melt_factor, T_threshold, lapse_rate)
    push!(out, [dT, massbalance_])
end
writedlm(make_sha_filename("../../results/deltaT_impact", ".csv"), out, ',')
