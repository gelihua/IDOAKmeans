%% *一、未优化前直接运行Kmeans*
%% 导入数据

clc;clear;% 清空
% load fisheriris% 加载Fisher鸢尾花数据集,数据包含三种鸢尾花的萼片、花瓣的长度和宽度测量值。
A=xlsread('数据模板');
kmax=5;% 聚类数寻优最大值
eva=KM(A,kmax);%运行未优化的Kmeans
%% 汇总结果、聚类评价指标

clusterIndices = eva.OptimalY;% 聚类标签
% 计算其他评价标准
eva_CHI=max(eva.CriterionValues);%CHI指数
eva2 = evalclusters(A,clusterIndices,"DaviesBouldin");%Davies-Bouldin准则
eva_DBI=eva2.CriterionValues;% DBI指数
eva3 = evalclusters(A,clusterIndices,"silhouette");%轮廓准则
eva_SC=eva3.CriterionValues;% 轮廓系数
clear eva2 eva3
%% *二、利用GA优化*
% *注意：优化外部套一个for循环，寻找最优K值，并输出对应结果*

for K=2:kmax
    %初始化变量
    [~,n]=size(A);%计算变量数
    N=n*K;%计算自变量数
    lb= reshape(repmat(min(A),K,1),[1,N]);      % 下边界
    ub= reshape(repmat(max(A),K,1),[1,N]);      % 上边界


% 求解
[solution,objectiveValue] = IDOA(objfun,N,[],[],[],[],lb,ub,[],[],options);


i=K-1;
M=reshape(solution,[K,n]);% 计算质心
fh = @(X,K)(kmeans(X,K,"Start",M));
eva = evalclusters(A,fh,"CalinskiHarabasz","KList",K);
GAKM.M{i}=M;
GAKM.eva{i}=eva;
CriterionValues(i)=eva.CriterionValues;
end
%% *三、寻优结果返回*

[~,I]=max(CriterionValues);% 最大值的索引
eva2=GAKM.eva{I};% Kmeans运算结果
M=GAKM.M{I};% 聚类初始点
%% *四、聚类结果可视化*
%%  显示二维散点图(PCA)

clusterIndices2 = eva2.OptimalY;
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
%% 散点图矩阵

figure
[~,P]=size(A);
selectedCols = sort([1:P]);
[~,ax] = gplotmatrix(A(:,selectedCols),[],clusterIndices2,colormap("lines"),[],[],[],"grpbars");
title("Comparison of Columns in Clustered Data");
clear K2
clusterMeans = grpstats(A,clusterIndices2,"mean");
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
%% *平行坐标图*
% 散点图矩阵仅显示二元关系。但是，也可以通过其他替代方法将所有变量显示在一起，便于您研究变量之间的高维关系。最简单的多元图就是平行坐标图。

figure
parallelcoords(A,'Group',clusterIndices2, 'standardize','on');
%% 
% 在此图中，水平方向表示坐标轴，垂直方向表示数据。每个观测项由五个变量的测量值组成，每个测量值由对应的线条在每个坐标轴上的高度表示。
% 
% 即使用不同颜色对组进行了区分，在查看包含大量观测值的平行坐标图时，依然不够清晰直观。我们还可以绘制只显示每个组的中位数和四分位数（25% 个点和 75% 
% 个点）的平行坐标图。这样可使组之间的典型差异和相似性更容易区分。

figure
parallelcoords(A,'Group',clusterIndices2, 'standardize','on','quantile',.25);
%% *Andrews 图*
% 另一种类似的多元可视化是 Andrews 图。Andrews图又称为调和曲线，其借鉴了傅里叶变换的思想，利用三角变换将多维数据点映射至二位空间的曲线，常用来进行聚类结果的判断，若各组别数据点距离较远，则易在极值处展现分散特点。

figure
andrewsplot(A,'Group',clusterIndices2, 'standardize','on');
%% 
% 可同样绘制只显示每个组的中位数和四分位数（25% 个点和 75% 个点）的Andrews 图。

figure
andrewsplot(A,'Group',clusterIndices2, 'standardize','on','quantile',.25);
%% *优化前后聚类效果指标输出*

disp(['-----------------------','优化前评价指标','--------------------------'])
disp(['优化前聚类CHI指数：',num2str(eva_CHI)])
disp(['优化前聚类DBI指数：',num2str(eva_DBI)])
disp(['优化前聚类轮廓系数：',num2str(eva_SC)])

eva_CHI2=max(eva2.CriterionValues);%CHI指数
eva3 = evalclusters(A,clusterIndices2,"DaviesBouldin");%Davies-Bouldin准则
eva_DBI2=eva3.CriterionValues;% DBI指数
eva4 = evalclusters(A,clusterIndices2,"silhouette");%轮廓准则
eva_SC2=eva4.CriterionValues;% 轮廓系数
clear eva3 eva4
disp(['-----------------------','优化后评价指标','--------------------------'])
disp(['优化后聚类CHI指数：',num2str(eva_CHI2)])
disp(['优化后聚类DBI指数：',num2str(eva_DBI2)])
disp(['优化后聚类轮廓系数：',num2str(eva_SC2)])
%% 
% 
% 
% 
% 
% 
% 
%