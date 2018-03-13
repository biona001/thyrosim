%--------------------------------------------------
% FILE:         thyrosim_oral_repeat.m
% AUTHOR:       Simon X. Han
% DESCRIPTION:
%   THYROSIM stand alone MATLAB version, with added ability to give a
%   repeating oral dose.
%
%   This script is a wrapper around the thyrosim_core solver. It takes the
%   end values of the previous run and set them as the initial conditions
%   of the current run plus adjustments in dosing, if any. You must
%   manually setup the conditions each run. See PARAMETERS.
% PARAMETERS:
%   Parameters are defined under "define" function.
%   tspans: the tspan (in hours) of each run
%   T4doses: in mols. Each element corresponds to a run.
%   T3doses: in mols. Each element corresponds to a run.
%
%   THYROSIM implmentation based on:
%   All-Condition Thyroid Simulator Eqns 2015-06-29.pdf
% RUN:          >> thyrosim_oral_repeat
%-------------------------------------------------- 

% Main - wrapper for oral doses
function [return_t4,return_t3,return_tsh] = thyrosim_oral_repeat_original(fitting_index,current_iter,patient,T4_init, T3_init, Tsh_init, dose)

% Initialize
[ic,dial] = init(patient, T4_init, T3_init, Tsh_init);
[tspans,T4doses,T3doses] = define();
T3doses(1) = dose; %change to correct dose
inf1 = 0; % For oral doses, infs are 0
inf4 = 0; % For oral doses, infs are 0

% Some needed vars
t_last = 0;
T4max = 0;
T3max = 0;
TSHmax = 0;
t4_values = zeros(1, 17);% list of T4 values at start of each hour
t3_values = zeros(1, 17);% list of T3 values at start of each hour
tsh_values = zeros(1, 17);% list of Tsh values at start of each hour

% Run simulation for each defined run
for i=1:length(tspans)
    
    ic = updateIC(ic,T4doses(i),T3doses(i)); % Add drugs, if any
    [t,q] = thyrosim_core_original(ic,dial,inf1,inf4,tspans(i,:),fitting_index,current_iter,patient); % Run simulation
    ic = q(end,:); % Set this run's values as IC for next run

    % Graph results and update values for next run
    t = t + t_last;
    graph(t,q);
    t_last = t(end);
    
    %record t4/t3/tsh at the end of each 30 minutes
    t4_values(i) = q(1,1);
    t3_values(i) = q(1,4);
    tsh_values(i) = q(1,7);
        
    if max(q(:,1)) > T4max
        T4max = max(q(:,1));
    end
    if max(q(:,4)) > T3max
        T3max = max(q(:,4));
    end
    if max(q(:,7)) > TSHmax
        TSHmax = max(q(:,7));
    end
end
graphFin(T4max,T3max,TSHmax);

[return_t4, return_t3, return_tsh] = t3_tsh_grabber(t,q, t4_values, t3_values, tsh_values);

end

% Define run conditions.
% The default here is as follows:
% Total run time: 5 days.
% T4 dosing: 400 mcg daily starting at day 1.
% T3 dosing: none.
function [tspans,T4doses,T3doses] = define()

% Define each tspan and each tspan's T4/T3 doses (in mols)
tspans = [
    0, 5/12; %25 minutes instead of 30
    0, 0.5;
    0, 0.5;
    0, 0.5;    
    0, 0.5;
    0, 0.5;    
    0, 0.5;
    0, 0.5;
    0, 0.5;
    0, 0.5;
    0, 0.5;
    0, 0.5;
    0, 0.5;
    0, 0.5;
    0, 0.5;
    0, 0.5; % 8 hours
];

T4doses = [ %in units of moles
    0;
    0;
    0;
    0;
    0;
    0;
    0; 
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0; 
    %0;
    %0;
    %0;
    %0;
    %0; 
    %0;
    %0;
    %0;
    %0; 
    %0;
    %0;
];

T3doses = [ %in units of micromoles
    0.0; %will be changed later, because in parameter fitting patients start with different dose
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    0.0;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
    %0.023;
];
end

