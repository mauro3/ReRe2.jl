# make extra outputs

# visualize temperature data
plot(t, Ts, xlabel="time (d)", ylabel="T (C)")
savefig(make_sha_filename(joinpath(results_dir, "gorner_T"), ".png"))


heatmap(mask)
savefig(make_sha_filename(joinpath(results_dir, "breithorn_mask"), ".png"))
heatmap(dem)
savefig(make_sha_filename(joinpath(results_dir, "breithorn_dem"), ".png"))
