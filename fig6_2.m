% Script for drawing figure 6.2 concerning a disconnected graph
% The functions kementrality_all and plotgraphs are needed

% Creating the first barbell
m = 8;
n = 15;
reg = 1.e-8;

h = zeros(m+n);
for i=1:m-1; h(i,i+1) = 1;  h(i+1,i) = 1;  end; 
h(1,m) = 1;  h(m,1) = 1;
for i=m+1:m+n-1; h(i,i+1) = 1;  h(i+1,i) = 1; end; 
h(m+1,m+n) = 1;  h(m+n,m+1) = 1;
h(1,m+1) = 1;h(m+1,1) = 1;
h(2,10) = 1; h(10,2) = 1;
h1 = h;


% Creating the second barbell
m = 8;
n = 15;
h = zeros(m+n);
for i=1:m-1
  for j=i+1:m
    h(i,j) = 1;  h(j,i) = 1;
  end
end
for i=m+1:m+n-1 
  for j=i+1:m+n
    h(i,j) = 1;  h(j,i) = 1;
  end;
end
h(1,m+1) = 1;  h(m+1,1) = 1;
h(2,10) = 1; h(10,2) = 1;
h2=h;

h=[h1,zeros(m+n);zeros(m+n),h2];
[~, ijc] = kementrality_all_chol_parallel(h,reg);
%for i=1:size(ijc,1);
%    fprintf('%d, %d, %d\n',ijc(i,1),ijc(i,2),ijc(i,3));
%end
F = graph(ijc(:,1),ijc(:,2),ijc(:,3)); 
coloraxis = [min(ijc(:,3)), max(ijc(:,3))];
figure;
plotgraph_for_disconnected(F,'Disconnected graph (r=1e-8)','disconnected_graph.pdf', coloraxis);

[~, ijc] = kementrality_all_chol_parallel(h1,reg);
F = graph(ijc(:,1),ijc(:,2),ijc(:,3)); 
figure;
plotgraph_for_connected(F,'Component 1 (r=1e-8)','disconnected_graph_component1.pdf', coloraxis);

[~, ijc] = kementrality_all_chol_parallel(h2,reg);
F = graph(ijc(:,1),ijc(:,2),ijc(:,3)); 
figure;
plotgraph_for_connected(F,'Component 2 (r=1e-8)','disconnected_graph_component2.pdf', coloraxis);
