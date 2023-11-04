%IDOA-Kmeans Unsupervised Learning
%% Load data
clc;clear;
A=xlsread('test'); % Import Simulation Dataset
%% Set optimization initial parameters
K=3;                 % Number of clusters
Max_iter=100;        % iterations
SearchAgents_no=50;  % population
[~,n]=size(A);       % Calculate the number of variables
dim=n*K;             % Calculate the number of independent variables
lb= reshape(repmat(min(A),K,1),[1,dim]);      % lower boundary
ub= reshape(repmat(max(A),K,1),[1,dim]);      % Upper boundary
fobj = @(x)ClusteringCost(x,A,K,n);
[theBestVct,solution,~]=IDOA(SearchAgents_no,Max_iter,lb,ub,dim,fobj);
M=reshape(solution,[K,n]);                             % Calculate centroid
fh = @(X,K)(kmeans(X,K,"Start",M));                    % Rerun kmeans
eva = evalclusters(A,fh,"CalinskiHarabasz","KList",K); % Rerun kmeans
clusterIndices2=eva.OptimalY;                  
%% Draw a two-dimensional scatter plot
figure
[~,score] = pca(A);
clusterMeans = grpstats(score,clusterIndices2,"mean");
h = gscatter(score(:,1),score(:,2),clusterIndices2,colormap("lines"));
for i = 1:numel(h)
    h(i).DisplayName = strcat("Cluster",h(i).DisplayName);
end
clear h i score
hold on
h = scatter(clusterMeans(:,1),clusterMeans(:,2),50,"kx","LineWidth",2);
hold off
h.DisplayName = "ClusterMeans";
clear h clusterMeans
legend;
title("Optimized two-dimensional scatter plot");
xlabel("First principal component");
ylabel("Second principal component");


