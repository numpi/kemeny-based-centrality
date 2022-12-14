function plotgraph(G,titl,filename)

% function to plot a weighted graph and save it to a file

v = G.Edges.Weight; 
LWidths = rescale(v,1,5);
plot(G,'EdgeCData',v,'LineWidth',LWidths,'NodeLabel',{},'MarkerSize',5);
colormap('default');
cm = colormap;
colormap(cm(end:-1:1, :));
colorbar
axis tight
axis equal
xticks([]);
yticks([]);
fig = gcf;
fig.Position(3:4) = fig.Position(3:4) * 2;
title(titl,'FontSize',14);
exportgraphics(gcf, filename, 'ContentType','vector')
