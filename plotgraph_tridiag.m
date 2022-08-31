function plotgraph_tridiag(G,titl,filename)
v = G.Edges.Weight; 
LWidths = rescale(v,0.5,3);
plot(G,'EdgeCData',v,'LineWidth',LWidths,'NodeLabel',{},'MarkerSize',5, 'XData', 1:6, 'YData', zeros(1,6));
colormap('default');
cm = colormap;
colormap(cm(end:-1:1, :));
colorbar
axis tight
% axis equal
xticks([]);
yticks([]);
fig = gcf;
fig.Position(3:4) = fig.Position(3:4) * 1;
title(titl,'FontSize',14);
exportgraphics(gcf, filename, 'ContentType','vector')

