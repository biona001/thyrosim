function f = simulate()
    patient = [1.7 70.0 1]; %height (m), weight(kg), and sex (male = 1)
    T4_init = 73.52;
    T3_init = 1.264;
    Tsh_init = 1.896;
    t_unit = 'hours'; %currently not used
    
    %simulation length
    tspan = [0, 24]; %how often are doses given
    repeat = 100;

    %get dosages based on various formulas
    addpath('../dosage_models')
    %T4dose = cunningham(patient(2), patient(3), 30); %weight, sex, age
    %T4dose = mandel(patient(2)); %weight
    %T4dose = ojomo(patient(1), patient(2)); %weight, height)
    %T4dose = mistry(patient(2), 30); %weight, age
    %T4dose = donna(patient(1), patient(2), 30); %height, weight, age
    %T4dose = 0.257; %this is 200 micrograms of T4
    T4dose = 0.0;
    %T3dose = 0.046; %0.046 = 30mcg 0.069 = 45mcg
    T3dose = 0.0;
    
    %construct simulation parameters
    tspans = [];
    T4doses = [];
    T3doses = [];
    for i=1:repeat
        tspans = [tspans; tspan];
        T4doses = [T4doses; T4dose];
        T3doses = [T3doses; T3dose];
    end
    %T4doses(15) = 0.772;
    
    
    %read blakesley data for parameter fitting
    %{
    [time, my400_data, my450_data, my600_data] = parse_blakesley();
    tspans = [];
    for i=1:(length(time)-1)
        %each row of tspans define a period of time in hours (e.g. [0, 24; 0, 24])
        %tspans = [tspans; 0, time(i+1) - time(i)];
        tspans = [tspans; 0, i];
    end
    %T4 drug dosage at beginning of 2nd day, and 0 T3 dose
    T4doses = [0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;
    0.772;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0]; %600 micrograms = 0.7722 micromoles
    T3doses = [0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;
    0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0];
    %}
    
    %below are simulation parameters for blakesley data
    %{
    tspans = [0, 24; 0, 24; 0, 24; 0, 24; 0, 24];
    T4doses = [0; 0.772; 0.0; 0.0; 0.0]; %600 micrograms = 0.7722 micromoles
    T3doses = [0.0; 0.0; 0.0; 0.0; 0.0];
    %}
    
    %simulate and plot
    [t4_values, t3_values, tsh_values] = thyrosim_oral_repeat_ben_sim(patient, T4_init, T3_init, Tsh_init, t_unit, tspans, T4doses, T3doses);
    
    %overlay real data with plotted values
    %plot_blakesley();
    
    %f = 0.0; %this calculates the error, need data