% Initialize initial conditions and dial values
function [ic,dial] = init(patient, T4_init, T3_init, Tsh_init)

% some patient parameters W, H, sex, age, race
%[Vp_new, Vtsh_new, Vp_ratio, SM_ratio, Vtsh_ratio] = patientParam5(patient, 3.2, 5.2); %just used to calculated initial conditions, so use original Vp and Vtsh
%ic measured in same units as q, which probably is micromol?
ic(1) = T4_init*3.2/777;
ic(2) = 0.201296960359917;
%ic(3) = 0.638967411907560 / SM_ratio;
ic(3) = 0.638967411907560;
ic(4) = T3_init*3.2/651;
ic(5) = 0.0112595761822961;
%ic(6) = 0.0652960640300348 / SM_ratio;
ic(6) = 0.0652960640300348;
ic(7) = Tsh_init*5.2/5.6; %should this be Vtsh or Vp
ic(8) = 7.05727560072869;
ic(9) = 7.05714474742141;
ic(10) = 0;
ic(11) = 0;
ic(12) = 0;
ic(13) = 0;
ic(14) = 3.34289716182018;
ic(15) = 3.69277248068433;
ic(16) = 3.87942133769244;
ic(17) = 3.90061903207543;
ic(18) = 3.77875734283571;
ic(19) = 3.55364471589659;

% [T4 Secretion, T4 Absorption, T3 Secretion, T3 Absorption]
dial = [0, 0.88, 0, 0.88];
end

% Update initial conditions
function [ic] = updateIC(ic,T4dose,T3dose)
ic(11) = ic(11) + T4dose;
ic(13) = ic(13) + T3dose;
end


% Graph results
function graph(t,q)
global p

% Conversion factors
% 777: molecular weight of T4
% 651: molecular weight of T3
% 5.6: (q7 umol)*(28000 mcg/umol)*(0.2 mU/mg)*(1 mg/1000 mcg)
% where 28000 is TSH molecular weight and 0.2 is specific activity
T4conv  = 777/p(47);    % mcg/L
T3conv  = 651/p(47);    % mcg/L
TSHconv = 5.6/p(48);    % mU/L

% Outputs
y1 = q(:,1)*T4conv;     % T4
y2 = q(:,4)*T3conv;     % T3
y3 = q(:,7)*TSHconv;    % TSH
t  = t/24;              % Convert time to days


% General

