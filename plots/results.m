%% Results.m
% This code produces the two plots. The x-axis shows the time
% took by the algorithm, and the y-axis shows the rmse.
% We have 5 implementations for comparision.
% figure 1:
% conventional SVD
% SVD with no bias calculation step
% SVD with normal bias calculation step
% SVD with improved bias calculation step
% figure 2:
% SVD++ with improved bias calculation step
% Each algorithm was ran for 10,20,30 iterations


%% DATA
% Time took by the algorithms
time = [16.168274, 33.639394, 47.420169;
        21.879765, 38.55117, 61.894201;
        21.990894, 42.030528, 65.005437;
        210.884219, 380.36955, 561.748142];
% Error got by the algorithms
error = [0.98188, 0.98183, 0.98194;
        0.96992, 0.9665, 0.96579;
        0.96453, 0.9593, 0.95818;
        0.96457, 0.95921, 0.95821];

% Split date for plotting
x0 = (9.089707);
y0 = (0.97335);
x1 = time(1,:);
y1 = error(1,:);
x2 = time(2,:);
y2 = error(2,:);
x3 = time(3,:);
y3 = error(3,:);
x4 = time(4,:);
y4 = error(4,:);
x5 = (150);  % Value to adjust plot with legend
y5 = (0.97); % Value to adjust plot with legend

%% PLOT
% Figure 1
figure(1);
plot(x0,y0,'+',...
    x1,y1,'-O',...
    x2,y2,'->',...
    x3,y3,'-X',...
    x5,y5, 'LineWidth',2);

grid on;
xlabel('Running Time (seconds)'); 
ylabel('RMSE');
legend('Convetional SVD', ['SVD with no bias' char(10) 'calculation step'],...
    ['SVD with normal bias' char(10) 'calculation step'],...
    ['SVD with improved bias' char(10) 'calculation step'],...
    'location','NorthEast');
set(gca,'xtick',[0, 25, 50, 75, 150]);
set(gca,'XGrid','off','YGrid','on');
set(gca,'TickLength',[0 0]);
set(gca,'color',[1, 0.937255, 0.835294]);

iterations = [10,20,30];
strValues0 = strtrim(cellstr(num2str(1,'%d')));
strValues = strtrim(cellstr(num2str(iterations(:),'%d')));
text(x0,y0,strValues0,'VerticalAlignment','bottom');
text(x1,y1,strValues,'VerticalAlignment','bottom');
text(x2,y2,strValues,'VerticalAlignment','bottom');
text(x3,y3,strValues,'VerticalAlignment','bottom');

% Figure 2
figure(2);
plot(x4,y4, '-square','Color', [0, 0.392157, 0],'LineWidth',2);

grid on;
xlabel('Running Time (seconds)'); 
ylabel('RMSE');
legend(['SVD++ with improved bias' char(10) 'calculation step'], 'location','NorthEast');
set(gca,'xtick',[250, 350, 450, 500, 550]);
set(gca,'XGrid','off','YGrid','on');
set(gca,'TickLength',[0 0]);
set(gca,'color',[1, 0.937255, 0.835294]);

text(x4,y4,strValues,'VerticalAlignment','bottom');

