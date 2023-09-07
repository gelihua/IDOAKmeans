
clc;clear;
A=xlsread('data');
kmax=5;
eva=KM(A,kmax);
%% 

clusterIndices = eva.OptimalY;

eva_CHI=max(eva.CriterionValues);
eva2 = evalclusters(A,clusterIndices,"DaviesBouldin");
eva_DBI=eva2.CriterionValues;
eva3 = evalclusters(A,clusterIndices,"silhouette");
eva_SC=eva3.CriterionValues;
clear eva2 eva3
%% 

for K=2:kmax
    [~,n]=size(A);
    N=n*K;
    lb= reshape(repmat(min(A),K,1),[1,N]);      
    ub= reshape(repmat(max(A),K,1),[1,N]);      



[solution,objectiveValue] = IDOA(objfun,N,[],[],[],[],lb,ub,[],[],options);


i=K-1;
M=reshape(solution,[K,n]);
fh = @(X,K)(kmeans(X,K,"Start",M));
eva = evalclusters(A,fh,"CalinskiHarabasz","KList",K);
GAKM.M{i}=M;
GAKM.eva{i}=eva;
CriterionValues(i)=eva.CriterionValues;
end
%% 

[~,I]=max(CriterionValues);
eva2=GAKM.eva{I};
M=GAKM.M{I};
%% 
%%  (PCA)

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
%% 

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

%