patient_t = [0, 5/12/24, 1/24, 2/24, 3/24, 4/24, 5/24 ,6/24 ,7/24 ,8/24]; %days
%{
% T4 plot
subplot(3,1,1);
hold on;
plot(t,y1);
%overweight

patient_20_t4 = [3.4 5.7	4	5.5	6.2	4.2	3.7	5	4.1	3.8 ]*10.0;
patient_11_t4 = [0.9 1.1	1.5	1.3	0.9	1.0	1.3	0.5	1.0	0.6]*10.0;
patient_6_t4 = [1.1 3.2	0.5	1.2	0.9	2.4	2.1	2.2	2.3	2.1 ]*10.0;
patient_22_t4 = [1.3 1.6	1.9	2	1.3	0.5	0.5	0.5	0.5	0.5 ]*10.0;
patient_24_t4 = [1.3 0.6	0.7	1.4	1.1	1.5	1.7	0.5	1	0.5 ]*10.0;
patient_5_t4 = [3.1, 3.9	3.6	3.6	3.5	3.5	3.3	3.5	3.1	3.7]*10.0;
plot(patient_t, patient_20_t4, 'green+','MarkerSize',20);
plot(patient_t, patient_11_t4, 'black+','MarkerSize',20);
plot(patient_t, patient_6_t4, 'blue+','MarkerSize',20);
plot(patient_t, patient_22_t4, 'magenta+','MarkerSize',20);
plot(patient_t, patient_24_t4, 'yellow+','MarkerSize',20);
plot(patient_t, patient_5_t4, 'red+', 'MarkerSize',20);
%normal_weight

patient_1_t4 = [7.2 7.2	6.9	7.1	7.6	7.3	7.4	7.2	6.7	6.9]*10.0;
patient_13_t4 = [11.1 10.1	10.9	10.9	10.4	9.4	10.2	10.5	9.8	10.8]*10.0;
patient_31_t4 = [4.9 2.8	3.7	4.7	4.3	4.2	2.6	4.6	4.2	3.6]*10.0;
patient_27_t4 = [1.7 1.6	1.5	3	2.6	0.6	2.4	1.7	3.2	2.3]*10.0;
patient_10_t4 = [1.1 1.6	1.4	1.5	1.5	1.9	1.9	1.3	1.5	1.4]*10.0;
patient_18_t4 = [2.5 2.6	2.7	2.2	2.4	2.7	2.6	3.8	2.7	2.2]*10.0;
patient_19_t4 = [4.7  3.3	2.6	2.4	2.4	1.8	3.1	2.7	2.3	2.4]*10.0;
patient_2_t4 = [8.1 7.4	7.6	7.8	8.3	7.6	6.8	6.7	7.3	7.1]*10.0;    
patient_8_t4 = [3.5 3.6	3.2	3.6	3.7	5.0	3.7	4.1	3.7	4.4 ]*10.0;
plot(patient_t, patient_27_t4, 'red.','MarkerSize',20);
plot(patient_t, patient_1_t4, 'cyan.','MarkerSize',20);
plot(patient_t, patient_13_t4, 'green.','MarkerSize',20);
plot(patient_t, patient_31_t4, 'black.','MarkerSize',20);
plot(patient_t, patient_10_t4, 'blue.','MarkerSize',20);
plot(patient_t, patient_18_t4, 'magenta.','MarkerSize',20);
plot(patient_t, patient_19_t4, 'yellow.','MarkerSize',20);
plot(patient_t, patient_2_t4, 'red*','MarkerSize',20);
plot(patient_t, patient_8_t4, 'cyan*','MarkerSize',20);
%mean_t4_normal = [91.7142857142857,41.7142857142857,42.4285714285714,45.4285714285714,44.5714285714286,39.8571428571429,43.1428571428571,45.4285714285714,43.4285714285714,42.2857142857143];
%mean_t4_fat = [94,24.4000000000000,17.2000000000000,22.8000000000000,20.8000000000000,19.2000000000000,18.6000000000000,17.4000000000000,17.8000000000000,15];
%plot(patient_t, mean_t4_normal, 'red.','MarkerSize',20);
%plot(patient_t, mean_t4_fat, 'cyan.','MarkerSize',20);

% T3 plot
subplot(3,1,2);
hold on;
plot(t,y2);
%overweight

patient_20_t3 = [104 138.3	145.8	189.4	167.8	148.2	128.2	115.5	108.2	102.9 ]/100.0;
patient_11_t3 = [78.3 197.4	353.7	402.0	327.0	308.5	244.6	209.5	181.5	173.1 ]/100.0;
patient_6_t3 = [84.9 101.2	286.0	345.2	272.6	213.7	193.2	161.4	139.9	133.5 ]/100.0;
patient_22_t3 = [103.7 93	291	443.5	394.1	306	255.2	219.9	203.9	161.8 ]/100.0;
patient_24_t3 = [98.6 100.8	198	334.9	314	339.5	255.7	241.8	202.9	174.4 ]/100.0;
patient_5_t3 = [84.3,  85.6	131.8	165.6	162.9	158.5	158.7	128.0	106.7	129.2]/100.0;
plot(patient_t, patient_20_t3, 'green+','MarkerSize',20);
plot(patient_t, patient_11_t3, 'black+','MarkerSize',20);
plot(patient_t, patient_6_t3, 'blue+','MarkerSize',20);
plot(patient_t, patient_22_t3, 'magenta+','MarkerSize',20);
plot(patient_t, patient_24_t3, 'yellow+','MarkerSize',20);
plot(patient_t, patient_5_t3, 'red+','MarkerSize',20);

%normal weight

patient_1_t3 = [97.8 147.0	228.9	220.1	176.5	153.9	125.3	118.8	106.9	91.6]/100.0;
patient_13_t3 = [156.2 248.8	335.8	332.8	292.8	264.6	196.5	224.3	221.3	228.4]/100.0;
patient_31_t3 = [83.6 90.6	133.2	211.8	204.3	178.2	156.5	124	122.6	121]/100.0;
patient_27_t3 = [74.6 89.5	163.6	347.1	334	305.3	263.6	181	180.4	168.7]/100.0;
patient_10_t3 = [59.6 93.8	123.4	173.5	153.9	157.8	165.0	139.1	127.3	116.3]/100.0;
patient_18_t3 = [86.6 108.8	261.4	363.1	302.4	247.6	242.5	204.8	201.1	170.5 ]/100.0;
patient_19_t3 = [75.1  99.1	217.8	273.6	226.4	178.6	155.3	140.2	120	111.5 ]/100.0;
patient_2_t3 = [184.6 205.6	300.2	364.9	361.0	308.1	298.1	258.9	254.9	249.7]/100.0;
patient_8_t3 = [69.4 76.1	99.4	193.0	167.2	156.1	141.7	117.5	128.8	123.2 ]/100.0;
plot(patient_t, patient_27_t3, 'red.','MarkerSize',20);
plot(patient_t, patient_1_t3, 'cyan.','MarkerSize',20);
plot(patient_t, patient_13_t3, 'green.','MarkerSize',20);
plot(patient_t, patient_31_t3, 'black.','MarkerSize',20);
plot(patient_t, patient_10_t3, 'blue.','MarkerSize',20);
plot(patient_t, patient_18_t3, 'magenta.','MarkerSize',20);
plot(patient_t, patient_19_t3, 'yellow.','MarkerSize',20);
plot(patient_t, patient_2_t3, 'red*','MarkerSize',20);
plot(patient_t, patient_8_t3, 'cyan*','MarkerSize',20);

%mean_t3_normal = [1.00357142857143,1.25371428571429,2.09157142857143,2.74571428571429,2.41471428571429,2.12285714285714,1.86385714285714,1.61742857142857,1.54228571428571,1.44000000000000];
%mean_t3_fat = [0.953000000000000,1.26140000000000,2.54900000000000,3.43000000000000,2.95100000000000,2.63180000000000,2.15380000000000,1.89620000000000,1.67280000000000,1.49140000000000];
%plot(patient_t, mean_t3_normal, 'red.','MarkerSize',20);
%plot(patient_t, mean_t3_fat, 'cyan.','MarkerSize',20);

% TSH plot
subplot(3,1,3);
hold on;
plot(t,y3);
%overweight

patient_20_tsh = [1.27 1.3	1.35	1.28	1.12	1.08	1.03	1.1	1.07	1.33 ];
patient_11_tsh = [11.20 12.20	11.50	13.30	10.80	9.56	9.09	8.45	8.63	8.59 ];
patient_6_tsh = [4.22 3.71	4.31	4.27	4.5	3.79	3.66	3.51	3.56	3.5 ];
patient_22_tsh = [0.153 0.126	0.133	0.152	0.128	0.108	0.094	0.084	0.087	0.086];
patient_24_tsh = [2.07 2.05	2.1	1.84	1.99	1.99	2.13	1.92	1.7	1.79];
patient_5_tsh = [12, 12.5	11.6	12.2	12.2	12.9	12.4	12.4	13.1	15.1 ];
plot(patient_t, patient_20_tsh, 'green+','MarkerSize',20);
plot(patient_t, patient_11_tsh, 'black+','MarkerSize',20);
plot(patient_t, patient_6_tsh, 'blue+','MarkerSize',20);
plot(patient_t, patient_22_tsh, 'magenta+','MarkerSize',20);
plot(patient_t, patient_24_tsh, 'yellow+','MarkerSize',20);
plot(patient_t, patient_5_tsh, 'red+','MarkerSize',20);

%normal_weight

patient_1_tsh = [2.42 2.02	1.84	2.00	1.70	1.66	1.46	1.36	2.10	1.99];
patient_13_tsh = [1.80 1.47	1.39	1.49	1.41	1.46	1.36	1.47	1.80	1.88];
patient_31_tsh = [2.45 2.4	2.17	2.23	1.79	1.58	1.53	1.46	1.57	1.92];
patient_27_tsh = [1.52 1.53	1.59	2.04	2.32	1.98	1.53	1.23	1.16	1.11];
patient_10_tsh = [7.21 6.88	7.20	7.29	7.05	7.33	6.84	7.58	7.20	8.10 ];
patient_18_tsh = [4.8 3.87	4.03	3.53	4.22	4.09	3.43	3.31	3.18	3.4 ];
patient_19_tsh = [1.22  1.16	1.03	1.21	1.57	1.34	1.1	1.04	1.08	1.23 ];
patient_2_tsh = [0.57 0.56	0.52	0.48	0.38	0.35	0.33	0.33	0.36	0.38];
patient_8_tsh = [3.40 3.09	3.10	3.02	2.75	2.24	2.46	2.20	1.92	1.79 ];
plot(patient_t, patient_27_tsh, 'red.','MarkerSize',20);
plot(patient_t, patient_1_tsh, 'cyan.','MarkerSize',20);
plot(patient_t, patient_13_tsh, 'green.','MarkerSize',20);
plot(patient_t, patient_31_tsh, 'black.','MarkerSize',20);
plot(patient_t, patient_10_tsh, 'blue.','MarkerSize',20);
plot(patient_t, patient_18_tsh, 'magenta.','MarkerSize',20);
plot(patient_t, patient_19_tsh, 'yellow.','MarkerSize',20);
plot(patient_t, patient_2_tsh, 'red*','MarkerSize',20);
plot(patient_t, patient_8_tsh, 'cyan*','MarkerSize',20);
%mean_tsh_normal = [1.56900000000000,2.76142857142857,2.75000000000000,2.82714285714286,2.86571428571429,2.77714285714286,2.46428571428571,2.49285714285714,2.58428571428571,2.80428571428571];
%mean_tsh_fat = [1.46800000000000,3.87720000000000,3.87860000000000,4.16840000000000,3.70760000000000,3.30560000000000,3.20080000000000,3.01280000000000,3.00940000000000,3.05920000000000];
%plot(patient_t, mean_tsh_normal, 'red.','MarkerSize',20);
%plot(patient_t, mean_tsh_fat, 'cyan.','MarkerSize',20);
%}
end


