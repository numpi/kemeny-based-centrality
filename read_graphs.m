function [G, H] = read_graphs(basename)

% read in basename_nodes.csv, basename_edges.csv, basename_dual_edges.csv

Nodes = readtable(strcat(basename, '_nodes.csv'));
Edges = readtable(strcat(basename, '_edges.csv'));

% makes sure the first two columns come from EndNodes
assert(strcmp(Edges.Properties.VariableNames{1},'EndNodes_1'));
assert(strcmp(Edges.Properties.VariableNames{2},'EndNodes_2'));

G = graph(Edges.EndNodes_1, Edges.EndNodes_2, Edges(:, 3:end));
G.Nodes = Nodes;

if nargout > 1
    DualEdges = readtable(strcat(basename, '_dual_edges.csv'));
    % makes sure the first two columns come from EndNodes
    assert(strcmp(DualEdges.Properties.VariableNames{1},'EndNodes_1'));
    assert(strcmp(DualEdges.Properties.VariableNames{2},'EndNodes_2'));
    H = graph(DualEdges.EndNodes_1, DualEdges.EndNodes_2, DualEdges(:, 3:end));
    H.Nodes = G.Edges;
end