end
    
    
    %{
    [a, b, c, d, t4_std, t3_std, tsh_std] = data_test2();
    f = 0.0;
    
    for i=1:size(a, 1)
        patient_param = a(i,:);  
        patient_t4 = b(i,:);
        patient_t3 = c(i,:);
        patient_tsh = d(i,:);
       
        [t4_values, t3_values, tsh_values] = thyrosim_oral_repeat_ben4(fitting_index,current_iter, patient_param, patient_t4(1), patient_t3(1), patient_tsh(1), dose(i));
        
        %first point not considered because they are the same
        f = f + (patient_t3(2) - t3_values(2))^2;
        f = f + (patient_t3(3) - t3_values(3))^2;
        f = f + (patient_t3(4) - t3_values(5))^2;
        f = f + (patient_t3(5) - t3_values(7))^2;
        f = f + (patient_t3(6) - t3_values(9))^2;
        f = f + (patient_t3(7) - t3_values(11))^2;
        f = f + (patient_t3(8) - t3_values(13))^2;
        f = f + (patient_t3(9) - t3_values(15))^2;
        f = f + (patient_t3(10) - t3_values(17))^2;
        
        f = f + (patient_t4(2) - t4_values(2))^2/1000;
        f = f + (patient_t4(3) - t4_values(3))^2/1000;
        f = f + (patient_t4(4) - t4_values(5))^2/1000;
        f = f + (patient_t4(5) - t4_values(7))^2/1000;
        f = f + (patient_t4(6) - t4_values(9))^2/1000;
        f = f + (patient_t4(7) - t4_values(11))^2/1000;
        f = f + (patient_t4(8) - t4_values(13))^2/1000;
        f = f + (patient_t4(9) - t4_values(15))^2/1000;
        f = f + (patient_t4(10) - t4_values(17))^2/1000;
        
        %{
        f = f + (patient_t4(2) - t4_values(2))^2/t4_std(2)^2;
        f = f + (patient_t4(3) - t4_values(3))^2/t4_std(3)^2;
        f = f + (patient_t4(4) - t4_values(5))^2/t4_std(4)^2;
        f = f + (patient_t4(5) - t4_values(7))^2/t4_std(5)^2;
        f = f + (patient_t4(6) - t4_values(9))^2/t4_std(6)^2;
        f = f + (patient_t4(7) - t4_values(11))^2/t4_std(7)^2;
        f = f + (patient_t4(8) - t4_values(13))^2/t4_std(8)^2;
        f = f + (patient_t4(9) - t4_values(15))^2/t4_std(9)^2;
        f = f + (patient_t4(10) - t4_values(17))^2/t4_std(10)^2;
        
        f = f + (patient_t3(2) - t3_values(2))^2/t3_std(2)^2;
        f = f + (patient_t3(3) - t3_values(3))^2/t3_std(3)^2;
        f = f + (patient_t3(4) - t3_values(5))^2/t3_std(4)^2;
        f = f + (patient_t3(5) - t3_values(7))^2/t3_std(5)^2;
        f = f + (patient_t3(6) - t3_values(9))^2/t3_std(6)^2;
        f = f + (patient_t3(7) - t3_values(11))^2/t3_std(7)^2;
        f = f + (patient_t3(8) - t3_values(13))^2/t3_std(8)^2;
        f = f + (patient_t3(9) - t3_values(15))^2/t3_std(9)^2;
        f = f + (patient_t3(10) - t3_values(17))^2/t3_std(10)^2;
        %}
        %{
        f = f + (((patient_tsh(2) - tsh_values(2)))/scale(3))^2;
        f = f + ((patient_tsh(3) - tsh_values(3))/scale(3))^2;
        f = f + ((patient_tsh(4) - tsh_values(5))/scale(3))^2;
        f = f + ((patient_tsh(5) - tsh_values(7))/scale(3))^2;
        f = f + ((patient_tsh(6) - tsh_values(9))/scale(3))^2;
        f = f + ((patient_tsh(7) - tsh_values(11))/scale(3))^2;
        f = f + ((patient_tsh(8) - tsh_values(13))/scale(3))^2;
        f = f + ((patient_tsh(9) - tsh_values(15))/scale(3))^2;
        f = f + ((patient_tsh(10) - tsh_values(17))/scale(3))^2;
        %}
    end
    
end
%}

%current_iter = [584 0.108 127 0.0689 0.88]
%lb = [58.4 0.0108 12.7 0.00689 0.088]
%ub = [5840 1.08 1270 0.689 8.8]
%result = [85.94502246688222	0.010808207385206747	114.72244173896375	0.07149207064342102	0.49326028594692967]




% remember we changed the dial. Originally k3exrete is defined like 
% p(46) = 0.12*d(4);      %k3excrete; originally 0.118
% but we needed to fit the k3excrete term, so we changed the above line to
% p(46) = 0.1056;   
% and fitted p(46)
%current_iter = [1.78 0.88 0.1056]
%lb = [0.178 0.088 0.01056]
%up = [17.8 8.8 1.056]

%result = [8.989128573070056	0.49828581622780815	0.05856227243987056]



