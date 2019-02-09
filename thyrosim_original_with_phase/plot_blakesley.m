function plot_blakesley()
    %read blakesley data
    [time, T4, T3, TSH] = parse_blakesley();
    
    %make sure units of blakesley's data agrees with thyrosim
    time = time / 24; %convert hours to days
    T4 = T4 * 10;

    % General
    color = '.';
    Color = 'Black';

    % T4 plot
    subplot(3,1,1);
    hold on;
    plot(time,T4, 'red.','MarkerSize',20);

    % T3 plot
    subplot(3,1,2);
    hold on;
    plot(time,T3,'red.','MarkerSize',20);

    % TSH plot
    subplot(3,1,3);
    hold on;
    plot(time,TSH,'red.','MarkerSize',20);
end

