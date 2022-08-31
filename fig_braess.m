% script to create a figure displaying Braess' paradox

[G, H] = read_graphs('braess');
plotgraph_braess(G, 'Braess paradox 1', 'braess1.pdf');
GG = rmedge(G, 1, 2);
plotgraph_braess(GG, 'Braess paradox 2', 'braess1.pdf');