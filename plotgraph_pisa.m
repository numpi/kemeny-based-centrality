function plotgraph_pisa(G, v, titl, filename)
plot(G, 'EdgeCData', v, 'XData', G.Nodes.x, 'YData', G.Nodes.y, 'LineWidth', rescale(v, 1, 5))
colormap('default');
cm = colormap;
colormap(cm(end:-1:1, :));
colorbar
axis tight
axis equal
xticks([]);
yticks([]);
fig = gcf;
fig.Position(3:4) = fig.Position(3:4) * 3;
title(titl, 'FontSize', 18);
exportgraphics(gcf, filename, 'ContentType','vector')

% ax = gca;
% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3) - ti(1) - ti(3);
% ax_height = outerpos(4) - ti(2) - ti(4);
% ax.Position = [left bottom ax_width ax_height];
