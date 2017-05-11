%% GE 413 Project
% S. Cai, T. Murray
% Plot final results and fit to a square root function

%% Results
results = [100, 58.891, nan;
130, 65.685, nan;
150, 68.86, 72.416;
160, nan, 73.872;
180, 74.683, nan;
200, 79.224, 80.693;
213, nan, 80.402;
225, nan, 84.95;
250, 84.756, 87.522;
263, nan, 86.648;
275, nan, 88.603;
300, nan, 91.73;
325, nan, 90.232;
350, nan, 93.081;
375, nan, 94.766];

results2 = [
150, 72.416;
160, 73.872;
200, 80.693;
213, 80.402;
225, 84.95;
250, 87.522;
263, 86.648;
275, 88.603;
300, 91.73;
325, 90.232;
350, 93.081;
375, 94.766];

%% Fitting
sqrtFunc = polyfit(sqrt(results2(:,1)), results2(:,2), 1);
% 3.1101    35.9934
% so 3.1101*sqrt(k) + 35.9934 = % coverage

%% Plots
figure(1)
scatter(results(:,1), results(:,2), 'g', 'filled')
hold on
scatter(results(:,1), results(:,3), 'b', 'filled')
fplot(@(x) sqrtFunc(1)*sqrt(x) + sqrtFunc(2), 'k')
xlabel('Number of Routers')
ylabel('Percent Coverage')
legend('Algo 1', 'Algo 2', ...
    'Location', 'southeast')

