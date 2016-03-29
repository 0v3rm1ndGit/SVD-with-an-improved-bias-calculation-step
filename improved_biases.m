function [user_offsets, movie_avgs] = improved_biases(X, nil)

users = size(X,1);
movies = size(X, 2);
% initialize movie average and user offset vectors
movie_avgs =zeros(movies,1);
user_offsets = zeros(users,1);
% blending ration constant is used instead of variance ratio - recommended by Simon Funk
K = 20;
% how many users rated a particular movie
m_observed_ratings = zeros(movies,1) ;
% how many movies a user rated
u_observed_ratings = zeros(users,1);

% calculate movie averages and number of observed movie ratings
for i= 1:movies
    col = X(:, i);
    movie_avgs(i) = mean(col(col~=nil));
%   how many users rated a movie i
    m_observed_ratings(i) = size(col(col~=nil),1);
end

% mean of all of the movie averages 
global_mean = mean(movie_avgs);
%calculate improved movie means, taking into consideration the blending
%ratio K
for i = 1:size(movie_avgs)
    movie_avgs(i) = (K*global_mean + movie_avgs(i) * m_observed_ratings(i))/ (K + m_observed_ratings(i));
end

%calculate user offsets and number of observed user ratings
for i= 1:users
    user_offset = 0;
    for j = 1:movies
          if X(i,j)~= nil
              user_offset = user_offset + X(i, j) - movie_avgs(j);
          end    
    end
    
    row = X(i,:);
    u_observed_ratings(i) = nnz(row);
    user_offsets(i) = user_offset/u_observed_ratings(i);
end

%  users with no ratings have 0 user bias
offset_average = mean(user_offsets(~isnan(user_offsets)));
% replace user offset with 0 when we have 0 movie ratings made by a
% particular user
user_offsets(isnan(user_offsets))= 0;
%calculate improved user offset, taking into consideration the blending
%ratio K
for i = 1:size(user_offsets)
    user_offsets(i) = (K*offset_average + user_offsets(i) * u_observed_ratings(i))/ (K +  u_observed_ratings(i));
end
