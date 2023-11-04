clc;clear;% 清空
% load fisheriris% 加载Fisher鸢尾花数据集,数据包含三种鸢尾花的萼片、花瓣的长度和宽度测量值。
A=xlsread('数据模板');


% 使用指定的簇个数执行 K 均值聚类(K 值)
K =2;
[clusterIndices2,centroids2] = kmeans(A,K);

% 显示结果

% 显示二维散点图(PCA)
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
title("First 2 PCA Components of Clustered Data");
xlabel("First principal component");
ylabel("Second principal component");

