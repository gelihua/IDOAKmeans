# IDOA-K-means
Leveraging the powerful global optimization capability of IDOA, the task is to optimize the K-means algorithm and achieve unsupervised learning clustering.
## Operating environment
Code written in MATLAB 2022a can be executed on both Windows and macOS systems.
## Code execution and parameter settings
### File description
-  "main.m" is the main file.
- "test.xls" is the test data file.    
- "data.xls" is the original data file, which contains detailed instructions.    - 
- "IDOA.m" is the improved IDOA algorithm file.    
- "ClusteringCost.m" is the objective function used for optimization.    
- The remaining files are auxiliary functions for running the IDOA algorithm.
### Parameter settings
Please provide the three parameters that need to be set before running the code in the main.m file.
- K=3;                 % Number of clusters
- Max_iter=100;        % iterations
- SearchAgents_no=50;  % population
