function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

a1 = zeros(1, input_layer_size+1);
a2 = zeros(1, hidden_layer_size+1);
a3 = zeros(1, num_labels);
delta2 = zeros(size(a2));
delta3 = zeros(size(a3));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m


%======loop implementation========%
%{
%recode y single digit output to binary vector output
Y = zeros(num_labels, m);
for i = 1:m
    Y(y(i),i) = 1;
end

sum_term = 0;
for i = 1:m
    for k = 1:num_labels
       
        a1 = X(i,:); %inputs=outputs=X in input layer
        a1 = [1 a1]; %adding a bias neuron
        
        z2 = a1*Theta1'; %input of hidden layer neurons
        a2 = sigmoid(z2); %output of hidden layer neurons - apply the activation function - sigmoid
        a2 = [1 a2]; %adding a bias neuron
    
        z3 = a2*Theta2';  %input of output layer neurons
        a3 = sigmoid(z3); %output of hidden layer neurons - apply the activation function
        
        sum_term = sum_term + (-Y(k,i)*log(a3(k)) - (1-Y(k,i))*log(1-a3(k)) ) ;
    end
end

J = sum_term/m;

%}

%=======vectorized implementation=======%

%recode y single digit output to binary vector output
Y = zeros(m,num_labels);
for i = 1:m
    Y(i, y(i)) = 1;
end

a1 = [ones(m,1) X]; %5000x401

z2 = a1*Theta1';  %5000x25
a2 = sigmoid(z2); %5000x25
a2 = [ones(m,1) a2];%5000x26

z3 = a2*Theta2';%5000x10
a3 = sigmoid(z3);%5000x10

regTermJ = ( sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)) ) * lambda / (2*m);

J = sum(sum( -Y.*log(a3) - (1 - Y).*log(1 - a3) ))/m + regTermJ;


%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

%======loop implementation========%
%========ThetaGrads are calculated incorrectly at the moment!!=======%

%recode y single digit output to binary vector output
%{
Y = zeros(num_labels, m);
for i = 1:m
    Y(y(i),i) = 1; %10x5000
end


Delta2_sum = zeros(size(Theta2));
Delta1_sum = zeros(size(Theta1));
for i = 1:m
       
        a1 = X(i,:); %inputs=outputs=X in input layer %1x400
        a1 = [1 a1]; %adding a bias neuron %1x401
        
        z2 = a1*Theta1'; %input of hidden layer neurons %1x25
        a2 = sigmoid(z2); %output of hidden layer neurons - apply the activation function - sigmoid
        a2 = [1 a2]; %adding a bias neuron %1x26
        
        z3 = a2*Theta2';  %input of output layer neurons
        a3 = sigmoid(z3); %output of hidden layer neurons - apply the activation function %1x10
   
        delta3 = a3-Y(:,m)'; %1x10 
        
        delta2 = (delta3*Theta2(:,2:end)) .* sigmoidGradient(z2); %1x25

        Delta2_sum = Delta2_sum + delta3' * a2;
        Delta1_sum = Delta1_sum + delta2' * a1;
end

Theta1_grad = Delta1_sum/m;
Theta2_grad = Delta2_sum/m;

%}
%=======vectorized implementation=======%

delta3 = a3-Y; %5000x10 

delta2 = (delta3 * Theta2(:,2:end)) .* sigmoidGradient(z2); %5000x25

Delta2 = delta3' * a2; %10x25
Delta1 = delta2' * a1; %25x400

Theta1_grad = Delta1/m;
Theta2_grad = Delta2/m;

%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

grad_reg1 = (lambda/m) * Theta1(:,2:end); %25x400
grad_reg2 = (lambda/m) * Theta2(:,2:end); %10x25

grad_reg1 = [zeros(size(grad_reg1,1),1) grad_reg1]; %25x401
grad_reg2 = [zeros(size(grad_reg2,1),1) grad_reg2];    %10x26


Theta1_grad = Theta1_grad + grad_reg1;
Theta2_grad = Theta2_grad + grad_reg2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
