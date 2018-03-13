function plot_distefano()
    % this function averages out Thyrosim's prediction on all patients
    % and plots the average + error bar. 
    fitting_index = [51 52 53];
    current_iter = [-0.25 0.75 1.0];
    dose = [0.046 0.046 0.069 0.069 0.046 0.046 0.069 0.046 0.046 0.046 0.069 0.069 0.069 0.069 0.046]; %all patients together 
    
    [a, b, c, d, t4_std, t3_std, tsh_std] = data_test2();

    %obtain patient matrix, rows = different patients, and columns =
    %concentration of T3/T4/TSH sampled every 30 minutes
    all_patient_t3 = [];
    all_patient_t4 = [];
    all_patient_tsh = [];
    for i=1:length(a)
        patient_param = a(i,:);  
        patient_t4 = b(i,:);
        patient_t3 = c(i,:);
        patient_tsh = d(i,:);
       
        [t4_values, t3_values, tsh_values] = thyrosim_oral_repeat_rate2(fitting_index,current_iter, patient_param, patient_t4(1), patient_t3(1), patient_tsh(1), dose(i), 60.0, 1.0);
        %disp(size(t4_values))
        all_patient_t3 = [all_patient_t3; t3_values]; %concatenating another row
        all_patient_t4 = [all_patient_t4; t4_values];
        all_patient_tsh = [all_patient_tsh; tsh_values];
    end
    
    %pick out the times (columns) that we actually care about:
    columns_to_delete = [4 6 8 10 12 14 16];
    all_patient_t3(:, columns_to_delete) = [];
    all_patient_t4(:, columns_to_delete) = [];
    all_patient_tsh(:, columns_to_delete) = [];
        
    %separate patients (rows) based on size and dose received.
    normal_dose30 = [1, 2, 5, 6, 8, 9]; %indeces
    normal_dose45 = [3, 4, 7];
    fat_dose_30 = [10, 15];
    fat_dose_45 = [11, 12, 13, 14];
    
    normal_list = {normal_dose30; normal_dose45};
    fat_list = {fat_dose_30; fat_dose_45};
   
    for i=1:2
       index = normal_list{i}; %this is the only thing (and plot title!) you need to change
       mean_t3 = mean(all_patient_t3(index,:));
       mean_t4 = mean(all_patient_t4(index,:));
       mean_tsh = mean(all_patient_tsh(index,:));
       t3_std = std(all_patient_t3(index,:));
       t4_std = std(all_patient_t4(index,:));
       tsh_std = std(all_patient_tsh(index,:));

       if i == 1
           color = '.--';
           Color = 'Blue';
       else
           color = '.--';
           Color = 'Red';
       end
       
       all_of_time = [0, 0.5, 1, 2, 3, 4, 5, 6, 7, 8]; %hours

       subplot(3,1,1);
       plot(all_of_time,mean_t4,color,'MarkerSize',20);
       hold on;
       errorbar(all_of_time, mean_t4,t4_std,'LineWidth',2.0,'Color',Color)
       ylabel('T4 mcg/L');
       ylim([0 110]);
       set(gca,'fontsize',18)

       title('Normal-weight group, blue = 30mcg, red = 45mcg');

       subplot(3,1,2);
       plot(all_of_time, mean_t3,color,'MarkerSize',20);
       hold on;
       errorbar(all_of_time, mean_t3,t3_std,'LineWidth',2.0,'Color',Color)
       ylabel('T3 mcg/L');
       ylim([0 5]);
       set(gca,'fontsize',18)

       subplot(3,1,3);plot(all_of_time, mean_tsh,color,'MarkerSize',20);hold on;errorbar(all_of_time, mean_tsh,tsh_std,'LineWidth',2.0,'Color',Color)
       ylabel('TSH mU/L');
       ylim([0 20]);
       xlabel('Hours');
       set(gca,'fontsize',18)
    end
end
