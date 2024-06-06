# visualize temperature data
plot(t, T, xlabel="time (d)", ylabel="T (C)")
savefig(make_sha_filename(joinpath(results_dir, "gorner_T"), ".png"))


mask, _ = ASCIIrasters.read_ascii(mask_fl)
dem, _ = ASCIIrasters.read_ascii(dem_fl)
heatmap(mask)
heatmap(dem)
