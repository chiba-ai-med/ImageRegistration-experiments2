# -*- coding: utf-8 -*-

# Package Loading
import sys
import numpy as np
import pandas as pd
import ot
from scipy.spatial import distance
from sklearn.cluster import KMeans
import pickle

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
outfile1 = args[3]
outfile2 = args[4]
epsilon = float(args[5])

# Loading Data
source_exp = pd.read_csv(infile1, header=0)
target_exp = pd.read_csv(infile2, header=0)

# Column Names
source_cols = source_exp.columns.to_numpy()

# Log-Transformation
source_exp = np.log10(source_exp.to_numpy() + 1)
target_exp = np.log10(target_exp.to_numpy() + 1)

# Distance
C1 = distance.cdist(source_exp, source_exp)
C2 = distance.cdist(target_exp, target_exp)
C1 = C1 / np.max(C1)
C2 = C2 / np.max(C2)

# Merginal Distribution
h1 = np.ones(C1.shape[0]) / C1.shape[0]
h2 = np.ones(C2.shape[0]) / C2.shape[0]

# Clustering（重いステップ1、C1/C2に対しては計算できなかった）
part1 = KMeans(n_clusters=30, random_state=0, n_init="auto").fit(source_exp).labels_
part2 = KMeans(n_clusters=30, random_state=0, n_init="auto").fit(target_exp).labels_

# Cluster Center
rep_indices1 = ot.gromov.get_graph_representants(C1, part1, rep_method='pagerank')
rep_indices2 = ot.gromov.get_graph_representants(C2, part2, rep_method='pagerank')

# Formatting
CR1, list_R1, list_h1 = ot.gromov.format_partitioned_graph(
    C1, h1, part1, rep_indices1, F=None, M=None, alpha=1.)
CR2, list_R2, list_h2 = ot.gromov.format_partitioned_graph(
    C2, h2, part2, rep_indices2, F=None, M=None, alpha=1.)

# Partitioned quantized gromov-wasserstein solver（重いステップ2, build_OT=Falseなら動く）
T_global, Ts_local, _, log = ot.gromov.quantized_fused_gromov_wasserstein_partitioned(
    CR1, CR2, list_R1, list_R2, list_h1, list_h2, MR=None,
    alpha=1., build_OT=False, log=True, reg=epsilon, verbose=True)

# Transportation
t_source_exp = np.zeros((target_exp.shape[0], source_exp.shape[1]))

for i in range(30):
    list_Ti = []
    for j in range(30):
        if T_global[i, j] == 0.:
            T_local = np.zeros((list_R1[i].shape[0], list_R2[j].shape[0]))
        else:
            T_local = T_global[i, j] * Ts_local[(i, j)]
        list_Ti.append(T_local)
    Ti = np.concatenate(list_Ti, axis=1)
    # Normalization
    if Ti.max() != 0:
        row_sums = Ti.sum(axis=1)
        Ti = Ti / row_sums[:, np.newaxis]
    # Update
    position = np.where(part1 == i)[0]
    t_source_exp += Ti.T @ source_exp[position, ]

# Save
with open(outfile1, 'wb') as f:
    pickle.dump(T_global, f)
    pickle.dump(Ts_local, f)
    pickle.dump(log, f)

out = pd.DataFrame(t_source_exp)
out.columns = source_cols
out.to_csv(outfile2, index=False)
