# This is for Gornergletscher
using Plots; pyplot()
using Downloads: Downloads
using ZipFile:ZipFile

results_dir = joinpath(@__DIR__, "../../results/")

## Setup project folder
mkpath(joinpath(@__DIR__, "../../data/own"))      # this is where our data is placed
mkpath(joinpath(@__DIR__, "../../data/foreign"))  # this is where other peoples data is placed
mkpath(joinpath(@__DIR__, "../../results"))

## Download data
weather_fl = joinpath(@__DIR__, "../../data/own/weather.dat")
if !isfile(weather_fl)
    Downloads.download("https://raw.githubusercontent.com/mauro3/CORDS/master/data/weather.dat",
             weather_fl)
    Downloads.download("https://raw.githubusercontent.com/mauro3/CORDS/master/data/weather.info",
             joinpath(@__DIR__, "../../data/own/weather.dat") )
end
dem_fl = joinpath(@__DIR__, "../../data/foreign/dhm200.asc")
if !isfile(dem_fl)
    Downloads.download("https://data.geo.admin.ch/ch.swisstopo.digitales-hoehenmodell_25/data.zip",
                       joinpath(@__DIR__, "../../data/foreign/dhm200.zip") )
    # do some processing, namely unzip
    r = ZipFile.Reader(joinpath(@__DIR__, "../../data/foreign/dhm200.zip"))
    for f in r.files
        if f.name == DHM200.asc
            write(dem_fl, read(f, String));
        end
    end
    # delete zip file as we don't need it anymore
    rm(joinpath(@__DIR__, "../../data/foreign/dhm200.zip"))
end
mask_fl = joinpath(@__DIR__, "../../data/own/glacier_mask.asc")
if !isfile(mask_fl)
    Downloads.download("https://raw.githubusercontent.com/mauro3/CORDS/master/data/glacier_mask.asc",
             mask_fl)
end

## Read data and visualize it



## run melt model for a point at 2600m

## run melt model for the whole glacier
