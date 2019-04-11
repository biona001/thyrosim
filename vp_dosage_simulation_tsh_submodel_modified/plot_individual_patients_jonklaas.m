function plot_individual_patients_jonklaas()
    %specify time of dosage and import data
    patient_t = [0, 5/12/24, 1/24, 2/24, 3/24, 4/24, 5/24 ,6/24 ,7/24 ,8/24]; %days
    [patient_param, patient_t4, patient_t3, patient_tsh, t4_std, t3_std, tsh_std] = data_test2();
    dose = [0.046 0.046 0.069 0.069 0.046 0.046 0.069 0.046 0.046 0.046 0.069 0.069 0.069 0.069 0.046];
        
    for i=1:size(patient_t4, 1)
        %simulate using thyrosim
        [total_time, total_q] = simulate(patient_param(i, 1:3), patient_t4(i, 1), patient_t3(i, 1), patient_tsh(i, 1), dose(i));

        %some needed conversion factors
        T4max = max(total_q(:,1));
        T3max = max(total_q(:,4));
        TSHmax = max(total_q(:,7));
        [Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(patient_param(i, 1:3));
        T4conv  = 777/Vp_new;         % mcg/L
        T3conv  = 651/Vp_new;         % mcg/L
        TSHconv = 5.6/Vtsh_new;       % mU/L
        y1 = total_q(:,1)*T4conv;     % T4
        y2 = total_q(:,4)*T3conv;     % T3
        y3 = total_q(:,7)*TSHconv;    % TSH
        t  = total_time/24;           % Convert time to days
        p1max = max([patient_t4(i, :) T4max*T4conv]);     % T4
        p2max = max([patient_t3(i, :) T3max*T3conv]);     % T3
        p3max = max([patient_tsh(i, :) TSHmax*TSHconv]);    % TSH
        
        %plot real and simulation data
        myfig = subplot(3, 1, 1);
        hold on;
        plot(patient_t, patient_t4(i,:),'black.','MarkerSize',20); %real data
        plot(t,y1,'color','black'); %simulation data
        ylabel('T4 mcg/L');
        ylim([0 1.5*p1max]);
        hline = refline(0,45); %slope, intercept
        hline2 = refline(0,105); %slope, intercept
        hline.Color='g';
        hline2.Color='g';
        set(gca,'fontsize',18)
    
        if patient_param(i, 3)
            sex = 'male';
        else
            sex = 'female';
        end
        name = ['Patient ', num2str(i), ' (', num2str(patient_param(i, 1)), ...
            'm ', num2str(patient_param(i, 2)), 'kg ', ...
            sex, ', ', num2str(round(dose(i)*651)), ' ug oral T3)'];
        title({name});
        subplot(3, 1, 2);
        hold on;
        plot(patient_t, patient_t3(i,:),'red.','MarkerSize',20);
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
        plot(patient_t, patient_tsh(i,:) ,'blue.','MarkerSize',20);
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
        
        %save plot and clear workspace
        %savefig(['./individual_plots/', num2str(i), '.fig'])
        saveas(myfig, ['./individual_plots_new_ode/', num2str(i), '.png'])
        clf('reset')
    end 
end
