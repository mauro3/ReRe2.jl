# A glacier melt model applied to Breithorngletscher (Zermatt, Switzerland) to learn about reproducible research practices

This an example code repository going along with the workshop https://github.com/mauro3/CORDS/tree/master/Workshop-Reproducible-Research

## Melt model

The model is a simple temperature index melt model.
Temperature is lapses with a linear function.
Precipitation is from measurements and a threshold temperature determines whether it is snow.


## Data

- measured temperature (operated by VAW-LG in 2007) from a met-station near Breithorngletscher is used
- digital elevation model is the DHM200 of swisstopo
- mask is derived from outlines of the Swiss Glacier Inventory (however, we pretend that we digitised that outline ourselves)

Data is located at https://raw.githubusercontent.com/mauro3/CORDS/master/data/workshop-reproducible-research
