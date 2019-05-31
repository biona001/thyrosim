function train()
    %import data
    data = readtable('schneider_train_500patients.csv');
    
    %specify thyrosim version (either 'new' or 'original')
    thyrosim_version = 'original';
    %thyrosim_version = 'new';
    %define patient characteristics
    H = data.Ht_m;
    W = data.Wt_kg;
    sex = data.Sex;
    Tsh_init = data.TSH_preop;
    days = data.Days_to_euthyroid;
    days(days>100) = 100; %max simulation days would be 100
    T4_init = 78.35; % original thyrosim parameter
    T3_init = 1.36;  % original thyrosim parameter
    right_doses = data.LT4_euthyroid_dose;
    initial_doses = data.LT4_initial_dose;
    patient_id = data.patient_ID;
    
    %compute some summary statistics
    skinny_patients = false(size(data, 1), 1);
    healthy_patients = false(size(data, 1), 1);
    overweight_patients = false(size(data, 1), 1);
    obese_patients = false(size(data, 1), 1);
    
    euthyroid_dose_passes = true(size(data, 1), 1);
    initial_dose_passes = true(size(data, 1), 1);
    
    tic;
    for j = 1:size(data, 1)
        %construct patient parameters and T4 doses
        patient_param = [H(j); W(j); sex(j)];
        current_patient = patient_id(j);
        %lower_T4_per_kg = 1.0;
        %upper_T4_per_kg = 3.0;
        %T4_dose_grams_lower = round(W(j) * lower_T4_per_kg / 12.5) * 12.5;
        %T4_dose_grams_upper = round(W(j) * upper_T4_per_kg / 12.5) * 12.5;
        %possible_doses = T4_dose_grams_lower:12.5:T4_dose_grams_upper;
        %doses_passing = true(length(possible_doses), 1);
        bmi = W(j) / H(j)^2;
        if bmi < 18.5
            skinny_patients(j) = true;
        elseif 18.5 <= bmi && bmi < 24.9
            healthy_patients(j) = true;
        elseif 24.9 <= bmi && bmi < 29.9
            overweight_patients(j) = true;
        else
            obese_patients(j) = true;
        end
        
        if right_doses(j) == initial_doses(j)
            possible_doses = [right_doses(j)];
        else
            possible_doses = [right_doses(j); initial_doses(j)];
        end
        
        for i = 1:length(possible_doses)
            %run simulation, inputting original thyrosim's default tsh if no initial value provided
            if isnan(Tsh_init(j))
                Tsh_init(j) = 1.7; %thyrosim's original tsh value
            end
            [total_time, total_q] = simulate(H(j), W(j), sex(j), T4_init, T3_init, Tsh_init(j), T4_microgram_to_micromol(possible_doses(i)), days(j), thyrosim_version);
            
            %check if tsh ever exceed normal range
            normal_range = [0.45; 4.5];
            simulated_tsh = Tsh_micromol_to_microgram(total_q(total_time >= (days(j) - 1)*24, 7), H(j), W(j), sex(j), thyrosim_version);
            if any(simulated_tsh <= normal_range(1)) || any(simulated_tsh >= normal_range(2))
                if length(possible_doses) == 1
                    euthyroid_dose_passes(j) = false;
                    initial_dose_passes(j) = false;
                elseif i == 1
                    euthyroid_dose_passes(j) = false;
                else
                    initial_dose_passes(j) = false;
                end
            end
            
            if i == 1
                myfig = plot_simulation(total_time, total_q, patient_param, 'blue', thyrosim_version);
            else
                myfig = plot_simulation(total_time, total_q, patient_param, 'red', thyrosim_version);
            end
        end
        
        %create plot title
        a = axes;
        row1 = [thyrosim_version, ' Thyrosim'];
        row2 = ['Patient ', num2str(current_patient), ': ', num2str(H(j)), 'm, ', ...
            num2str(W(j)), 'KG. BMI = ', num2str(bmi)];
        row3 = ['Init dose = ', num2str(initial_doses(j)), ' ug oral T4(red),', ...
            ' euthyroid dose = ', num2str(right_doses(j)), ' ug (blue)'];
        t = title({row1; row2; row3});
        a.Visible = 'off';
        t.Visible = 'on';
        set(gca,'fontsize',15)
        
        %save figure
        saveas(myfig, ['./training_result/', thyrosim_version, '_thyrosim/', num2str(current_patient),'.png']);
        clf('reset');
        
        %save doses that successfully enthyroiding the patient
        %fileID = fopen(['./plots_and_doses/', num2str(j), '/doses_passing.txt'], 'w');
        %fprintf(fileID,'%f\n',possible_doses(doses_passing));
    end
    mytime = toc;
    disp(mytime);
    
    %save summary statistic
    fileID = fopen(['./training_result/', thyrosim_version, '_thyrosim/summary.txt'], 'w');
    fprintf(fileID, '%s%s%s%s\n', 'Among all ', num2str(size(data, 1)), ' patients, initial doses that passes: ', num2str(sum(initial_dose_passes)));
    fprintf(fileID, '%s%s%s%s\n\n', 'Among all ', num2str(size(data, 1)), ' patients, euthyroid doses that passes: ', num2str(sum(euthyroid_dose_passes)));
    fprintf(fileID, '%s%s%s%s\n', 'Among ',num2str(sum(skinny_patients)), ' skinny patients, initial doses that passes: ', num2str(sum(initial_dose_passes(skinny_patients))));
    fprintf(fileID, '%s%s%s%s\n\n', 'Among ',num2str(sum(skinny_patients)),' skinny patients, euthyroid doses that passes: ', num2str(sum(euthyroid_dose_passes(skinny_patients))));
    fprintf(fileID, '%s%s%s%s\n', 'Among ',num2str(sum(healthy_patients)),' healthy patients, initial doses that passes: ', num2str(sum(initial_dose_passes(healthy_patients))));
    fprintf(fileID, '%s%s%s%s\n\n', 'Among ',num2str(sum(healthy_patients)),' healthy patients, euthyroid doses that passes: ', num2str(sum(euthyroid_dose_passes(healthy_patients))));
    fprintf(fileID, '%s%s%s%s\n', 'Among ',num2str(sum(overweight_patients)),' overweight patients, initial doses that passes: ', num2str(sum(initial_dose_passes(overweight_patients))));
    fprintf(fileID, '%s%s%s%s\n\n', 'Among ',num2str(sum(overweight_patients)),' overweight patients, euthyroid doses that passes: ', num2str(sum(euthyroid_dose_passes(overweight_patients))));
    fprintf(fileID, '%s%s%s%s\n', 'Among ',num2str(sum(obese_patients)),' obese patients, initial doses that passes: ', num2str(sum(initial_dose_passes(obese_patients))));
    fprintf(fileID, '%s%s%s%s\n\n', 'Among ',num2str(sum(obese_patients)),' obese patients, euthyroid doses that passes: ', num2str(sum(euthyroid_dose_passes(obese_patients))));
    fclose(fileID);
end

% no conversion needed because we need a dosage here
function T4_micromols = T4_microgram_to_micromol(T4dose)
    T4_micromols = T4dose / 777;
end

function Tsh_microgram = Tsh_micromol_to_microgram(tsh_val, H, W, sex, thyrosim_version)
    if strcmp(thyrosim_version, 'new')
        patient_param = [H, W, sex];
        [Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(patient_param);
        TSHconv = 5.6/Vtsh_new;       % mU/L
        Tsh_microgram = tsh_val * TSHconv;
    elseif strcmp(thyrosim_version, 'original')
        Tsh_microgram = tsh_val;
    else
        error('thyrosim version not "original" nor "new".')
    end
end
