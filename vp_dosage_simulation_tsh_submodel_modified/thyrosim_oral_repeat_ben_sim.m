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
function [return_t4,return_t3,return_tsh] = thyrosim_oral_repeat_ben_sim(patient, T4_init, T3_init, Tsh_init, t_unit, tspans, T4doses, T3doses)

% Initialize
[ic,dial] = init(patient, T4_init, T3_init, Tsh_init);
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
total_time = [];
total_q = [];
for i=1:length(tspans)    
    ic = updateIC(ic,T4doses(i),T3doses(i)); % Add drugs, if any
    phase = mod(t_last, 24); 
    [t,q] = thyrosim_core_ben_sim(ic,dial,inf1,inf4,tspans(i,:),patient,phase); % Run simulation
    ic = q(end,:); % Set this run's values as IC for next run

    % Graph results and update values for next run
    %{
    t = t + t_last;
    graph(t,q);
    t_last = t(end);
    %}
    
    t = t + t_last;
    total_time = [total_time; t(2:end)];
    total_q = [total_q; q(2:end, :)];
    t_last = t(end);
    
    %record t4/t3/tsh at the end of each simulation segment
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
graph(total_time,total_q);
graphFin(T4max,T3max,TSHmax);

[return_t4, return_t3, return_tsh] = t3_tsh_grabber(t,q, t4_values, t3_values, tsh_values);

end

% Initialize initial conditions and dial values
function [ic,dial] = init(patient, T4_init, T3_init, Tsh_init)

% some patient parameters W, H, sex
[Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(patient, 3.2, 5.2); %just used to calculated initial conditions, so use original Vp and Vtsh
%ic measured in same units as q, which probably is micromol?

% [T4 Secretion, T4 Absorption, T3 Secretion, T3 Absorption]
dial = [1.0, 0.88, 1.0, 0.88];

% calling this function to get the p values to get correct initial
% conditions in q2, q3, q5, q6
[p, d] = return_parameters(dial);

%new initial conditions by solving quasi steady state
q1 = T4_init*Vp_new/777;
q4 = T3_init*Vp_new/651;
q7 = Tsh_init*Vtsh_new/5.6;
FT3p = (p(24)+p(25)*q1+p(26)*q1^2+p(27)*q1^3)*q4;
FT4p = (p(7)+p(8)*q1+p(9)*q1^2+p(10)*q1^3)*q1;

ic(1) = q1;
%ic(2) = 0.201296960359917;
ic(2) = (p(6)*FT4p) / (p(3)+p(12)+(p(13)/p(14))); 
%ic(3) = 0.638967411907560;
ic(3) = (p(5)*FT4p - p(17)) / (p(4) + (p(15)/p(16)));
ic(4) = q4;
%ic(5) = 0.0112595761822961;
ic(5) = (p(23)*FT3p + (p(13)*ic(2))/(p(14)+ic(2))) / (p(20)+p(29));
%ic(6) = 0.0652960640300348;
ic(6) = (p(22)*FT3p + (p(15)*ic(3))/(p(16)+ic(3)) + (p(17)*ic(3))/(p(18)+ic(3))) / (p(21));
ic(7) = q7;
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

%simulation time
t  = t/24;              % Convert time to days

% T4 plot
subplot(3,1,1);
hold on;
plot(t,y1,'color','blue');

% T3 plot
subplot(3,1,2);
hold on;
plot(t,y2,'color','blue');

% TSH plot
subplot(3,1,3);
hold on;
plot(t,y3,'color','blue');
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


% T4 plot
subplot(3,1,1);
ylabel('T4 mcg/L');
ylim([0 120]);
hline = refline(0,45); %slope, intercept
hline2 = refline(0,105); %slope, intercept
hline.Color='g';
hline2.Color='g';
set(gca,'fontsize',18)


% T3 plot
subplot(3,1,2);
ylabel('T3 mcg/L');
ylim([0 5]);
hline = refline(0,0.6); %slope, intercept
hline2 = refline(0,1.8); %slope, intercept
hline.Color='g';
hline2.Color='g';
set(gca,'fontsize',18)


% TSH plot
subplot(3,1,3);
ylabel('TSH mU/L');
ylim([0 p3max]);
xlabel('Days');
hline = refline(0,0.4); %slope, intercept
hline2 = refline(0,4.0); %slope, intercept
hline.Color='g';
hline2.Color='g';
set(gca,'fontsize',18)
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