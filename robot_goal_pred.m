% Read data from CSV file
data = readtable('robot.csv');

% Features
X = [data.Time.^2, data.Time, ones(size(data.Time))];

% Target variable (regression)
y_regression = data.Position_X;

% Target variable (classification)
% Example: classify points based on GoalAchieved
y_classification = (data.GoalAchieved == 1) - (data.GoalAchieved == -1);

% Using CVX for quadratic regression with classification and epsilon tube
cvx_begin
    variables a b c e(length(y_regression)) t xi(length(y_classification));

    minimize(norm(e) + sum(t) + sum(xi))
    subject to
        X*[a;b;c] + e == y_regression;
        -t <= y_classification - (X*[a;b;c] + e) <= t;
        -xi <= y_classification - (X*[a;b;c] + e) <= xi;
        t >= 0;
        xi >= 0;
cvx_end

% Extracting the optimized parameters
a_optimized = a;
b_optimized = b;
c_optimized = c;

% Extracting the values of t and xi
t_values = t;
xi_values = xi;

%% Calculate Accuracy

% Regression Accuracy
predicted_position = a_optimized * data.Time.^2 + b_optimized * data.Time + c_optimized;
residuals = data.Position_X - predicted_position;
mae = mean(abs(residuals));

% Classification Accuracy
predicted_labels = sign(a_optimized * data.Time.^2 + b_optimized * data.Time + c_optimized);
correct_classification = predicted_labels == y_classification;
classification_accuracy = sum(correct_classification) / length(correct_classification);

% Epsilon Tube Accuracy
epsilon_threshold = 2; % Adjust epsilon threshold as needed
in_epsilon_tube = abs(data.Position_X - predicted_position) <= epsilon_threshold;
epsilon_tube_accuracy = sum(in_epsilon_tube) / length(in_epsilon_tube);

%% Display Results

disp(['Regression Mean Absolute Error (MAE): ', num2str(mae)]);
disp(['Classification Accuracy: ', num2str(classification_accuracy * 100), '%']);

%% Plotting the Regression Curve with Goal Prediction and Epsilon Tube

figure;
scatter(data.Time, data.Position_X, 'o', 'DisplayName', 'Data');
xlabel('Time');
ylabel('Position_X');
title('Quadratic Regression with Epsilon Tube for Robot Motion');
legend();
hold on;

% Plotting the original data and regression curve with epsilon tube
figure;
scatter(data.Time, data.Position_X, 'o', 'DisplayName', 'Data');
hold on;

% Plotting the regression curve
x_curve = linspace(min(data.Time), max(data.Time), 100)';
y_curve = a_optimized * x_curve.^2 + b_optimized * x_curve + c_optimized;
plot(x_curve, y_curve, 'r-', 'LineWidth', 2, 'DisplayName', 'Regression Curve');

% Plotting epsilon tube
upper_tube = y_curve + epsilon_threshold;
lower_tube = y_curve - epsilon_threshold;
fill([x_curve; flipud(x_curve)], [upper_tube; flipud(lower_tube)], 'g', 'FaceAlpha', 0.3, 'DisplayName', 'Epsilon Tube');

% Highlight points inside epsilon tube
scatter(data.Time(in_epsilon_tube), data.Position_X(in_epsilon_tube), 30, 'g', 'filled', 'DisplayName', 'Points Inside Epsilon Tube');

% Highlight points outside epsilon tube with label -1
outside_epsilon_tube = ~in_epsilon_tube;
scatter(data.Time(outside_epsilon_tube), data.Position_X(outside_epsilon_tube), 30, 'r', 'filled', 'DisplayName', 'Points Outside Epsilon Tube (Label -1)');

xlabel('Time');
ylabel('Position_X');
title('Quadratic Regression with Epsilon Tube for Robot Motion');
legend();
hold off;
