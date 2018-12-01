function createfigure(XData1, YData1, XData2, YData2)
%CREATEFIGURE(XDATA1, YDATA1, XDATA2, YDATA2)
%  XDATA1:  line xdata
%  YDATA1:  line ydata
%  XDATA2:  line xdata
%  YDATA2:  line ydata

%  Auto-generated by MATLAB on 23-Jun-2017 11:26:24

% Create figure
figure1 = figure('Tag','Print CFTOOL to Figure',...
    'Color',[0.933333333333333 0.933333333333333 0.933333333333333]);

% Create axes
axes1 = axes('Parent',figure1,'Tag','sftool surface axes');
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[-51.4 221.1]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[36.62 105.63]);
%% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-1 1]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'on');

% Create zlabel
zlabel('Z');

% Create ylabel
ylabel('bv');

% Create xlabel
xlabel('div');

% Create title
title({''});

% Create line
line(XData1,YData1,'Parent',axes1,'DisplayName','bv vs. div',...
    'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',3,...
    'Marker','o',...
    'LineStyle','none');

% Create line
line(XData2,YData2,'Parent',axes1,'DisplayName','4th order polynomial',...
    'LineWidth',1.5,...
    'Color',[0.0705882352941176 0.407843137254902 0.701960784313725]);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.453502186580874 0.565909090909091 0.286581320726015 0.218181785708823],...
    'Interpreter','none',...
    'EdgeColor',[0.15 0.15 0.15],...
    'FontSize',20);
