######
# File readers
######
"""
    read_campbell(file)

Reads a Campbell logger format file with temperature and precip.
Moves sampling from 30min to 1h

Return
- t -- as DateTime
- T -- [C]
- P -- [m/d]
- elevation -- [m asl]
"""
function read_campbell(file)
    dat = readdlm(file, ',')
    y, d, hm = dat[:,2], dat[:,3], dat[:,4]
    t = parse_campbell_date_time.(y,d,hm)
    # go from 30min dt to 60 min
    t = t[1:2:end]
    temp = dat[1:2:end,6]
    precip = dat[1:2:end,7] .+ dat[2:2:end,7] # this needs summing!
    elevation = 2650
    return t, temp, precip/1000*24, elevation
end

######
## Misc helpers
######


"""
    parse_date_time(year, day, HHMM)

Parse the Campbell logger time format:
`year, day of year, HHMM`

Return time in days since 1.1.2007 0:00
"""
function parse_campbell_date_time(year, day, HHMM)
    @assert year==2007
    hour = floor(HHMM/100)
    min = HHMM - 100*hour
    return day-1 + hour/24 + min/24/60
end
# Test it
@assert parse_campbell_date_time(2007, 1, 1239) ≈ 0.5270833333333333
@assert parse_campbell_date_time(2007, 365, 2359) ≈ 364.9993055555555
