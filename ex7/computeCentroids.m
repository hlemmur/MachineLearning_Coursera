function centroids = computeCentroids(X, idx, K)
%COMPUTECENTROIDS returns the new centroids by computing the means of the 
%data points assigned to each centroid.
%   centroids = COMPUTECENTROIDS(X, idx, K) returns the new centroids by 
%   computing the means of the data points assigned to each centroid. It is
%   given a dataset X where each row is a single data point, a vector
%   idx of centroid assignments (i.e. each entry in range [1..K]) for each
%   example, and K, the number of centroids. You should return a matrix
%   centroids, where each row of centroids is the mean of the data points
%   assigned to it.
%

% Useful variables
[m n] = size(X);

% You need to return the following variables correctly.
centroids = zeros(K, n);


% ====================== YOUR CODE HERE ======================
% Instructions: Go over every centroid and compute mean of all points that
%               belong to it. Concretely, the row vector centroids(i, :)
%               should contain the mean of the data points assigned to
%               centroid i.
%
% Note: You can use a for-loop over the centroids to compute this.
%

%vectorized - shortest
for k = 1:K
    centroids(k,:) = mean(X(idx(:,1) == k,:));
end

%vectorized - detailed
%{
for k = 1:K
    indices_current_centroid = find(idx(:,1) == k);
    X_current_centroid = X(indices_current_centroid,:);
    centroids(k,:) = mean(X_current_centroid);
end
%}

%not vectorized
%{
for k = 1:K
    N = 0;
    sum = zeros(1,n);
    for i=1:m
        if idx(i) == k
            N = N +1;
            sum = sum + X(i,:);
        end
    end
    centroids(k,:) = sum./N;
end

%}



% =============================================================


end

