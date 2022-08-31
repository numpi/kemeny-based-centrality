function plotgraph(G,titl,filename)

% function to plot a weighted, with minor tweaks for our figure 5.1.

v = G.Edges.Weight; 
LWidths = rescale(v,0.5,3);
plot(G,'EdgeCData',v,'LineWidth',LWidths,'NodeLabel',{},'MarkerSize',5);
colormap('default');
cm = colormap;
colormap(cm(end:-1:1, :));
colorbar
axis tight
%axis equal
xticks([]);
yticks([]);
fig = gcf;
fig.Position(3:4) = fig.Position(3:4) * 1;
title(titl,'FontSize',14);
exportgraphics(gcf, filename, 'ContentType','vector')
