function plot_blakesley(iter)
    %read blakesley data
    [time, blakeley_data] = parse_blakesley();
    
    my400_data = blakeley_data(:,:,1);
    my450_data = blakeley_data(:,:,2);
    my600_data = blakeley_data(:,:,3);
    
    %make sure units of blakesley's data agrees with thyrosim
    time = time/24; %convert hours to days
    
    % General
    color = '.';
    Color = 'Black';
    
    %which data should I plot? (1 = 400mcg, 2 = 450mcg, 3 = 600mcg)
    if iter == 1
        T4 = my400_data(:,1);
        T3 = my400_data(:,2);
        TSH = my400_data(:,3);
        
        subplot(3,1,1);
        hold on;
        plot(time,T4, 'green.','MarkerSize',20);
        subplot(3,1,2);
        hold on;
        plot(time,T3,'green.','MarkerSize',20);
        subplot(3,1,3);
        hold on;
        plot(time,TSH,'green.','MarkerSize',20);
    elseif iter == 2
        T4 = my450_data(:,1);
        T3 = my450_data(:,2);
        TSH = my450_data(:,3);
        
        subplot(3,1,1);
        hold on;
        plot(time,T4, 'blue.','MarkerSize',20);
        subplot(3,1,2);
        hold on;
        plot(time,T3,'blue.','MarkerSize',20);
        subplot(3,1,3);
        hold on;
        plot(time,TSH,'blue.','MarkerSize',20);
    elseif iter == 3
        T4 = my600_data(:,1);
        T3 = my600_data(:,2);
        TSH = my600_data(:,3);
        
        subplot(3,1,1);
        hold on;
        plot(time,T4, 'red.','MarkerSize',20);
        subplot(3,1,2);
        hold on;
        plot(time,T3,'red.','MarkerSize',20);
        subplot(3,1,3);
        hold on;
        plot(time,TSH,'red.','MarkerSize',20);
    end
end