function graphFin(T4max,T3max,TSHmax)
global p

T4conv  = 777/p(47);    % mcg/L
T3conv  = 651/p(47);    % mcg/L
TSHconv = 5.6/p(48);    % mU/L

% Outputs
p1max = T4max*T4conv;     % T4
p2max = T3max*T3conv;     % T3
p3max = TSHmax*TSHconv;    % TSH

%{
% T4 plot
subplot(3,1,1);
ylabel('T4 mcg/L');
ylim([0 p1max*2]);
%hline = refline(0,66); %slope, intercept
%hline2 = refline(0,114); %slope, intercept
%hline.Color='g';
%hline2.Color='g';
set(gca,'fontsize',18)


% T3 plot
subplot(3,1,2);
ylabel('T3 mcg/L');
ylim([0 p2max*2]);
%hline = refline(0,0.79); %slope, intercept
%hline2 = refline(0,1.18); %slope, intercept
%hline.Color='g';
%hline2.Color='g';
set(gca,'fontsize',18)


% TSH plot
subplot(3,1,3);
ylabel('TSH mU/L');
ylim([0 5]);
xlabel('Days');
%hline = refline(0,0.4); %slope, intercept
%hline2 = refline(0,3.77); %slope, intercept
%hline.Color='g';
%hline2.Color='g';
set(gca,'fontsize',18)
%}
end

function [t4_values,t3_values,tsh_values] = t3_tsh_grabber(t,q,t4_values,t3_values,tsh_values)
global p

T4conv  = 777/p(47);    % mcg/L
T3conv  = 651/p(47);    % mcg/L
TSHconv = 5.6/p(48);    % mU/L

t4_values(17) = q(end,1);
t4_values = t4_values*T4conv;

t3_values(17) = q(end,4);
t3_values = t3_values*T3conv;

tsh_values(17) = q(end,7);
tsh_values = tsh_values*TSHconv;
end