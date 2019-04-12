function f = fitting(current_iter)
    %specify the variables we want fitted
    fitting_index = [28 45 46];

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
        T3doses = zeros(repeat, 1);
        T3doses(1) = T3dose;
        tspans = [];
        T4doses = zeros(repeat, 1);
        for i=1:repeat
            tspans = [tspans; tspan];
        end

        %simulate 
        [total_time, total_q, return_t4, return_t3, return_tsh] = thyrosim_oral_repeat_ben_sim(patient, T4_init, T3_init, Tsh_init, t_unit, tspans, T4doses, T3doses,fitting_index,current_iter);
        create_plot(total_time, total_q, patient, T4data, T3data, TSHdata)
        
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

function create_plot(total_time, total_q, patient, T4data, T3data, TSHdata)
    patient_t = [0, 5/12/24, 1/24, 2/24, 3/24, 4/24, 5/24 ,6/24 ,7/24 ,8/24]; %days    

    %some needed conversion factors
    T4max = max(total_q(:,1));
    T3max = max(total_q(:,4));
    TSHmax = max(total_q(:,7));
    [Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(patient);
    T4conv  = 777/Vp_new;         % mcg/L
    T3conv  = 651/Vp_new;         % mcg/L
    TSHconv = 5.6/Vtsh_new;       % mU/L
    y1 = total_q(:,1)*T4conv;     % T4
    y2 = total_q(:,4)*T3conv;     % T3
    y3 = total_q(:,7)*TSHconv;    % TSH
    t  = total_time/24;           % Convert time to days
    p1max = max([T4data T4max*T4conv]);     % T4
    p2max = max([T3data T3max*T3conv]);     % T3
    p3max = max([TSHdata TSHmax*TSHconv]);    % TSH

    %plot real and simulation data
    myfig = subplot(3, 1, 1);
    hold on;
    plot(patient_t, T4data,'black.','MarkerSize',20); %real data
    plot(t,y1,'color','black'); %simulation data
    ylabel('T4 mcg/L');
    ylim([0 1.5*p1max]);
    hline = refline(0,45); %slope, intercept
    hline2 = refline(0,105); %slope, intercept
    hline.Color='g';
    hline2.Color='g';
    set(gca,'fontsize',18)

    if patient(3)
        sex = 'male';
    else
        sex = 'female';
    end
    %name = ['Patient ', num2str(i), ' (', num2str(patient_param(i, 1)), ...
    %    'm ', num2str(patient_param(i, 2)), 'kg ', ...
    %    sex, ', ', num2str(round(dose(i)*651)), ' ug oral T3)'];
    %title({name});
    subplot(3, 1, 2);
    hold on;
    plot(patient_t, T3data,'red.','MarkerSize',20);
    plot(t,y2,'color','red');
    subplot(3,1,2);
    ylabel('T3 mcg/L');
    ylim([0 1.5*p2max]);
    hline = refline(0,0.6); %slope, intercept
    hline2 = refline(0,1.8); %slope, intercept
    hline.Color='g';
    hline2.Color='g';
    set(gca,'fontsize',18)

    subplot(3, 1, 3);
    hold on;
    plot(patient_t, TSHdata,'blue.','MarkerSize',20);
    plot(t,y3,'color','blue');
    subplot(3,1,3);
    ylabel('TSH mU/L');
    ylim([0 p3max]);
    xlabel('Days');
    hline = refline(0,0.4); %slope, intercept
    hline2 = refline(0,4.0); %slope, intercept
    hline.Color='g';
    hline2.Color='g';
    set(gca,'fontsize',18)
end

%original = [0.88 1.78 0.1056];
%current_iter = [8.8 17.8 1.056];
%lower = [0 0 0];
%upper = [10 10 10];
%result = [0.46559884538558116	1.7110240098066678	0.04582882659618643];