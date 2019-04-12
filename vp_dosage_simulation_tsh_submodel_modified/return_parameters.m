function [p, d] = return_parameters(dial, fitting_index, current_iter)
    d(1) = dial(1);
    d(2) = dial(2);
    d(3) = dial(3);
    d(4) = dial(4);
    
    p(1) = 0.00174155;      %S4
    p(2) = 8;               %tau
    p(3) = 0.868;           %k12
    p(4) = 0.108;           %k13
    p(5) = 584;             %k31free
    p(6) = 1503;            %k21free
    p(7) = 0.000289;        %A originally 0.000289
    p(8) = 0.000214;        %B originally 0.000214
    p(9) = 0.000128;        %C
    p(10) = -8.83*10^-6;    %D
    p(11) = 0.88;           %k4absorb; assuming scales the same as T3, originally 0.88
    p(12) = 0.0189;         %k02
    p(13) = 0.00998996;     %VmaxD1fast
    p(14) = 2.85;           %KmD1fast
    p(15) = 6.63*10^-4;     %VmaxD1slow
    p(16) = 95;             %KmD1slow
    p(17) = 0.00074619;     %VmaxD2slow
    p(18) = 0.075;          %KmD2slow
    p(19) = 3.3572*10^-4;   %S3
    p(20) = 5.37;           %k45
    p(21) = 0.0689;         %k46
    p(22) = 127;            %k64free
    p(23) = 2043;           %k54free
    p(24) = 0.00395;        %a
    p(25) = 0.00185;        %b
    p(26) = 0.00061;        %c
    p(27) = -0.000505;      %d
    p(28) = 0.88;                 %k3absorb; originally 0.88
    p(29) = 0.207;          %k05
    p(30) = 100;              %Bzero -> this guy we will fix for now because for patient with 0 secretion and no treatment will result in TSH roughyly 150
    p(31) = 49.39;            %Azero -> fitted to blakesley data
    p(32) = 0; %2.37;               %Amax -> this should be around 0 because 1976 weeke says hypothyroid patients should have no oscillations.
    p(33) = -3.71;          %phi
    p(34) = 0.53;           %kdegTSH-HYPO
    p(35) = 0.226;              %VmaxTSH originally it's 0.037 but this is probably a typo because eq4 of 2010 eigenberg it not a real hill function
    p(36) = 23;             %K50TSH
    p(37) = 0.118;          %k3
    p(38) = 0.29;           %T4P-EU
    p(39) = 0.006;          %T3P-EU
    p(40) = 0.037;          %KdegT3B
    p(41) = 0.0034;         %KLAG-HYPO
    p(42) = 5;              %KLAG
    p(43) = 1.3;            %k4dissolve; originally 1.3 (scaled by original ratio)
    p(44) = 0.12*d(2);      %k4excrete; assuming T4 excrete scales the same as T3
    p(45) = 1.78;                 %k3dissolve, originally 1.78 -> should redo these with jonklass data since we changed TSH brain submodel
    p(46) = 1.056;               %k3excrete; originally 0.12 * d(4)
    % p47 and p48 are only used in converting mols to units. Since unit conversion
    % is done in THYSIM->postProcess(), make sure you change p47 and p48 there if
    % you need to change these values.
    p(47) = 3.2;            %Vp
    p(48) = 5.2;            %VTSH
    %below are parameters we added for the hill function in f_circ, and SRtsh
    p(49) = 4;              %K_circ -> this we are not going to fit because we don't have TSH data on very hypothyroid patients
    p(50) = 3;              %K_SR_tsh
    p(51) = 7;              %hill exponent in f_circ
    p(52) = 5.2;            %hill exponent in SR_tsh
    p(53) = 3.5;            %Km for f4
    p(54) = 8.0;            %hill exponent for f4
    
    if ~isempty(fitting_index)
        %check vector lengths match
        if length(fitting_index) ~= length(current_iter)
            error('length mismatch between fitting_index and current_iter');
        end
        
        %change parameters for fitting
        for i = 1:length(fitting_index)
            p(fitting_index(i)) = current_iter(i);
        end
    end
end