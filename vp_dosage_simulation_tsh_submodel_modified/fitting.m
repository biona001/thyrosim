function f = fitting(fitting_index, current_iter)
    %loop over all patients
    [patient_param, patient_t4, patient_t3, patient_tsh, t4_std, t3_std, tsh_std] = data_test2();
    dose = [0.046 0.046 0.069 0.069 0.046 0.046 0.069 0.046 0.046 0.046 0.069 0.069 0.069 0.069 0.046];
    f = 0.0;
    for i=1:size(patient_t4, 1)
        %import data
        patient = patient_param(i, 1:3);
        T4data = patient_t4(i, :);
        T3data = patient_t3(i, :); 
        TSHdata = patient_tsh(i, :);
        T3dose = dose(i);

        %define initial condition
        T4_init = T4data(1);
        T3_init = T3data(1);
        Tsh_init = TSHdata(1);
        t_unit = 'hours';

        %simulation length
        tspan = [0,0.5];
        repeat = 17;

        %assign dosages and construct simulation parameters
        T3doses(1) = T3dose;
        T4dose = 0.0;
        tspans = [];
        T4doses = zeros(repeat, 1);
        T3doses = zeros(repeat, 1);
        for i=1:repeat
            tspans = [tspans; tspan];
        end

        %simulate 
        [total_time, total_q, return_t4, return_t3, return_tsh] = thyrosim_oral_repeat_ben_sim(patient, T4_init, T3_init, Tsh_init, t_unit, tspans, T4doses, T3doses,fitting_index,current_iter);

        %calculate error between simulation and data
        idx = [1;2;3;5;7;9;11;13;15;17];
        subsetted_t3 = return_t3(idx);
        subsetted_t4 = return_t4(idx);
        f = f + compute_error(T4data, T3data, subsetted_t4, subsetted_t3);
    end
    
    %return root mean squared error for each data point
    f = sqrt(f / (size(patient_t3, 1) * (length(idx)-1)));
end

%only T3 error are being computed now
function f = compute_error(T4data, T3data, T4sim, T3sim)
    %{
    if length(T4data) ~= length(T4sim)
        error('T4 simulation vector and T4data vector not same length');
    end
    %}
    if length(T3data) ~= length(T3sim)
        error('T3 simulation vector and T3data vector not same length');
    end
    %return sum((T4data - T4sim).^2) + sum((T3data - T3sim).^2);
    f = sum((T3data - T3sim).^2);
end

%fitting_index = [];
%current_iter = [];
%f = fitting(fitting_index, current_iter)