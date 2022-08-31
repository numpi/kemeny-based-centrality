% Script for drawing figure 5.1 concerning graphs that contains some
% cut-edges

a=zeros(12,12);
a(1,2) = 1; a(1,3) = 1;  a(1,4) = 1;  a(2,3) = 1;  a(2,4) = 1;
a(4,7) = 1;
a(7,8) = 1;  a(6,7) = 1;  a(5,7) = 1;  a(8,9) = 1;  a(5,8) = 1;
a(6,8) = 1;  a(5,6) = 1;
a(6,10) = 1;  a(10,11) = 1;  a(10,12) = 1;
a = a+a';
G = graph(a);

[~, ijc] = kementrality_all_chol_parallel(a,1.e-8);
v = ijc(:,3);
F1 = graph(ijc(:,1),ijc(:,2),ijc(:,3));
fk = v; fk(v>0.5e8) = 1e8 - fk(v>0.5e8);
F2 = graph(ijc(:,1),ijc(:,2),fk);
figure;
plotgraph_51(F1,'Unfiltered','unfiltered.pdf');
figure;
plotgraph_51(F2,'Filtered','filtered.pdf');

a = zeros(6,6);
a(1,2) = 1; a(2,3) = 1; a(3,4) = 1; a(4,5) = 1; a(5,6) = 1;
a = a+a';
G = graph(a);
[~, ijc] = kementrality_all_chol_parallel(a,1.e-8);
v = ijc(:,3);
F1 = graph(ijc(:,1),ijc(:,2),ijc(:,3));
fk = v; fk(v>0.5e8) = 1e8 - fk(v>0.5e8);
F2 = graph(ijc(:,1),ijc(:,2),fk);
figure;
plotgraph_tridiag(F1,'Unfiltered','tridiag_graph.pdf');
figure;
plotgraph_tridiag(F2,'Filtered','tridiagfiltered_graph.pdf');
