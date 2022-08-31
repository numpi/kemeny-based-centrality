#!/usr/bin/python3

# Script to do the Python part of make_pisa_figures. Must be run before the corresponding Matlab file.

import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import scipy.io
import json
from read_graphs import *

basename = 'pisa_cropped'

G = read_primal_graph(basename)
H, dual_map = read_dual_graph(basename)
# for i,j in H.edges: H[i][j]['AbsChangeOfDirection'] = abs(H[i][j]['ChangeOfDirection'])

maxLength = 0.;
for i,j in G.edges: 
	G[i][j]['Length'] = np.hypot(G[i][j]['x1'] - G[i][j]['x2'], G[i][j]['y1'] - G[i][j]['y2'])
	maxLength = max(maxLength, G[i][j]['Length'])

for i,j in G.edges:
	G[i][j]['ExpmLength'] = np.exp(-G[i][j]['Length'] / maxLength)


# bwness

c = nx.edge_betweenness_centrality(G, weight='Length')

v = np.array([d for d in c.values()])
i = np.array([d[0] for d in c.keys()])
j = np.array([d[1] for d in c.keys()])

sp.io.savemat(f'{basename}_edge_betweenness.mat', {'ij': np.column_stack([i,j]), 'v': v})

# currrent flow bwness

c = nx.edge_current_flow_betweenness_centrality(G, weight='ExpmLength')

v = np.array([d for d in c.values()])
i = np.array([d[0] for d in c.keys()])
j = np.array([d[1] for d in c.keys()])

sp.io.savemat(f'{basename}_edge_current_flow_betweenness.mat', {'ij': np.column_stack([i,j]), 'v': v})

c = nx.edge_load_centrality(G)  # does not support weights
v = np.array([d for d in c.values()])
i = np.array([d[0] for d in c.keys()])
j = np.array([d[1] for d in c.keys()])

sp.io.savemat(f'{basename}_edge_load_centrality.mat', {'ij': np.column_stack([i,j]), 'v': v})

