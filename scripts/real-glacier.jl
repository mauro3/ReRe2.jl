# This is for Gornergletscher
using Plots; pyplot()
using Downloads: Downloads
using ZipFile:ZipFile
using ASCIIrasters
include("../src/GlacierMassBalance.jl")

results_dir = joinpath(@__DIR__, "../../results/")

## Setup project folder
mkpath(joinpath(@__DIR__, "../../data/own"))      # this is where our data is placed
mkpath(joinpath(@__DIR__, "../../data/foreign"))  # this is where other peoples data is placed
mkpath(joinpath(@__DIR__, "../../results"))

## Download data
weather_fl = joinpath(@__DIR__, "../../data/own/weather.dat")
if !isfile(weather_fl)
    Downloads.download("https://raw.githubusercontent.com/mauro3/CORDS/master/data/workshop-reproducible-research/own/weather.dat",
                       weather_fl)
    # don't download the info file weather.info
end

mask_fl = joinpath(@__DIR__, "../../data/own/mask_breithorngletscher.asc")
if !isfile(mask_fl)
    zip_fl = splitext(mask_fl)[1]*".zip"
    Downloads.download("https://github.com/mauro3/CORDS/raw/master/data/workshop-reproducible-research/own/mask_breithorngletscher.zip",
                       zip_fl)
    # do some processing, namely unzip
    r = ZipFile.Reader(zip_fl)
    for f in r.files
        if f.name == "mask_breithorngletscher/mask_breithorngletscher.asc"
            write(mask_fl, read(f, String))
        end
    end
    # delete zip file as we don't need it anymore
    rm(zip_fl)
end

dem_fl = joinpath(@__DIR__, "../../data/foreign/dhm200_cropped.asc")
if !isfile(dem_fl)
    zip_fl = splitext(dem_fl)[1]*".zip"
    Downloads.download("https://github.com/mauro3/CORDS/raw/master/data/workshop-reproducible-research/foreign/swisstopo_dhm200_cropped.zip",
                       zip_fl)
    # do some processing, namely unzip
    r = ZipFile.Reader(zip_fl)
    for f in r.files
        if f.name == "swisstopo_dhm200_cropped/dhm200_cropped.asc"
            write(dem_fl, read(f, String));
        end
    end
    # delete zip file as we don't need it anymore
    rm(zip_fl)
end

## Read data and visualize it
t, T = read_campbell(weather_fl)
plot(t, T, xlabel="time (d)", ylabel="T (C)")
savefig(make_sha_filename(joinpath(results_dir, "gorner_T"), ".png"))

mask, _ = ASCIIrasters.read_ascii(mask_fl)
dem, _ = ASCIIrasters.read_ascii(dem_fl)
heatmap(mask)
heatmap(dem)


## run melt model for a point at 3000m


## run melt model for the whole Breithorn glacier
