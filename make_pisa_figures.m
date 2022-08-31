% script to make figures of various centrality measures on the map of central Pisa.

[G, H] = read_graphs('pisa_cropped');
G.Edges.Length = hypot(G.Edges.x1-G.Edges.x2, G.Edges.y1-G.Edges.y2); weights = exp(-G.Edges.Length/max(G.Edges.Length));

v = kementrality_all_chol_parallel(G, 1e-8, weights);
plotgraph_pisa(G, v, 'Kemeny-based centrality r=1e-8, unfiltered', 'pisa_cropped_kementrality_chol_1em8_unfiltered.pdf');
vv = v; vv(v>0.5e8) = 1e8 - vv(v>0.5e8);
plotgraph_pisa(G, vv, 'Kemeny-based centrality r=1e-8, filtered', 'pisa_cropped_kementrality_chol_1em8_filtered.pdf');
% pagerank turned to an edge measure
tic
vn = centrality(G, 'pagerank', 'Importance', weights);
A = adjacency(G, weights);
d = sum(A, 2);
P = d .\ A;
v = zeros(numedges(G),1);
for k = 1:numedges(G)
    [i,j] = findedge(G,k);
    v(k) = vn(i)*P(i,j) + vn(j)*P(j,i); % probability of taking an edge
end
toc
plotgraph_pisa(G, v, 'Road-taking probability in the Pagerank model', 'pisa_cropped_pagerank_edges.pdf');
v = centrality(H, 'pagerank');
plotgraph_pisa(G, v, 'Pagerank on the (unweighted) dual graph', 'pisa_cropped_pagerank_dual.pdf');
v = centrality(H, 'betweenness');|
plotgraph_pisa(G, v, 'Betweenness on the (unweighted) dual graph', 'pisa_cropped_betweenness_dual.pdf');

% run make_figures_helper.py

M = load('pisa_cropped_edge_betweenness.mat');
for k = 1:size(M.ij,1)
    loc = find((G.Edges.EndNodes(:,1) == M.ij(k,1) & G.Edges.EndNodes(:,2) == M.ij(k,2)) | (G.Edges.EndNodes(:,1) == M.ij(k,2) & G.Edges.EndNodes(:,2) == M.ij(k,1)));
    assert(length(loc)==1);
    v(loc) = M.v(k);
end
plotgraph_pisa(G, v, 'Edge betweenness (from Networkx)', 'pisa_cropped_edge_betweenness.pdf');

M = load('pisa_cropped_edge_current_flow_betweenness.mat');
for k = 1:size(M.ij,1)
    loc = find((G.Edges.EndNodes(:,1) == M.ij(k,1) & G.Edges.EndNodes(:,2) == M.ij(k,2)) | (G.Edges.EndNodes(:,1) == M.ij(k,2) & G.Edges.EndNodes(:,2) == M.ij(k,1)));
    assert(length(loc)==1);
    v(loc) = M.v(k);
end
plotgraph_pisa(G, v, 'Edge current flow betweenness (from Networkx)', 'pisa_cropped_edge_current_flow_betweenness.pdf');

M = load('pisa_cropped_edge_load_centrality.mat');
for k = 1:size(M.ij,1)
    loc = find((G.Edges.EndNodes(:,1) == M.ij(k,1) & G.Edges.EndNodes(:,2) == M.ij(k,2)) | (G.Edges.EndNodes(:,1) == M.ij(k,2) & G.Edges.EndNodes(:,2) == M.ij(k,1)));
    assert(length(loc)==1);
    v(loc) = M.v(k);
end
plotgraph_pisa(G, v, 'Edge load centrality (from Networkx)', 'pisa_cropped_edge_load_centrality.pdf');

