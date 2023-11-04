function [eva] = KM(A,kmax)
[~,P]=size(A);
% 使用指定范围选择最佳簇个数(K 值)
fh = @(X,K)(kmeans(X,K,"Start","sample"));
eva = evalclusters(A,fh,"CalinskiHarabasz","KList",2:kmax);
K = eva.OptimalK;%最佳K值
clusterIndices = eva.OptimalY;% 聚类标签
centroids = grpstats(A,clusterIndices,"mean");% 计算质心


% 显示簇计算标准值
figure(1)
bar(eva.InspectedK,eva.CriterionValues);
xticks(eva.InspectedK);
xlabel("Number of clusters");
ylabel("Criterion values - Calinski-Harabasz");
legend("Optimal number of clusters is " + num2str(K))
title("Evaluation of Optimal Number of Clusters")
disp("Optimal number of clusters is " + num2str(K));

% 显示二维散点图(PCA)
figure(2)
[~,score] = pca(A);
clusterMeans = grpstats(score,clusterIndices,"mean");
h = gscatter(score(:,1),score(:,2),clusterIndices,colormap("lines"));
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
title("优化前二维散点图");
xlabel("First principal component");
ylabel("Second principal component");

% 散点图矩阵图
figure(3)
selectedCols = sort([1:P]);
[~,ax] = gplotmatrix(A(:,selectedCols),[],clusterIndices,colormap("lines"),[],[],[],"grpbars");
title("优化前散点图矩阵");
clear K2
clusterMeans = grpstats(A,clusterIndices,"mean");
hold(ax,"on");
for i = 1 : size(selectedCols,2)
    for j = 1 : size(selectedCols,2)
        if i ~= j
            scatter(ax(j,i),clusterMeans(:,selectedCols(i)),clusterMeans(:,selectedCols(j)), ...
                50,"kx","LineWidth",1.5,"DisplayName","ClusterMeans");
            xlabel(ax(size(selectedCols,2),i),("Column" + selectedCols(i)));
            ylabel(ax(i,1),("Column" + selectedCols(i)));
        end
    end
end
clear ax clusterMeans i j selectedCols

end