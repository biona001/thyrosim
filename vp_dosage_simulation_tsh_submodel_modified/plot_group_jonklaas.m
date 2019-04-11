function plot_group_jonklaas()
    plot_group = 'overweight45';
    
    %specify time of dosage and import data
    patient_t = [0, 5/12/24, 1/24, 2/24, 3/24, 4/24, 5/24 ,6/24 ,7/24 ,8/24]; %days
    [patient_param, patient_t4, patient_t3, patient_tsh, t4_std, t3_std, tsh_std] = data_test2();
    dose = [0.046 0.046 0.069 0.069 0.046 0.046 0.069 0.046 0.046 0.046 0.069 0.069 0.069 0.069 0.046];
    
    if strcmp(plot_group, 'overweight30')
        name = 'Overweight patients with 30 mcg T3 oral dose, 2 patients';
        index = [10 15];        
    elseif strcmp(plot_group, 'overweight45')
        name = 'Overweight patients with 45 mcg T3 oral dose, 4 patients';
        index = [11 12 13 14];
    elseif strcmp(plot_group, 'normal45')
        name = 'Normal weight patients with 45 mcg T3 oral dose, 3 patients';
        index = [3 4 7];
    elseif strcmp(plot_group, 'normal30')
        name = 'Normal weight patients with 30 mcg T3 oral dose, 6 patients';
        index = [1 2 5 6 8 9];
    end
    
    %subset the data
    patient_param = patient_param(index, :);
    patient_t4 = patient_t4(index, :);
    patient_t3 = patient_t3(index, :);
    patient_tsh = patient_tsh(index, :);
        
    for i=1:size(index, 2)
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

        title({name});
        subplot(3, 1, 2);
        hold on;
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
        %saveas(myfig, ['./individual_plots/', num2str(i), '.png'])
        %clf('reset')
    end 

    color='k';
    Color='b';
    
    subplot(3, 1, 1);
    hold on;
    mean_t4 = mean(patient_t4);
    t4_std = std(patient_t4);
    plot(patient_t,mean_t4,color,'MarkerSize',20);
    hold on;
    errorbar(patient_t,mean_t4,t4_std,'LineWidth',2.0,'Color',Color)

    subplot(3, 1, 2);
    hold on;
    mean_t3 = mean(patient_t3);
    t3_std = std(patient_t3);
    plot(patient_t,mean_t3,color,'MarkerSize',20);
    hold on;
    errorbar(patient_t,mean_t3,t3_std,'LineWidth',2.0,'Color',Color)

    subplot(3, 1, 3);
    hold on;
    mean_tsh = mean(patient_tsh);
    tsh_std = std(patient_tsh);
    plot(patient_t,mean_tsh,color,'MarkerSize',20);
    hold on;
    errorbar(patient_t,mean_tsh,tsh_std,'LineWidth',2.0,'Color',Color)
end