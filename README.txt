----SVD++ with an improved bias calculation step----

AUTHORS
-------
Martin Ivanov,ivanovma@@studnet.ethz.ch
Gregory Banfi,gbanfi@studnet.ethz.ch
Dhivyabharathi Ramasamy, ramasmd@student.ethz.ch

What is it?
-----------
SVD++ with an improved bias calculation step is a collaborative filtering method used to predict
user ratings. Collaborative filtering is often used in recommender systems to achieve high prediction 
accuracy. Our algorithm is an improved Singular Value Decomposition approach that takes into
consideration both implicit and explicit data and uses an alternative approach for calculating 
baseline prediction that takes into consideration the linear combination between the observed mean
and the apriori mean.

Documentation
-------------
The full mathematical models used for the implementation can be verified in our short
scientific paper "SVD++ with an improved bias calculation step".

How to run it?
--------------
Our solution consists of 4 matlab files:
CollabFilteringEvaluation.m 
PredictMissingValues.m
PredictMissingValuesImplicit.m
improved_biases.m

To run the algorithm you execute the CollabFilteringEvaluation.m which loads a user-item matrix
in the form of .dat file. CollabFilteringEvaluation.m then executes PredictMissingValues.m
which is a solution that does not use implicit data. If a call to PredictMissingValuesImplicit.m
is made instead, the solution will use implicit feedback as well. We would like to point out 
that PredictMissingValues.m gave the best results when it comes to RMSE accuracy and execution time.
improved_biases.m is a function used both approaches to calculate a baseline prediction.

 


				