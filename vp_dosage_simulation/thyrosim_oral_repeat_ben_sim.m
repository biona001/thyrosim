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
function [total_time, total_q] = thyrosim_oral_repeat_ben_sim(patient, T4_init, T3_init, Tsh_init, t_unit, tspans, T4doses, T3doses, thyrosim_version, dial, ic)

    % Initialize
    if isempty(ic)
        ic = init(patient, T4_init, T3_init, Tsh_init, thyrosim_version, dial);
    end
    inf1 = 0; % For oral doses, infs are 0
    inf4 = 0; % For oral doses, infs are 0

    % Some needed vars
    t_last = 0;
    T4max = 0;
    T3max = 0;
    TSHmax = 0;

    % Run simulation for each defined run
    total_time = [];
    total_q = [];

    for i=1:length(tspans)    
        ic = updateIC(ic,T4doses(i),T3doses(i)); % Add drugs, if any
        phase = mod(t_last, 24); 
        [t,q] = thyrosim_core_ben_sim(ic,dial,inf1,inf4,tspans(i,:),patient,phase,thyrosim_version); % Run simulation
        ic = q(end,:); % Set this run's values as IC for next run

        t = t + t_last;
        total_time = [total_time; t(2:end)];
        total_q = [total_q; q(2:end, :)];
        t_last = t(end);

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
end

% Initialize initial conditions
function ic = init(patient, T4_init, T3_init, Tsh_init, thyrosim_version, dial)

    if strcmp(thyrosim_version, 'new')
        % some patient parameters W, H, sex
        [Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(patient); %just used to calculated initial conditions, so use original Vp and Vtsh
        %ic measured in same units as q, which probably is micromol?

        % calling this function to get the p values to get correct initial conditions in q2, q3, q5, q6
        [p, d] = return_parameters(dial);

        %new initial conditions by solving quasi steady state
        q1 = T4_init*Vp_new/777;
        q4 = T3_init*Vp_new/651;
        q7 = Tsh_init*Vtsh_new/5.6;
        FT3p = (p(24)+p(25)*q1+p(26)*q1^2+p(27)*q1^3)*q4;
        FT4p = (p(7)+p(8)*q1+p(9)*q1^2+p(10)*q1^3)*q1;
        a_bd_c = p(6)*FT4p - (p(3)+p(12))*p(14) - p(13);

        %AA = p(4);
        %BB = -p(5)*FT4p+p(4)*(p(16)+p(18))+p(15)+p(17);
        %CC = -p(5)*FT4p*(p(16)+p(18))+p(4)*p(16)*p(18)+p(15)*p(18)+p(17)*p(16);
        %DD = -p(5)*FT4p*p(16)*p(18);
        %result = roots([AA BB CC DD]);
        %q3 = result(result >= 0); %hope that this is just a single value for all cases

        ic(1) = q1;
        %ic(2) = (p(6)*FT4p) / (p(3)+p(12)+(p(13)/p(14))); %assuming Km21fast much greater than q2 in the denominator -> potentially bad approximation
        ic(2) = (a_bd_c + sqrt(a_bd_c^2 + 4*(p(3)+p(12))*p(6)*FT4p*p(14))) / (2*(p(3)+p(12)));
        ic(3) = (p(5)*FT4p - p(17)) / (p(4) + (p(15)/p(16)));
        %ic(3) = q3;
        ic(4) = q4;
        ic(5) = (p(23)*FT3p + (p(13)*ic(2))/(p(14)+ic(2))) / (p(20)+p(29));
        ic(6) = (p(22)*FT3p + (p(15)*ic(3))/(p(16)+ic(3)) + (p(17)*ic(3))/(p(18)+ic(3))) / (p(21));
        ic(7) = q7;
        ic(8) = 7.05727560072869;
        ic(9) = 7.05714474742141;
        %ic(8) = (p(37)*q1/p(38) + p(37)*q4/p(39)) / p(40); %IMPORTANT: this assumes T3B is very high, so f4 ~ k3 probably need to change for Jonklaas data
        %ic(9) = ic(8);
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
    
    if strcmp(thyrosim_version, 'original')
        ic(1) = 0.322114215761171;
        ic(2) = 0.201296960359917;
        ic(3) = 0.638967411907560;
        ic(4) = 0.00663104034826483;
        ic(5) = 0.0112595761822961;
        ic(6) = 0.0652960640300348;
        ic(7) = 1.78829584764370;
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
end

% Update initial conditions
function [ic] = updateIC(ic,T4dose,T3dose)
    ic(11) = ic(11) + T4dose;
    ic(13) = ic(13) + T3dose;
end
