import pandas as pd
# import numpy as np
tb = pd.read_csv("TB_burden_countries_2014-09-29.csv")
tbNamibia = tb[tb['country'] == 'Namibia'].head(5)
tbAfghanistan = tb[tb['country'] == 'Afghanistan'].head(5)
tbcopy = tbNamibia.append(tbAfghanistan, ignore_index=True)
tbcopy