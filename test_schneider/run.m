function run()
    %import data
    data = readtable('ThyHormDosing_aug2017_deidentified.csv');

    %define patient characteristics
    j = 1;

    H = data.Ht_m;
    W = data.Wt_kg;
    sex = data.Sex;
    T4_init = 78.35;
    T3_init = 1.36;
    Tsh_init = data.TSH_preop;
    patient_param = [H(j); W(j); sex(j)];
    days = data.Days_to_euthyroid;
    
    %construct T4 doses to test
    lower_T4_per_kg = 1.0;
    upper_T4_per_kg = 3.0;
    T4_dose_grams_lower = round(W(j) * lower_T4_per_kg / 12.5) * 12.5;
    T4_dose_grams_upper = round(W(j) * upper_T4_per_kg / 12.5) * 12.5;
    possible_doses = T4_dose_grams_lower:12.5:T4_dose_grams_upper;
    doses_passing = true(length(possible_doses), 1);
    disp(length(possible_doses));
    
    for i = 1:length(possible_doses)
        [total_time, total_q] = simulate(H(j), W(j), sex(j), T4_init, T3_init, Tsh_init(j), convert(possible_doses(i)), days(j));
        
        normal_range = [0.45; 4.5];
        simulated_tsh = total_q(total_time >= (days(j) - 1)*24, 7);
        if any(simulated_tsh <= normal_range(1)) && any(simulated_tsh >= normal_range(2))
            doses_passing(i) = false;
        end
        
        %plot the reuslt
        plot_simulation(total_time, total_q, patient_param)
    end
    
    %see how many doses are successfully enthyroiding the patient.
    disp(possible_doses(doses_passing));
    
end

function T4_micromols = convert(T4dose)
    T4_micromols = T4dose / 777;
end