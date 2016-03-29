% Predict missing entries in matrix X based on known entries. Missing
% values in X are denoted by the special constant value nil. The used
% method is a Stochastic Gradient Descent Singular Value Decomposition
% with an improved user and item bias calculation step as well as taking into
% consideration implicit feedback.
function X_pred = PredictMissingValuesImplicit(X, nil)
tic;
% the number of SGD iterations
max_iter = 30;
% learning rate for the user and item bias updates
alpha_1=0.002;
% regularization parameter for the user and item bias updates
lambda_1 = 0.002;

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
% implicit factor weights
Y = rand(movies, latent_features);
% transpose Q for easier calculation procedures in the rest of the algorithm  
Q = Q.';

% get the biases vectors for items and users
[user_biases,movie_biases] = improved_biases(X,nil);

for f=1:max_iter
%   iterate over each known rating  
    for i=1:users
        % calculate implicit data normalization
        implicit_count = nnz(X(i,:));
        if implicit_count > 1
        % reg term  for implicit data
          sqrt_implicit_count = (1.0/sqrt(implicit_count));
        else
          sqrt_implicit_count = 0;
        end
        
        for j=1:movies
            if X(i,j) ~= nil
                % sum implicit factors weights for item j
                sum_y=0;
                for u=1:latent_features
                    sum_y = sum_y + Y(j,u);
                end   
%               construct improved baseline from the user and movie biases  
                baseline =  user_biases(i) + movie_biases(j);
%               if a user has not made any ratings then we predict the baseline                
                if implicit_count >= 1
%                   calculate implicit factor by normalizing the sum of the implicit weights  
                    implicit_factor = sqrt_implicit_count*sum_y;
%                   make a prediction by adding the inner product of P and
%                   Q latent feature vectors to the baseline,
%                   taking into consideration the implicit factor for a
%                   given user i
                    prediction =   baseline + (P(i,:) + implicit_factor) * Q(:,j);
                else
                    prediction = baseline;
                end

        %       adjust prediction according to the rating scale  
                if prediction > 5
                  prediction = 5;
                elseif prediction < 1
                  prediction = 1;
                end
        %       calculate prediction error  
                error = X(i,j) - prediction;
				
        %       adjust biases according to the prediction error. We use regularization to prevent overfitting  
                user_biases(i) = user_biases(i) + alpha_1*(error - lambda_1 * user_biases(i));
                movie_biases(j) = movie_biases(j) + alpha_1*(error - lambda_1 * movie_biases(j));
		 
        %       adjust P and Q and Y according to the prediction error. We use regularization to prevent overfitting
                for k=1:latent_features
                    Q(k,j) = Q(k,j) + alpha_2*(error*(P(i,k) + implicit_factor) -lambda_2*Q(k,j));
                    P(i,k) = P(i,k) + alpha_2*(error*Q(k,j)-lambda_2*P(i,k));
                    Y(j,k) = Y(j,k) + alpha_2*(error * sqrt_implicit_count * Q(k,j) -lambda_2*Y(j,k));
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