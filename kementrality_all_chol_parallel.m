function [result, ijc] = kementrality_all_chol_parallel(G, reg, weights, parallel)
% function [result, ijc] = kementrality_all_chol_parallel(G, reg, weights, parallel);
% compute the Kemeny-based centrality of all the edges of a network
% relying on the Cholesky factorization.
% This version is better suited for large networks where the number n of nodes
% is so large that n^2 entries cannot be stored in the RAM.
%  Input:
%        G: Matlab graph, or adjacency matrix
%      reg: regularization parameter
%  weights: weight for each edge (default=all ones)
% parallel: whether to parallelize (default=false);
% Output:
% result: vector of the same length as G.Edges, containing each score
% ijc: the same result in the [i,j,c] format (computed only if nargout>1)

if not(exist('parallel', 'var')) || isempty(parallel)
    parallel = false;
end

if isnumeric(G)
    % adjacency matrix as first input
    A = G;
    if exist('weights', 'var') && not(isempty(weights))
        error('Specifying weights is not supported with an adjacency matrix as first argument, only with a graph')
    end
    [iA, jA, wA] = find(A);
    if any(iA==jA)
        error('the given adjacency matrix has self-loops; this is not supported for now');
    end
    ij = [iA(iA<jA) jA(iA<jA)]';
    weights = wA(iA<jA);
    clear iA jA wA;
    n = size(A, 1);
    m = size(ij, 2);
else
    % graph as first input (optionally with weights)
    n = numnodes(G);
    m = numedges(G);
    if not(exist('weights', 'var')) || isempty(weights)
        A = adjacency(G);
        weights = ones(m, 1);
    else
        A = adjacency(G, weights);
    end
    ij = G.Edges.EndNodes';
    clear G;
end
result = nan(m, 1);

d = sum(A, 2);
sd = sum(d);
T = spdiags(d*(1+reg), 0, n, n) - A;
clear A;
fprintf('Started Cholesky factorization...\n')
tic;
p = amd(T); % determined to work better with some experiments
R = chol(T(p,p));
timechol = toc;
clear T;
fprintf('Done! Cpu time %f s.\n',timechol);
td = R' \ d(p,:);  
td(p,:) = R \ td; 
dtd = sum(d .* td);
sdtd = dtd + sd;

if parallel
    maxWorkers = inf;
else
    maxWorkers = 0;
end
fprintf('Started centrality computation...\n')
tic
parfor (k = 1:m, maxWorkers)
%for k = 1:m  % one may want to switch to a non-parallel for for profiling
    if mod(k, 1000) == 0
        fprintf('Run iteration %d / %d...\n', k, m);
    end
    ij_slice = ij(:,k);
    i = ij_slice(1);
    j = ij_slice(2);
    Aij = weights(k);
    v = sparse([i j], 1, [1 -1], n, 1);
    w = R' \ v(p,:);
    w(p,:) = R \ w;
    dw = sum(d .* w);
    x = w - (dw/sdtd) * td;
    alpha = Aij * (x(i)-x(j));
    beta = Aij * sum(x .* x .* d);
    ce = beta / (1-alpha);
%    if ce > 0.5/reg
%        ce = abs(ce - 1/reg);
%    end
    result(k) = ce;
end
timeparallel = toc;
fprintf('Done! Cpu time %f s.\n', timeparallel)
if nargout > 1
    ijc = [ij' result];
end