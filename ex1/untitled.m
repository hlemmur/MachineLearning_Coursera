a = [1 2; 3 4; 5 6];
b = [10; 20; 30];

mu = zeros (1, size(a, 2));

%mu = mean(a)
for j = 1:2
    mu(1,j) = mean(a(:,j));
end

%sigma = std(a)

for j = 1:2
    sigma(1,j) = std(a(:,j));
end

sigma