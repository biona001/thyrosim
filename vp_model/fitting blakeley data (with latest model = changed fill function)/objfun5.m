function f = objfun5(current_iter)
    fitting_index = [45 28 30 31];
    
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
    end
    
    %patient parameters = height (m), weight(kg), and sex (male = 1)
    patient_param = [1.7 70.0 1];
    
    %initialize residual sum of squares
    f = 0.0;
    
    %loop through the 3 datasets we have
    for i=1:3
        cur_data = blakesley_data(:,:,i);        
        initial_condition = [cur_data(1,1); cur_data(1,2); cur_data(1,3)]; %T4/T3/TSH 

        %T4 drug dosage at beginning of 2nd day (16th time point)
        T4doses = zeros(num_sim,1);
        T3doses = zeros(num_sim,1);
        T4doses(16) = doses(i);

        if length(T4doses) ~= length(tspans)
            error('hey hey check vector length again brah');
        end

        %simulate data and grab desired points. 
        [t4_values, t3_values, tsh_values] = thyrosim_oral_repeat_ben5(fitting_index,current_iter,tspans,patient_param,initial_condition,T4doses,T3doses);
        
        %add to error
        f = f + dot(cur_data(:,1), t4_values);
        f = f + dot(cur_data(:,2), t3_values);
        f = f + dot(cur_data(:,3), tsh_values);

        %overlay real data with simulated values
        %plot_blakesley(i);
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






%init = [1.78 0.498286 1166/10 581/10]
