function f = objfun5(current_iter)
    fitting_index = [30 31 49 50 51 52];
    
    if length(fitting_index) ~= length(current_iter)
        error('check vector length bro');
    end
    
    %read blakesley data for parameter fitting
    [time, blakesley_data] = parse_blakesley();    
    doses = [0.515; 0.579; 0.7722]; %400/450/600 micrograms
    
    %generate tspans
    num_sim = length(time)-1;
    tspans = zeros(num_sim,2);
    for i=1:num_sim
        tspans(i, :) = [0 time(i+1)-time(i)]; %(e.g. [0, 24; 0, 24])
        %tspans(i, :) = [0 24];
    end
        
    %patient parameters = height (m), weight(kg), and sex (male = 1)
    patient_param = [1.77 70.0 1]; 
    
    %initialize residual sum of squares
    f = 0.0;
    
    %loop through the 3 datasets we have
    for i=1:3
    %i = 1;    
        cur_data = blakesley_data(:,:,i);        
        initial_condition = [cur_data(1,1); cur_data(1,2); cur_data(1,3)]; %T4/T3/TSH 
        %disp(initial_condition);
        
        %T4 drug dosage at beginning of 2nd day (16th time point)
        T4doses = zeros(num_sim,1);
        T3doses = zeros(num_sim,1);
        T4doses(16) = doses(i);
        %T4doses = 0.193*ones(num_sim,1);

        if length(T4doses) ~= length(tspans)
            error('hey hey check vector length again brah');
        end

        %simulate data and grab desired points. 
        [t4_values, t3_values, tsh_values] = thyrosim_oral_repeat_ben5(fitting_index,current_iter,tspans,patient_param,initial_condition,T4doses,T3doses);
        
        %calculate residuals and add to f
        r1 = cur_data(:,1) - t4_values;
        r2 = cur_data(:,2) - t3_values;
        r3 = cur_data(:,3) - tsh_values;
        f = f + dot(r1, r1)/10000; %scale T4 data down to approxiate range
        f = f + dot(r2, r2);
        f = f + dot(r3, r3);

        %overlay real data with simulated values
        plot_blakesley(i);
    end
end

% remember we changed the dial. Originally k3exrete is defined like 
% p(46) = 0.12*d(4);      %k3excrete; originally 0.118
% but we needed to fit the k3excrete term, so we changed the above line to
% p(46) = 0.1056;   
% and fitted p(46)
%current_iter = [1.78 0.88 0.1056]
%lb = [0.178 0.088 0.01056]
%up = [17.8 8.8 1.056]

%result = [8.989128573070056	0.49828581622780815	0.05856227243987056]






% fitting with t4, t3, TSH 
%init = [100.0 49.39 4.0 3.0 7.0 5.2]
%upper = [1000.0 493.9 40.0 30.0 70.0 52.0]
%lower = [10.0 4.939 0.4 0.3 0.7 0.52]
%result = [100.98899964336827	47.64447847034241	4.574319275722421 3.902060329741689	6.90649038160358	7.656719244520238]
