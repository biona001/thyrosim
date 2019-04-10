function plot_individual_patients_jonklaas()
    %specify time of dosage and import data
    patient_t = [0, 5/12/24, 1/24, 2/24, 3/24, 4/24, 5/24 ,6/24 ,7/24 ,8/24]; %days
    [patient_param, patient_t4, patient_t3, patient_tsh, t4_std, t3_std, tsh_std] = data_test2();
    dose = [0.046 0.046 0.069 0.069 0.046 0.046 0.069 0.046 0.046 0.046 0.069 0.069 0.069 0.069 0.046];
    
    for i=1:size(patient_t4, 1)
        %some needed variables that plots simulation result
        [total_time, total_q] = simulate(patient_param(i, 1:3), patient_t4(i, 1), patient_t3(i, 1), patient_tsh(i, 1), dose(i));
        T4max = max(total_q(:,1));
        T3max = max(total_q(:,4));
        TSHmax = max(total_q(:,7));

        %some needed conversion factors
        [Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(patient_param(i, 1:3), 3.2, 5.2)
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
        saveas(myfig, ['./individual_plots/', num2str(i), '.png'])
        clf('reset')
    end 
end

function group_plots()

    if strcmp(plot_group, 'overweight30')
        title({'Overweight patients with 30 mcg T3 oral dose, 2 patients'});

        patient_20_t4 = [3.4 5.7	4	5.5	6.2	4.2	3.7	5	4.1	3.8 ]*10.0;
        patient_5_t4 = [3.1, 3.9	3.6	3.6	3.5	3.5	3.3	3.5	3.1	3.7]*10.0;
        patient_t4 = [patient_20_t4;patient_5_t4];
        %plot(patient_t, patient_20_t4, 'green+','MarkerSize',20);
        %plot(patient_t, patient_5_t4, 'red+', 'MarkerSize',20);

        patient_20_t3 = [104 138.3	145.8	189.4	167.8	148.2	128.2	115.5	108.2	102.9 ]/100.0;
        patient_5_t3 = [84.3,  85.6	131.8	165.6	162.9	158.5	158.7	128.0	106.7	129.2]/100.0;
        patient_t3 = [patient_20_t3;patient_5_t3];
        %plot(patient_t, patient_20_t3, 'green+','MarkerSize',20);
        %plot(patient_t, patient_5_t3, 'red+','MarkerSize',20);

        patient_20_tsh = [1.27 1.3	1.35	1.28	1.12	1.08	1.03	1.1	1.07	1.33 ];
        patient_5_tsh = [12, 12.5	11.6	12.2	12.2	12.9	12.4	12.4	13.1	15.1 ];
        patient_tsh = [patient_20_tsh;patient_5_tsh];
        %plot(patient_t, patient_20_tsh, 'green+','MarkerSize',20);
        %plot(patient_t, patient_5_tsh, 'red+','MarkerSize',20);
    end

    if strcmp(plot_group, 'overweight45')
        title({'Overweight patients with 45 mcg T3 oral dose, 4 patients'});

        patient_11_t4 = [0.9 1.1	1.5	1.3	0.9	1.0	1.3	0.5	1.0	0.6]*10.0;
        patient_6_t4 = [1.1 3.2	0.5	1.2	0.9	2.4	2.1	2.2	2.3	2.1 ]*10.0;
        patient_22_t4 = [1.3 1.6	1.9	2	1.3	0.5	0.5	0.5	0.5	0.5 ]*10.0;
        patient_24_t4 = [1.3 0.6	0.7	1.4	1.1	1.5	1.7	0.5	1	0.5 ]*10.0;
        patient_t4 = [patient_11_t4;patient_6_t4;patient_22_t4;patient_24_t4];
        %plot(patient_t, patient_11_t4, 'black+','MarkerSize',20);
        %plot(patient_t, patient_6_t4, 'blue+','MarkerSize',20);
        %plot(patient_t, patient_22_t4, 'magenta+','MarkerSize',20);
        %plot(patient_t, patient_24_t4, 'yellow+','MarkerSize',20);

        patient_11_t3 = [78.3 197.4	353.7	402.0	327.0	308.5	244.6	209.5	181.5	173.1 ]/100.0;
        patient_6_t3 = [84.9 101.2	286.0	345.2	272.6	213.7	193.2	161.4	139.9	133.5 ]/100.0;
        patient_22_t3 = [103.7 93	291	443.5	394.1	306	255.2	219.9	203.9	161.8 ]/100.0;
        patient_24_t3 = [98.6 100.8	198	334.9	314	339.5	255.7	241.8	202.9	174.4 ]/100.0;
        patient_t3 = [patient_11_t3;patient_6_t3;patient_22_t3;patient_24_t3];
        %plot(patient_t, patient_11_t3, 'black+','MarkerSize',20);
        %plot(patient_t, patient_6_t3, 'blue+','MarkerSize',20);
        %plot(patient_t, patient_22_t3, 'magenta+','MarkerSize',20);
        %plot(patient_t, patient_24_t3, 'yellow+','MarkerSize',20);

        patient_11_tsh = [11.20 12.20	11.50	13.30	10.80	9.56	9.09	8.45	8.63	8.59 ];
        patient_6_tsh = [4.22 3.71	4.31	4.27	4.5	3.79	3.66	3.51	3.56	3.5 ];
        patient_22_tsh = [0.153 0.126	0.133	0.152	0.128	0.108	0.094	0.084	0.087	0.086];
        patient_24_tsh = [2.07 2.05	2.1	1.84	1.99	1.99	2.13	1.92	1.7	1.79];
        patient_tsh = [patient_11_tsh;patient_6_tsh;patient_22_tsh;patient_24_tsh];
        %plot(patient_t, patient_11_tsh, 'black+','MarkerSize',20);
        %plot(patient_t, patient_6_tsh, 'blue+','MarkerSize',20);
        %plot(patient_t, patient_22_tsh, 'magenta+','MarkerSize',20);
        %plot(patient_t, patient_24_tsh, 'yellow+','MarkerSize',20);
    end

    if strcmp(plot_group, 'normal45')
        title({'Normal weight patients with 45 mcg T3 oral dose, 3 patients'});

        patient_27_t4 = [1.7 1.6	1.5	3	2.6	0.6	2.4	1.7	3.2	2.3]*10.0;
        patient_10_t4 = [1.1 1.6	1.4	1.5	1.5	1.9	1.9	1.3	1.5	1.4]*10.0;
        patient_18_t4 = [2.5 2.6	2.7	2.2	2.4	2.7	2.6	3.8	2.7	2.2]*10.0;
        patient_t4 = [patient_10_t4;patient_18_t4;patient_27_t4];
        %plot(patient_t, patient_27_t4, 'red.','MarkerSize',20);
        %plot(patient_t, patient_10_t4, 'blue.','MarkerSize',20);
        %plot(patient_t, patient_18_t4, 'magenta.','MarkerSize',20);

        patient_27_t3 = [74.6 89.5	163.6	347.1	334	305.3	263.6	181	180.4	168.7]/100.0;
        patient_10_t3 = [59.6 93.8	123.4	173.5	153.9	157.8	165.0	139.1	127.3	116.3]/100.0;
        patient_18_t3 = [86.6 108.8	261.4	363.1	302.4	247.6	242.5	204.8	201.1	170.5 ]/100.0;
        patient_t3 = [patient_10_t3;patient_18_t3;patient_27_t3];
        %plot(patient_t, patient_27_t3, 'red.','MarkerSize',20);
        %plot(patient_t, patient_10_t3, 'blue.','MarkerSize',20);
        %plot(patient_t, patient_18_t3, 'magenta.','MarkerSize',20);

        patient_27_tsh = [1.52 1.53	1.59	2.04	2.32	1.98	1.53	1.23	1.16	1.11];
        patient_10_tsh = [7.21 6.88	7.20	7.29	7.05	7.33	6.84	7.58	7.20	8.10 ];
        patient_18_tsh = [4.8 3.87	4.03	3.53	4.22	4.09	3.43	3.31	3.18	3.4 ];
        patient_tsh = [patient_10_tsh;patient_18_tsh;patient_27_tsh];
        %plot(patient_t, patient_10_tsh, 'blue.','MarkerSize',20);
        %plot(patient_t, patient_18_tsh, 'magenta.','MarkerSize',20);
        %plot(patient_t, patient_27_tsh, 'red.','MarkerSize',20);

    end

    if strcmp(plot_group, 'normal30')
        title({'Normal weight patients with 30 mcg T3 oral dose, 6 patients'});

        patient_1_t4 = [7.2 7.2	6.9	7.1	7.6	7.3	7.4	7.2	6.7	6.9]*10.0;
        patient_13_t4 = [11.1 10.1	10.9	10.9	10.4	9.4	10.2	10.5	9.8	10.8]*10.0;
        patient_31_t4 = [4.9 2.8	3.7	4.7	4.3	4.2	2.6	4.6	4.2	3.6]*10.0;
        patient_19_t4 = [4.7  3.3	2.6	2.4	2.4	1.8	3.1	2.7	2.3	2.4]*10.0;
        patient_2_t4 = [8.1 7.4	7.6	7.8	8.3	7.6	6.8	6.7	7.3	7.1]*10.0;    
        patient_8_t4 = [3.5 3.6	3.2	3.6	3.7	5.0	3.7	4.1	3.7	4.4 ]*10.0;
        patient_t4 = [patient_1_t4;patient_13_t4;patient_19_t4;patient_31_t4;patient_2_t4;patient_8_t4];
        %plot(patient_t, patient_1_t4, 'cyan.','MarkerSize',20);
        %plot(patient_t, patient_13_t4, 'green.','MarkerSize',20);
        %plot(patient_t, patient_31_t4, 'black.','MarkerSize',20);
        %plot(patient_t, patient_19_t4, 'yellow.','MarkerSize',20);
        %plot(patient_t, patient_2_t4, 'red*','MarkerSize',20);
        %plot(patient_t, patient_8_t4, 'cyan*','MarkerSize',20);

        patient_1_t3 = [97.8 147.0	228.9	220.1	176.5	153.9	125.3	118.8	106.9	91.6]/100.0;
        patient_13_t3 = [156.2 248.8	335.8	332.8	292.8	264.6	196.5	224.3	221.3	228.4]/100.0;
        patient_31_t3 = [83.6 90.6	133.2	211.8	204.3	178.2	156.5	124	122.6	121]/100.0;
        patient_19_t3 = [75.1  99.1	217.8	273.6	226.4	178.6	155.3	140.2	120	111.5 ]/100.0;
        patient_2_t3 = [184.6 205.6	300.2	364.9	361.0	308.1	298.1	258.9	254.9	249.7]/100.0;
        patient_8_t3 = [69.4 76.1	99.4	193.0	167.2	156.1	141.7	117.5	128.8	123.2 ]/100.0;
        patient_t3 = [patient_1_t3;patient_13_t3;patient_19_t3;patient_31_t3;patient_2_t3;patient_8_t3];
        %plot(patient_t, patient_1_t3, 'cyan.','MarkerSize',20);
        %plot(patient_t, patient_13_t3, 'green.','MarkerSize',20);
        %plot(patient_t, patient_31_t3, 'black.','MarkerSize',20);
        %plot(patient_t, patient_19_t3, 'yellow.','MarkerSize',20);
        %plot(patient_t, patient_2_t3, 'red*','MarkerSize',20);
        %plot(patient_t, patient_8_t3, 'cyan*','MarkerSize',20);

        patient_1_tsh = [2.42 2.02	1.84	2.00	1.70	1.66	1.46	1.36	2.10	1.99];
        patient_13_tsh = [1.80 1.47	1.39	1.49	1.41	1.46	1.36	1.47	1.80	1.88];
        patient_31_tsh = [2.45 2.4	2.17	2.23	1.79	1.58	1.53	1.46	1.57	1.92];
        patient_19_tsh = [1.22  1.16	1.03	1.21	1.57	1.34	1.1	1.04	1.08	1.23 ];
        patient_2_tsh = [0.57 0.56	0.52	0.48	0.38	0.35	0.33	0.33	0.36	0.38];
        patient_8_tsh = [3.40 3.09	3.10	3.02	2.75	2.24	2.46	2.20	1.92	1.79 ];
        patient_tsh = [patient_1_tsh;patient_13_tsh;patient_19_tsh;patient_31_tsh;patient_2_tsh;patient_8_tsh];
        %plot(patient_t, patient_1_tsh, 'cyan.','MarkerSize',20);
        %plot(patient_t, patient_13_tsh, 'green.','MarkerSize',20);
        %plot(patient_t, patient_31_tsh, 'black.','MarkerSize',20);
        %plot(patient_t, patient_19_tsh, 'yellow.','MarkerSize',20);
        %plot(patient_t, patient_2_tsh, 'red*','MarkerSize',20);
        %plot(patient_t, patient_8_tsh, 'cyan*','MarkerSize',20);
    end

    %{
    mean_t4 = mean(patient_t4);
    t4_std = std(patient_t4);
    plot(patient_t,mean_t4,color,'MarkerSize',20);
    hold on;
    errorbar(patient_t,mean_t4,t4_std,'LineWidth',2.0,'Color',Color)

    mean_t3 = mean(patient_t3);
    t3_std = std(patient_t3);
    plot(patient_t,mean_t3,color,'MarkerSize',20);
    hold on;
    errorbar(patient_t,mean_t3,t3_std,'LineWidth',2.0,'Color',Color)

    mean_tsh = mean(patient_tsh);
    tsh_std = std(patient_tsh);
    plot(patient_t,mean_tsh,color,'MarkerSize',20);
    hold on;
    errorbar(patient_t,mean_tsh,tsh_std,'LineWidth',2.0,'Color',Color)
    %}
end