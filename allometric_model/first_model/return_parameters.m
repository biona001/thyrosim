function [p, d] = return_parameters(dial)

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
p(7) = 0.000289;        %A
p(8) = 0.000214;        %B
p(9) = 0.000128;        %C
p(10) = -8.83*10^-6;    %D
p(11) = 0.88;           %k4absorb; originally 0.881
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
p(28) = 0.88;           %k3absorb; originally 0.882
p(29) = 0.207;          %k05
p(30) = 1166;           %Bzero
p(31) = 581;            %Azero
p(32) = 2.37;           %Amax
p(33) = -3.71;          %phi
p(34) = 0.53;           %kdegTSH-HYPO
p(35) = 0.037;          %VmaxTSH
p(36) = 23;             %K50TSH
p(37) = 0.118;          %k3
p(38) = 0.29;           %T4P-EU
p(39) = 0.006;          %T3P-EU
p(40) = 0.037;          %KdegT3B
p(41) = 0.0034;         %KLAG-HYPO
p(42) = 5;              %KLAG
p(43) = 1.3;            %k4dissolve
p(44) = 0.12*d(2);      %k4excrete; originally 0.119
p(45) = 1.78;           %k3dissolve
p(46) = 0.1056;      %k3excrete; originally 0.118
% p47 and p48 are only used in converting mols to units. Since unit conversion
% is done in THYSIM->postProcess(), make sure you change p47 and p48 there if
% you need to change these values.
p(47) = 3.2;            %Vp
p(48) = 5.2;            %VTSH
p(52) = -0.25;          %rate exponent, scaling exponent taken from Ellenberger paper
p(53) = 0.0;            %clerance exponent (originally 0.75)
p(54) = 1.0;            %volumn exponent
p(55) = 70;             %thyrosim average patient weight (i.e. 70 orignally)
end