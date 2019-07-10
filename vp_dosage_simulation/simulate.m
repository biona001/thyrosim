function simulate()
    patient = [1.7 70.0 0]; %height (m), weight(kg), and sex (male = 1)
    T4_init = 77.0;
    T3_init = 1.2;
    Tsh_init = 1.9;
    t_unit = 'hours'; %currently not used
    thyrosim_version = 'new'; %new or original
    dial = [0.1, 0.88, 0.1, 0.88]; %[T4 Secretion, T4 Absorption, T3 Secretion, T3 Absorption] 
    
    %simulation length
    tspan = [0, 24]; %how often are doses given
    repeat = 100;

    %get dosages based on various formulas
    addpath('../dosage_models')
    %T4dose = cunningham(patient(2), patient(3), 30); %weight, sex, age
    %T4dose = 2.0 * mandel(patient(2)); %weight
    %T4dose = ojomo(patient(1), patient(2)); %weight, height)
    %T4dose = mistry(patient(2), 30); %weight, age
    %T4dose = donna(patient(1), patient(2), 30); %height, weight, age
    %T4dose = 0.257; %this is 200 micrograms of T4
    T4dose = 0.0;   
    T3dose = 0.0; %0.046 = 30mcg 0.069 = 45mcg 
    %disp(T4dose);
    %T3dose = 0.0;
            
    %construct simulation parameters
    tspans = [];
    T4doses = [];
    T3doses = [];
    for i=1:repeat
        tspans = [tspans; tspan];
        T4doses = [T4doses; T4dose];
        T3doses = [T3doses; T3dose];
    end
    
    %simulate and plot
    [total_time, total_q] = thyrosim_oral_repeat_ben_sim(patient, T4_init, T3_init, Tsh_init, t_unit, tspans, T4doses, T3doses, thyrosim_version, dial,[]);
    %plot_simulation(total_time, total_q, patient, 'blue', thyrosim_version);
    
    
    
    %do another round of simulation using end points as starting values
    %using this option means T4_init, T3_init, and Tsh_init will not
    %actually be initial values
    
    %grab end points from previous simulation as starting values
    ics = total_q(end, :);
    
    %define new simulation
    repeat = 30;
    tspans = [];
    for i=1:repeat
        tspans = [tspans; tspan];
    end
    T4doses = zeros(repeat, 1);
    T3doses = zeros(repeat, 1);
    T4doses(4:25) = 0.166; %129 microgram of T4
    
    [total_time, total_q] = thyrosim_oral_repeat_ben_sim(patient, T4_init, T3_init, Tsh_init, t_unit, tspans, T4doses, T3doses, thyrosim_version, dial, ics);
    plot_simulation(total_time, total_q, patient, 'blue', thyrosim_version);
end
