## Main script to run all Breithorngletscher tasks

# Keep the data-fetching separate from the processing/model code.  This is also where to put model parameters.
# This way all the input-data & input-parameters are in one place.
include("breithorn-getdata.jl")
include("breithorn-model-paras.jl")

include("breithorn-run-model.jl")
