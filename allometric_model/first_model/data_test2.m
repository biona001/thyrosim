function [patient_param, patient_t4, patient_t3, patient_tsh, t4_std, t3_std, tsh_std] = data_test2()
    % real patient data from Jonklaas 2016
    % patient parameters = H, W, sex, age, race
    % the last point is measured at the end of the week; every other point
    % was in the first 8 hours.
    
    patient_5_param = [1.645, 81.9, 0, 25, 0];
    patient_5_t4 = [3.1, 3.9 3.6	3.6	3.5	3.5	3.3	3.5	3.1	3.7]*10.0;
    patient_5_t3 = [84.3,  85.6	131.8	165.6	162.9	158.5	158.7	128.0	106.7	129.2]/100.0;
    patient_5_tsh = [12, 12.5	11.6	12.2	12.2	12.9	12.4	12.4	13.1	15.1 ];

    patient_1_param = [1.831, 94.7, 1, 43, 0];
    patient_1_t4 = [7.2 7.2	6.9	7.1	7.6	7.3	7.4	7.2	6.7	6.9]*10.0;    
    patient_1_t3 = [97.8 147.0	228.9	220.1	176.5	153.9	125.3	118.8	106.9	91.6 ]/100.0;
    patient_1_tsh = [2.42 2.02	1.84	2.00	1.70	1.66	1.46	1.36	2.10	1.99 ];

    patient_2_param = [1.731, 65, 0, 24, 0];
    patient_2_t4 = [8.1 7.4	7.6	7.8	8.3	7.6	6.8	6.7	7.3	7.1]*10.0;    
    patient_2_t3 = [184.6 205.6	300.2	364.9	361.0	308.1	298.1	258.9	254.9	249.7]/100.0;
    patient_2_tsh = [0.57 0.56	0.52	0.48	0.38	0.35	0.33	0.33	0.36	0.38];
    
    patient_8_param = [1.59, 55.5, 0, 35, 0];
    patient_8_t4 = [3.5 3.6	3.2	3.6	3.7	5.0	3.7	4.1	3.7	4.4 ]*10.0;
    patient_8_t3 = [69.4 76.1	99.4	193.0	167.2	156.1	141.7	117.5	128.8	123.2 ]/100.0;
    patient_8_tsh = [3.40 3.09	3.10	3.02	2.75	2.24	2.46	2.20	1.92	1.79 ];
    
    patient_13_param = [1.618, 68.3, 0, 50, 0];
    patient_13_t4 = [11.1 10.1	10.9	10.9	10.4	9.4	10.2	10.5	9.8	10.8 ]*10.0;
    patient_13_t3 = [156.2 248.8	335.8	332.8	292.8	264.6	196.5	224.3	221.3	228.4]/100.0;
    patient_13_tsh = [1.80 1.47	1.39	1.49	1.41	1.46	1.36	1.47	1.80	1.88 ];

    patient_10_param = [1.76, 81, 0, 45, 0];
    patient_10_t4 = [1.1   1.6	1.4	1.5	1.5	1.9	1.9	1.3	1.5	1.4]*10.0;
    patient_10_t3 = [59.6 93.8	123.4	173.5	153.9	157.8	165.0	139.1	127.3	116.3]/100.0;
    patient_10_tsh = [7.21 6.88	7.20	7.29	7.05	7.33	6.84	7.58	7.20	8.10 ];
    
    patient_20_param = [1.64, 131.2, 0, 32, 1.1];
    patient_20_t4 = [3.4 5.7	4	5.5	6.2	4.2	3.7	5	4.1	3.8 ]*10.0;
    patient_20_t3 = [104 138.3	145.8	189.4	167.8	148.2	128.2	115.5	108.2	102.9 ]/100.0;
    patient_20_tsh = [1.27 1.3	1.35	1.28	1.12	1.08	1.03	1.1	1.07	1.33 ];

    patient_11_param = [1.374, 66.5, 0, 56, 1.1];
    patient_11_t4 = [0.9 1.1	1.5	1.3	0.9	1.0	1.3	0.5	1.0	0.6]*10.0;
    patient_11_t3 = [78.3 197.4	353.7	402.0	327.0	308.5	244.6	209.5	181.5	173.1 ]/100.0;
    patient_11_tsh = [11.20 12.20	11.50	13.30	10.80	9.56	9.09	8.45	8.63	8.59 ];

    patient_6_param = [1.55, 79.6, 0, 31, 0];
    patient_6_t4 = [1.1 3.2	0.5	1.2	0.9	2.4	2.1	2.2	2.3	2.1 ]*10.0;
    patient_6_t3 = [84.9 101.2	286.0	345.2	272.6	213.7	193.2	161.4	139.9	133.5 ]/100.0;
    patient_6_tsh = [4.22 3.71	4.31	4.27	4.5	3.79	3.66	3.51	3.56	3.5 ];
    
    patient_18_param = [1.663, 78.9, 0, 40, 0];
    patient_18_t3 = [86.6 108.8	261.4	363.1	302.4	247.6	242.5	204.8	201.1	170.5 ]/100.0;
    patient_18_t4 = [2.5  2.6	2.7	2.2	2.4	2.7	2.6	3.8	2.7	2.2 ]*10.0;
    patient_18_tsh = [4.8 3.87	4.03	3.53	4.22	4.09	3.43	3.31	3.18	3.4 ];

    patient_19_param = [1.658, 69.2, 0, 41, 0];
    patient_19_t3 = [75.1  99.1	217.8	273.6	226.4	178.6	155.3	140.2	120	111.5 ]/100.0;
    patient_19_t4 = [4.7  3.3	2.6	2.4	2.4	1.8	3.1	2.7	2.3	2.4 ]*10.0;
    patient_19_tsh = [1.22  1.16	1.03	1.21	1.57	1.34	1.1	1.04	1.08	1.23 ];
    
    patient_22_param = [1.725, 100.2, 0, 24, 0];
    patient_22_t3 = [103.7 93	291	443.5	394.1	306	255.2	219.9	203.9	161.8 ]/100.0;
    patient_22_t4 = [1.3 1.6	1.9	2	1.3	0.5	0.5	0.5	0.5	0.5 ]*10.0;
    patient_22_tsh = [0.153 0.126	0.133	0.152	0.128	0.108	0.094	0.084	0.087	0.086];

    patient_21_param = [1.642, 88.3, 0, 35, 0];
    patient_21_t3 = [124.8 125.8	120.7	120.5	141.0	178.8	331.1	398.7	411.3	362.3 ]/100.0;
    patient_21_t4 = [7.9 7.2	7.6	6.9	5.7	6.7	5.9	6.4	6.1	7.1 ]*10.0;
    patient_21_tsh = [3.93 3.78	3.33	3.32	3.75	3.77	2.78	2.12	1.99	2.17 ];

    patient_24_param = [1.658, 119, 0, 47, 0];
    patient_24_t3 = [98.6 100.8	198	334.9	314	339.5	255.7	241.8	202.9	174.4 ]/100.0;
    patient_24_t4 = [1.3 0.6	0.7	1.4	1.1	1.5	1.7	0.5	1	0.5 ]*10.0;
    patient_24_tsh = [2.07 2.05	2.1	1.84	1.99	1.99	2.13	1.92	1.7	1.79];

    patient_26_param = [1.654, 52.8, 0, 47, 0];
    patient_26_t3 = [104.8 353.7	636.7	731	448.6	354.9	345.9	305.5	271.5	247.5 ];
    patient_26_t4 = [1.3 0.5	0.7	1.4	0.5	0.5	3.5	0.5	0.5	0.5];
    patient_26_tsh = [0.038 0.037	0.037	0.034	0.026	0.026	0.03	0.029	0.028	0.024];
    
    patient_25_param = [1.839, 96.9, 1, 59, 2];
    patient_25_t3 = [59.6 49.9	46.5	57.6	112.8	207.2	232.9	220	182.6	168.1 ]/100.0;
    patient_25_t4 = [0.5 1.3	0.5	1.7	2.1	1.9	0.6	0.5	1.1	0.7 ]*10.0;
    patient_25_tsh = [8.93 8.22	8.03	8.46	6.61	5.06	4.76	4.03	2.89	3.55 ];

    patient_31_param = [1.675, 68.3, 0, 50, 0];
    patient_31_t3 = [83.6 90.6	133.2	211.8	204.3	178.2	156.5	124	122.6	121 ]/100.0;
    patient_31_t4 = [4.9 2.8	3.7	4.7	4.3	4.2	2.6	4.6	4.2	3.6]*10.0;
    patient_31_tsh = [2.45 2.4	2.17	2.23	1.79	1.58	1.53	1.46	1.57	1.92 ];

    patient_27_param = [1.697, 76.2, 0, 36, 0];
    patient_27_t3 = [74.6 89.5	163.6	347.1	334	305.3	263.6	181	180.4	168.7 ]/100.0;
    patient_27_t4 = [1.7 1.6	1.5	3	2.6	0.6	2.4	1.7	3.2	2.3]*10.0;
    patient_27_tsh = [1.52 1.53	1.59	2.04	2.32	1.98	1.53	1.23	1.16	1.11];
    
    %all 18 patients
    %patient_param = [patient_5_param; patient_1_param; patient_2_param; patient_8_param; patient_13_param; patient_10_param; patient_20_param; patient_11_param; patient_6_param;patient_18_param;patient_19_param;patient_22_param;patient_21_param;patient_24_param;patient_26_param;patient_25_param;patient_31_param;patient_27_param];
    %patient_t4 = [patient_5_t4; patient_1_t4; patient_2_t4; patient_8_t4; patient_13_t4; patient_10_t4; patient_20_t4; patient_11_t4; patient_6_t4;patient_18_t4;patient_19_t4;patient_22_t4;patient_21_t4;patient_24_t4;patient_26_t4;patient_25_t4;patient_31_t4;patient_27_t4];
    %patient_t3 = [patient_5_t3; patient_1_t3; patient_2_t3; patient_8_t3; patient_13_t3; patient_10_t3; patient_20_t3; patient_11_t3; patient_6_t3;patient_18_t3;patient_19_t3;patient_22_t3;patient_21_t3;patient_24_t3;patient_26_t4;patient_25_t3;patient_31_t3;patient_27_t3];
    %patient_tsh = [patient_5_tsh; patient_1_tsh; patient_2_tsh; patient_8_tsh; patient_13_tsh; patient_10_tsh; patient_20_tsh; patient_11_tsh; patient_6_tsh;patient_18_tsh;patient_19_tsh;patient_22_tsh;patient_21_tsh;patient_24_tsh;patient_26_tsh;patient_25_tsh;patient_31_tsh;patient_27_tsh];
    
    %9 normal weight patients 
    %{
    patient_param = [patient_1_param;patient_13_param;patient_10_param;patient_18_param;patient_19_param;patient_31_param;patient_27_param;patient_2_param;patient_8_param];
    patient_t4 = [patient_1_t4;patient_13_t4;patient_10_t4;patient_18_t4;patient_19_t4;patient_31_t4;patient_27_t4;patient_2_t4;patient_8_t4];
    patient_t3 = [patient_1_t3;patient_13_t3;patient_10_t3;patient_18_t3;patient_19_t3;patient_31_t3;patient_27_t3;patient_2_t3;patient_8_t3];
    patient_tsh = [patient_1_tsh;patient_13_tsh;patient_10_tsh;patient_18_tsh;patient_19_tsh;patient_31_tsh;patient_27_tsh;patient_2_tsh;patient_8_tsh];
    %}
    
    %normal weight patient 45 mcg (3 patient)
    %{
    patient_param = [patient_10_param;patient_18_param;patient_27_param];
    patient_t4 = [patient_10_t4;patient_18_t4;patient_27_t4];
    patient_t3 = [patient_10_t3;patient_18_t3;patient_27_t3];
    patient_tsh = [patient_10_tsh;patient_18_tsh;patient_27_tsh];
    %}
    
    %normal weight patient 30 mcg (6 patient)
    %{
    patient_param = [patient_1_param;patient_13_param;patient_19_param;patient_31_param;patient_2_param;patient_8_param];
    patient_t4 = [patient_1_t4;patient_13_t4;patient_19_t4;patient_31_t4;patient_2_t4;patient_8_t4];
    patient_t3 = [patient_1_t3;patient_13_t3;patient_19_t3;patient_31_t3;patient_2_t3;patient_8_t3];
    patient_tsh = [patient_1_tsh;patient_13_tsh;patient_19_tsh;patient_31_tsh;patient_2_tsh;patient_8_tsh];
    %}
   
    %overweight patient 45mcg (4 patient)
    %{
    patient_param = [patient_11_param;patient_6_param;patient_22_param;patient_24_param];
    patient_t4 = [patient_11_t4;patient_6_t4;patient_22_t4;patient_24_t4];
    patient_t3 = [patient_11_t3;patient_6_t3;patient_22_t3;patient_24_t3];
    patient_tsh = [patient_11_tsh;patient_6_tsh;patient_22_tsh;patient_24_tsh];
    %}
    
    %overweight patient 30mcg (2 patient)
    %{
    patient_param = [patient_20_param;patient_5_param];
    patient_t4 = [patient_20_t4;patient_5_t4];
    patient_t3 = [patient_20_t3;patient_5_t3];
    patient_tsh = [patient_20_tsh;patient_5_tsh];
    %}
    
    %all 6 overweight patients 
    %{
    patient_param = [patient_20_param;patient_11_param;patient_6_param;patient_22_param;patient_24_param;patient_5_param];
    patient_t4 = [patient_20_t4;patient_11_t4;patient_6_t4;patient_22_t4;patient_24_t4;patient_5_t4];
    patient_t3 = [patient_20_t3;patient_11_t3;patient_6_t3;patient_22_t3;patient_24_t3;patient_5_t3];
    patient_tsh = [patient_20_tsh;patient_11_tsh;patient_6_tsh;patient_22_tsh;patient_24_tsh;patient_5_tsh];
    %}
    
    %normal + overweight (15 total) patients together
    
    patient_param = [patient_1_param;patient_13_param;patient_10_param;patient_18_param;patient_19_param;patient_31_param;patient_27_param;patient_2_param;patient_8_param;patient_20_param;patient_11_param;patient_6_param;patient_22_param;patient_24_param;patient_5_param];
    patient_t4 = [patient_1_t4;patient_13_t4;patient_10_t4;patient_18_t4;patient_19_t4;patient_31_t4;patient_27_t4;patient_2_t4;patient_8_t4;patient_20_t4;patient_11_t4;patient_6_t4;patient_22_t4;patient_24_t4;patient_5_t4];
    patient_t3 = [patient_1_t3;patient_13_t3;patient_10_t3;patient_18_t3;patient_19_t3;patient_31_t3;patient_27_t3;patient_2_t3;patient_8_t3;patient_20_t3;patient_11_t3;patient_6_t3;patient_22_t3;patient_24_t3;patient_5_t3];
    patient_tsh = [patient_1_tsh;patient_13_tsh;patient_10_tsh;patient_18_tsh;patient_19_tsh;patient_31_tsh;patient_27_tsh;patient_2_tsh;patient_8_tsh;patient_20_tsh;patient_11_tsh;patient_6_tsh;patient_22_tsh;patient_24_tsh;patient_5_tsh];
    
    %1 fat and 1 normal
    %{
    patient_param = [patient_20_param;patient_27_param];
    patient_t4 = [patient_20_t4;patient_27_t4];
    patient_t3 = [patient_20_t3;patient_27_t3];
    patient_tsh = [patient_20_tsh;patient_27_tsh];
    %}
    
    %1 normal
    %{
    patient_param = [patient_27_param];
    patient_t4 = [patient_27_t4];
    patient_t3 = [patient_27_t3];
    patient_tsh = [patient_27_tsh];
    %}
    
    t3_std = std(patient_t3);
    t4_std = std(patient_t4);
    tsh_std = std(patient_tsh);
end
