function run()
    %import data
    data = readtable('ThyHormDosing_aug2017_deidentified.csv');

    %define patient characteristics
    H = data.Ht_m;
    W = data.Wt_kg;
    sex = data.Sex;
    Tsh_init = data.TSH_preop;
    days = data.Days_to_euthyroid;
    T4_init = 78.35; % original thyrosim parameter
    T3_init = 1.36;  % original thyrosim parameter
    
    for j = 1:size(data, 1)
        %construct patient parameters and T4 doses
        patient_param = [H(j); W(j); sex(j)];
        lower_T4_per_kg = 1.0;
        upper_T4_per_kg = 3.0;
        T4_dose_grams_lower = round(W(j) * lower_T4_per_kg / 12.5) * 12.5;
        T4_dose_grams_upper = round(W(j) * upper_T4_per_kg / 12.5) * 12.5;
        possible_doses = T4_dose_grams_lower:12.5:T4_dose_grams_upper;
        doses_passing = true(length(possible_doses), 1);
        
        for i = 1:length(possible_doses)
            %run simulation then check if tsh ever exceed normal range
            [total_time, total_q] = simulate(H(j), W(j), sex(j), T4_init, T3_init, Tsh_init(j), T4_microgram_to_micromol(possible_doses(i)), days(j));
            normal_range = [0.45; 4.5];
            simulated_tsh = Tsh_micromol_to_microgram(total_q(total_time >= (days(j) - 1)*24, 7), H(j), W(j), sex(j));
            disp(possible_doses(i));
            
            %save results that does pass
            if any(simulated_tsh <= normal_range(1)) || any(simulated_tsh >= normal_range(2))
                doses_passing(i) = false;
            else
                % plot and save
                myfig = plot_simulation(total_time, total_q, patient_param);
                saveas(myfig, ['./plots_and_doses/', num2str(j), '/dose_', num2str(possible_doses(i)),'.png']);
                clf('reset');
            end
        end

        %save doses that successfully enthyroiding the patient
        fileID = fopen(['./plots_and_doses/', num2str(j), '/', num2str(j), '.txt'], 'w');
        fprintf(fileID,'%f\n',possible_doses(doses_passing));
    end
end

% no conversion needed because we need a dosage here
function T4_micromols = T4_microgram_to_micromol(T4dose)
    T4_micromols = T4dose / 777;
end

function Tsh_microgram = Tsh_micromol_to_microgram(tsh_val, H, W, sex)
    patient_param = [H, W, sex];
    [Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(patient_param);
    TSHconv = 5.6/Vtsh_new;       % mU/L
    
    Tsh_microgram = tsh_val * TSHconv;
end
