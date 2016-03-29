% Predict missing entries in matrix X based on known entries. Missing
% values in X are denoted by the special constant value nil. The used
% method is a Stochastic Gradient Descent Singular Value Decomposition
% with an improved user and item bias calculation step.
function X_pred = PredictMissingValues(X, nil)
tic;
% the number of SGD iterations
max_iter = 30;

% learning rate for the user and item bias updates
%alpha_1=0.002;
% regularization parameter for the user and item bias updates
%lambda_1 = 0.002;

% learning rate for P,Q latent factor matrices
alpha_2=0.025;
% regularization parameter for P,Q latent factor matrices
lambda_2 = 0.1;
% number of latent features
latent_features = 5;

users = size(X, 1);
movies = size(X, 2);

% initialize the latent matrices P and Q with random values
P = rand(users, latent_features);
Q = rand(movies, latent_features);
% transpose Q for easier calculation procedures in the rest of the algorithm  
Q = Q.';

% get the biases vectors for items and users
[user_biases,movie_biases] = improved_biases(X,nil);

for f=1:max_iter
%   iterate over each known rating  
    for i=1:users
        for j=1:movies
            if X(i,j) ~= nil
        %       construct improved baseline from the user and movie biases  
                baseline =  user_biases(i) + movie_biases(j);

        %       make a prediction by adding the inner product of P and Q latent feature vectors to the baseline  
                prediction =  baseline + P(i,:)*Q(:,j);
        %       adjust prediction according to the rating scale  
                if prediction > 5
                  prediction = 5;
                elseif prediction < 1
                  prediction = 1;
                end
        %       calculate prediction error  
                error = X(i,j) - prediction;
				
        %       adjust biases according to the prediction error. We use regularization to prevent overfitting  
        %       user_biases(i) = user_biases(i) + alpha_1*(error - lambda_1 * user_biases(i));
        %       movie_biases(j) = movie_biases(j) + alpha_1*(error - lambda_1 * movie_biases(j));
		 
        %       adjust P and Q according to the prediction error. We use regularization to prevent overfitting
                for k=1:latent_features
                    P(i,k) = P(i,k) + alpha_2*(error*Q(k,j)-lambda_2*P(i,k));
                    Q(k,j) = Q(k,j) + alpha_2*(error*P(i,k)-lambda_2*Q(k,j));
                end
            end
         end
    end
end
% inner product of P and Q. NOTE we transposed Q initially!
X_pred = P*Q;
% add back user and movie biases to our prediction
for i=1:users
     for j=1:movies
               X_pred(i,j) = X_pred(i,j) + user_biases(i) + movie_biases(j);            
     end
end
toc;
end