% Data: Number of Modules completed by each group
module_nums = [1, 2, 3, 4]; % X-axis values

% Participant counts for each group
control_counts = [0, 0, 0, 4]; % Control (C) - Dark Green
stroke_np_counts = [1, 4, 4, 0]; % Stroke NP (NP) - Brighter Orange
stroke_p_counts = [1, 4, 3, 1]; % Stroke P (P) - Brighter Red

% Create a stacked bar chart
figure;
b = bar(module_nums, [control_counts; stroke_np_counts; stroke_p_counts]', 'stacked');

% Set adjusted colors manually
b(1).FaceColor = [0 0.6 0];   % Dark Green (Control)
b(2).FaceColor = [1 0.5 0.2]; % Brighter Orange (Stroke NP)
b(3).FaceColor = [0.8 0.1 0]; % Brighter Red (Stroke P)

% Labels and title
xlabel('Number of Modules','FontSize',25);
ylabel('Number of Participants','FontSize',25);
title('Stacked Histogram of Number of Participants Across Number of Modules','FontSize',35);

% Add legend
legend({'Controls', 'Stroke (NP)', 'Stroke(P)'}, 'Location', 'NorthWest');

% Improve visualization
grid on;
xticks(module_nums);
set(gca, 'FontSize', 30); % Set font size for axis numbers
