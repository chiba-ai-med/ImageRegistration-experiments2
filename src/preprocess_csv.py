# -*- coding: utf-8 -*-
import os
import sys
import pandas as pd
import numpy as np

# Arguments
args = sys.argv
outfile1 = args[1]
outfile2 = args[2]
outfile3 = args[3]
outfile4 = args[4]
outfile5 = args[5]
outfile6 = args[6]
outfile7 = args[7]
outfile8 = args[8]
outfile9 = args[9]
outfile10 = args[10]
outfile11 = args[11]
outfile12 = args[12]

# Loading
source_all_exp = pd.read_csv("data/250701/df_sl.csv", header=0)
target_all_exp = pd.read_csv("data/250701/df_st.csv", header=0)

source_all_exp = source_all_exp.dropna(subset=["region"])
target_all_exp = target_all_exp.dropna(subset=["region"])

source_anatomy = source_all_exp.iloc[0:, 0:3]
target_anatomy = target_all_exp.iloc[0:, 0:3]
source_all_exp = source_all_exp.drop(['region'], axis=1).loc[0:,]
target_all_exp = target_all_exp.drop(['region'], axis=1).loc[0:,]

# Sort
source_all_exp = source_all_exp.sort_values(by=['X', 'Y'])
target_all_exp = target_all_exp.sort_values(by=['X', 'Y'])
source_anatomy = source_anatomy.sort_values(by=['X', 'Y'])
target_anatomy = target_anatomy.sort_values(by=['X', 'Y'])

# Filtering
source_x_coordinate = np.array(source_all_exp['X'].values, dtype=np.int64)
source_y_coordinate = np.array(source_all_exp['Y'].values, dtype=np.int64)
target_x_coordinate = np.array(target_all_exp['X'].values, dtype=np.int64)
target_y_coordinate = np.array(target_all_exp['Y'].values, dtype=np.int64)

source_all_exp = source_all_exp.iloc[:, 2:]
target_all_exp = target_all_exp.iloc[:, 2:]

# source_exp = source_all_exp.loc[:, 'SHexCer 42:1;2O_Negative']
# target_exp = target_all_exp.loc[:, 'Gal3st1']

source_anatomy = source_anatomy.iloc[:, 2:]
target_anatomy = target_anatomy.iloc[:, 2:]

# One-hot Encoding
s_source = source_anatomy.squeeze()
s_target = target_anatomy.squeeze()
all_labels = pd.Index(s_source.unique()).union(s_target.unique())
ohe_source = (
    pd.get_dummies(s_source)
    .reindex(columns=all_labels, fill_value=0)
    .astype(int)
)
ohe_target = (
    pd.get_dummies(s_target)
    .reindex(columns=all_labels, fill_value=0)
    .astype(int)
)

ohe_source.columns = [col.capitalize() for col in ohe_source.columns]
ohe_target.columns = [col.capitalize() for col in ohe_target.columns]

# Summation
source_sum_exp = source_all_exp.to_numpy(dtype=np.float64).sum(axis=1)
target_sum_exp = target_all_exp.to_numpy(dtype=np.float64).sum(axis=1)

# Binarization
bin_source_sum_exp = np.where(source_sum_exp > 0, 1, 0)
bin_target_sum_exp = np.where(target_sum_exp > 0, 1, 0)

# Save
source_all_exp.to_csv(outfile1, index=False)
target_all_exp.to_csv(outfile2, index=False)
np.savetxt(outfile3, source_sum_exp, fmt='%.10f')
np.savetxt(outfile4, target_sum_exp, fmt='%.10f')
np.savetxt(outfile5, bin_source_sum_exp, fmt='%d')
np.savetxt(outfile6, bin_target_sum_exp, fmt='%d')
ohe_source.to_csv(outfile7, index=False)
ohe_target.to_csv(outfile8, index=False)
np.savetxt(outfile9, source_x_coordinate, fmt='%d')
np.savetxt(outfile10, target_x_coordinate, fmt='%d')
np.savetxt(outfile11, source_y_coordinate, fmt='%d')
np.savetxt(outfile12, target_y_coordinate, fmt='%d')