function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
n = size(X,2); % number of features
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCostMulti) and gradient here.
    %
    
    summa = zeros(n,1);
    newTheta = zeros(n,1);
    h = zeros(m,1);
    tt = theta';

    for j = 1:m
        h(j) = tt * X(j,:)';
        for i = 1:n
            summa(i) = summa(i) + ( h(j) - y(j) ) * X(j,i);
        end
    end
      
    for i = 1:n
        newTheta(i) = theta(i) - alpha/m * summa(i);
    end
        
    theta = newTheta;

    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCostMulti(X, y, theta);

end

end
