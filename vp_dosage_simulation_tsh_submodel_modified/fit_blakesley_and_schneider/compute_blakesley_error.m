function f = compute_blakesley_error(current_iter, fitting_index, time, blakesley_data, doses, thyrosim_version, make_plots)

    %generate tspans
    num_sim = length(time)-1;
    tspans = zeros(num_sim,2);
    for i=1:num_sim
        tspans(i, :) = [0 time(i+1)-time(i)]; %(e.g. [0, 24; 0, 24])
    end
        
    %patient parameters = height (m), weight(kg), and sex (male = 1)
    patient_param = [1.77 70.0 1]; 
    
    %[T4 Secretion, T4 Absorption, T3 Secretion, T3 Absorption] 
    dial = [1.0, 0.88, 1.0, 0.88]; %blakesley patients are healthy
    
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
        %T4doses = 0.193*ones(num_sim,1);

        if length(T4doses) ~= length(tspans)
            error('hey hey check vector length again brah');
        end

        %simulate data and grab desired points. 
        [total_time, total_q, jonklaas_t4, jonklaas_t3, jonklaas_tsh, ...
            blakesley_t4, blakesley_t3, blakesley_tsh] = thyrosim_oral_repeat_ben_sim(patient_param, cur_data(1,1), cur_data(1,2), cur_data(1,3), 'days', tspans, T4doses, T3doses,fitting_index,current_iter, thyrosim_version, dial);
        
        %calculate residuals and add to f
        r1 = cur_data(:,1) - blakesley_t4;
        r2 = cur_data(:,2) - blakesley_t3;
        r3 = cur_data(:,3) - blakesley_tsh;
        f = f + dot(r1, r1)/10000; %scale T4 data down to approxiate range
        f = f + dot(r2, r2);
        f = f + dot(r3, r3);

        %overlay real data with simulated values
        %recall that blakesley_doses is [0.515; 0.579; 0.7722] which corresponds to 400/450/600 micrograms
        if make_plots
            plot_blakesley(i);
            myfig = plot_simulation(total_time, total_q, patient_param, 'blue', thyrosim_version);
            saveas(myfig, ['./blakesley_plots/', thyrosim_version, '_thyrosim/', num2str(T4_micromols_to_micrograms(doses(i))),'micrograms_T4.png']);
            clf('reset');
        end
    end
end

function T4_micrograms = T4_micromols_to_micrograms(T4dose)
    T4_micrograms = round(T4dose * 777);
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
%test = [100.0	47.64447847034241	4.574319275722421 3.902060329741689	6.90649038160358	7.656719244520238]
