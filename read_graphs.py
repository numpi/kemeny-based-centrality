#!/usr/bin/python3

"""
Functions to read our csv graph files into Networkx.

Sample usage:
```
import networkx as nx
import matplotlib.pyplot as plt

G = read_graphs('firenze')
H, dual_map = read_dual_graph('firenze')


# node centrality

c = nx.katz_centrality(G)

pos = {n:(G.nodes[n]['x'],G.nodes[n]['y']) for n in G.nodes}
ax = plt.gca()
nx.draw_networkx_edges(G, pos, ax=ax, node_size=10)
nx.draw_networkx_nodes(G, pos, ax=ax, node_size=10, node_color=[c[i] for i in G.nodes])
ax.autoscale()
plt.show()

# edge centrality

c = nx.katz_centrality(H)
c_mapped = [c[dual_map[tuple(sorted(e))]] for e in G.edges]
pos = {n:(G.nodes[n]['x'],G.nodes[n]['y']) for n in G.nodes}
ax = plt.gca()
nx.draw_networkx_edges(G, pos, ax=ax, node_size=10, edge_color = c_mapped)
ax.autoscale()
plt.show()

# Betweenness centrality of roads (slow)

for i,j in H.edges: H[i][j]['AbsChangeOfDirection'] = abs(H[i][j]['ChangeOfDirection'])
c = nx.betweenness_centrality(H, weight='AbsChangeOfDirection')
c_mapped = [c[dual_map[tuple(sorted(e))]] for e in G.edges]
pos = {n:(G.nodes[n]['x'],G.nodes[n]['y']) for n in G.nodes}
ax = plt.gca()
nx.draw_networkx_edges(G, pos, ax=ax, node_size=10, edge_color = c_mapped)
ax.autoscale()
plt.show()



```
"""


import networkx as nx

def get_column_type(header:str):
    """
    Determines column type from its header (from external knowledge)
    """
    if header in ['switched']:
        return bool
    elif header in ['EndNodes_1', 'EndNodes_2', 'Ref', 'Connectivity']:
        return int
    else:
        return float

def read_edge_file(filename:str):
    """
    Reads an edge file in our format (*_edges.csv or *_dual_edges.csv) into a graph
    """
    with open(filename, "r") as edge_file:
        endnodes_1_label, endnodes_2_label, *headers = edge_file.readline().rstrip().split(',')
        assert(endnodes_1_label == 'EndNodes_1')
        assert(endnodes_2_label == 'EndNodes_2')
        headers_with_types = list((header, get_column_type(header)) for header in headers)
        G = nx.parse_edgelist(edge_file, delimiter=',', create_using=nx.Graph(),
                              nodetype=int, data=headers_with_types)
    return G

def read_node_attributes(G:nx.Graph, filename:str):
    """
    Populates node attributes for graph G from filename (*_nodes.csv)
    """
    with open(filename, 'r') as node_file:
        id_label, *headers = node_file.readline().rstrip().split(',')
        assert(id_label == 'id')
        header_types = list(map(get_column_type, headers))
        for line in node_file:
            id, *attributes = line.rstrip().split(',')
            id = int(id)
            for header, header_type, attribute in zip(headers, header_types, attributes):
                G.nodes[id][header] = header_type(attribute)

def read_dual_node_attributes(H:nx.Graph, filename:str):
    """
    Populates node attributes for the dual graph H from filename (*_edges.csv)
    Note that this has a slightly different format from the other file as it does not include ids.

    This also returns a "dual map" that tells which node of G corresponds to a node index in H
    """
    with open(filename, 'r') as edge_file:
        headers = edge_file.readline().rstrip().split(',')
        assert(headers[0] == 'EndNodes_1')
        assert(headers[1] == 'EndNodes_2')
        header_types = list(map(get_column_type, headers))
        dual_map = dict()
        id = 1
        for line in edge_file:
            attributes = list(line.rstrip().split(','))
            # for speed reasons, we do not check that this matches 
            for header, header_type, attribute in zip(headers, header_types, attributes):
                H.nodes[id][header] = header_type(attribute)
            dual_map[(int(attributes[0]), int(attributes[1]))] = id
            id = id + 1

        return dual_map

def read_primal_graph(basename:str):
    """
    Builds networkx primal graph G from basename_nodes.csv and basename_edges.csv
    """
    G = read_edge_file(f'{basename}_edges.csv')
    read_node_attributes(G, f'{basename}_nodes.csv')
    return G

def read_dual_graph(basename:str):
    """
    Builds networkx dual graph G from basename_edges.csv and basename_dual_edges.csv
    """
    H = read_edge_file(f'{basename}_dual_edges.csv')
    dual_map = read_dual_node_attributes(H, f'{basename}_edges.csv')
    return H, dual_map

