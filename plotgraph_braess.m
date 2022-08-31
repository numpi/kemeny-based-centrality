function plotgraph(G,titl,filename)

% function to plot a weighted, with minor tweaks for our Braess' paradox figure

plot(G,'NodeLabel',{},'MarkerSize',10, 'XData', G.Nodes.x, 'YData', G.Nodes.y, 'LineWidth', 3);
axis tight
axis equal
xticks([]);
yticks([]);
fig = gcf;
fig.Position(3:4) = fig.Position(3:4) * 3;
title(titl,'FontSize',24);
exportgraphics(gcf, filename, 'ContentType','vector')
