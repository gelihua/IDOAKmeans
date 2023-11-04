function o = ClusteringCost(x,A,K,n)
m=reshape(x,[K,n]);    % Reorganize x into the number of K rows and n columns (number of variables)
d = pdist2(A, m);      % Euclidean distance
[dmin, ~] = min(d, [], 2);
o = sum(dmin);
end