%--------------------------------------------------
% FILE:         thyrosim_core.m
% AUTHOR:       Simon X. Han
% DESCRIPTION:
%   The core solver, for calling by other scripts, such as
%   thyrosim_oral_repeat.m.
%
%   THYROSIM implmentation based on:
%   All-Condition Thyroid Simulator Eqns 2015-06-29.pdf
%-------------------------------------------------- 

function [t,q] = thyrosim_core_rate2(ic,dial,inf1,inf4,tspan,fitting_index,current_iter,patient)

% Initialize
global u1 u4 kdelay d p;
[u1,u4,kdelay,d,p] = initParams(inf1,inf4,dial,fitting_index,current_iter,patient);

% Solve ODE
[t,q] = ode45(@ODEs, tspan, ic);
end

% Initialize parameter values, and scale them 
function [u1,u4,kdelay,d,p] = initParams(inf1,inf4,dial,fitting_index,current_iter,patient)

u1 = inf1;
u4 = inf4;
kdelay = 5/8;           %(n-1)/k = t; n comps, t = 8hr
[p, d] = return_parameters(dial); %list of parameters

for i = 1:length(fitting_index)
    p(fitting_index(i)) = current_iter(i);
end

[Vp_new, mass_ratio] = patientParam_rate2(patient, p(47));
p(47) = Vp_new; %reassign Vp after scaling
%p(48) = Vtsh_new; %reassign Vtsh after scaling
%p(49) = Vp_ratio;
%p(50) = SM_ratio;
%p(51) = Vtsh_ratio;

list_rates = [3, 4, 5, 6, 20, 21, 22, 23, 11, 28, 44, 46, 35]; %should S4 be scaled?
list_clearances = [13, 15, 17, 34];

for i = 1:length(list_rates)
    index = list_rates(i);
    p(index) = mass_ratio^p(52) * p(index);
end

for i = 1:length(list_clearances)
    index = list_rates(i);
    p(index) = mass_ratio^p(53) * p(index);
end
end

% ODEs
function dqdt = ODEs(t, q)

global u1 u4 kdelay d p;

% Auxillary equations
q4F = (p(24)+p(25)*q(1)+p(26)*q(1)^2+p(27)*q(1)^3)*q(4);        %FT3p
q1F = (p(7) +p(8) *q(1)+p(9) *q(1)^2+p(10)*q(1)^3)*q(1);        %FT4p
SR3 = (p(19)*q(19))*d(3);                                       % Brain delay
SR4 = (p(1) *q(19))*d(1);                                       % Brain delay
fCIRC = 1+(p(32)/(p(31)*exp(-q(9)))-1)*(1/(1+exp(10*q(9)-55)));
SRTSH = (p(30)+p(31)*fCIRC*sin(pi/12*t-p(33)))*exp(-q(9));
fdegTSH = p(34)+p(35)/(p(36)+q(7));
fLAG = p(41)+2*q(8)^11/(p(42)^11+q(8)^11);
f4 = p(37)+5*p(37)/(1+exp(2*q(8)-7));
NL = p(13)/(p(14)+q(2));

% ODEs original

qdot(1) = SR4+p(3)*q(2)+p(4)*q(3)-(p(5)+p(6))*q1F+p(11)*q(11)+u1;       %T4dot
qdot(2) = p(6)*q1F-(p(3)+p(12)+NL)*q(2);                                %T4fast
qdot(3) = p(5)*q1F-(p(4)+p(15)/(p(16)+q(3))+p(17)/(p(18)+q(3)))*q(3);   %T4slow
qdot(4) = SR3+p(20)*q(5)+p(21)*q(6)-(p(22)+p(23))*q4F+p(28)*q(13)+u4;   %T3pdot
qdot(5) = p(23)*q4F+NL*q(2)-(p(20)+p(29))*q(5);                         %T3fast
qdot(6) = p(22)*q4F+p(15)*q(3)/(p(16)+q(3))+p(17)*q(3)/(p(18)+q(3))-(p(21))*q(6);%T3slow
qdot(7) = SRTSH-fdegTSH*q(7);                                           %TSHp


% scaling only the linear terms 
%qdot(1) = SR4+p(49)*p(3)*q(2)+p(49)*p(4)*q(3)-p(49)*(p(5)+p(6))*q1F+p(11)*q(11)+u1;       %T4dot
%qdot(2) = p(6)*q1F-(p(3)+p(12)+NL)*q(2);                                %T4fast
%qdot(3) = p(50)*p(5)*q1F-p(50)*(p(4)+p(15)/(p(16)+q(3))+p(17)/(p(18)+q(3)))*q(3);   %T4slow
%qdot(4) = SR3+p(49)*p(20)*q(5)+p(49)*p(21)*q(6)-p(49)*(p(22)+p(23))*q4F+p(28)*q(13)+u4;   %T3pdot
%qdot(5) = p(23)*q4F+NL*q(2)-(p(20)+p(29))*q(5);                         %T3fast
%qdot(6) = p(50)*p(22)*q4F+p(50)*p(15)*q(3)/(p(16)+q(3))+p(17)*q(3)/(p(18)+q(3))-p(50)*(p(21))*q(6);%T3slow
%qdot(7) = SRTSH-p(51)*fdegTSH*q(7);                                           %TSHp

%scaling the entire ODE and repeating rates in other compartment to not
%violate conservation of matter
%{
qdot(1) = SR4+p(49)*(p(3)*q(2)+p(50)*p(4)*q(3)-(p(50)*p(5)+p(6))*q1F+p(11)*q(11)+u1);       %T4dot
qdot(2) = p(49)*p(6)*q1F-(p(49)*p(3)+p(12)+NL)*q(2);                                %T4fast
qdot(3) = p(50)*(p(49)*p(5)*q1F-(p(49)*p(4)+p(15)/(p(16)+q(3))+p(17)/(p(18)+q(3)))*q(3));   %T4slow
qdot(4) = SR3+p(49)*(p(20)*q(5)+p(50)*p(21)*q(6)-(p(50)*p(22)+p(23))*q4F+p(28)*q(13)+u4);   %T3pdot
qdot(5) = p(49)*p(23)*q4F+NL*q(2)-(p(49)*p(20)+p(29))*q(5);                         %T3fast
qdot(6) = p(50)*(p(49)*p(22)*q4F+p(15)*q(3)/(p(16)+q(3))+p(17)*q(3)/(p(18)+q(3))-(p(49)*p(21))*q(6));%T3slow
qdot(7) = SRTSH-p(49)*fdegTSH*q(7); %should this be scaled by Vtsh ratio or Vp ratio
%}

% scaling according to source compartment
%{
qdot(1) = SR4+p(3)*q(2)+p(50)*p(4)*q(3)-(p(50)*p(5)+p(6))*q1F+p(11)*q(11)+u1;       %T4dot
qdot(2) = p(49)*p(6)*q1F-(p(3)+p(12)+NL)*q(2);                                %T4fast
qdot(3) = p(49)*p(5)*q1F-(p(50)*p(4)+p(15)/(p(16)+q(3))+p(17)/(p(18)+q(3)))*q(3);   %T4slow
qdot(4) = SR3+p(20)*q(5)+p(50)*p(21)*q(6)-(p(49)*p(22)+p(49)*p(23))*q4F+p(28)*q(13)+u4;   %T3pdot
qdot(5) = p(49)*p(23)*q4F+NL*q(2)-(p(20)+p(29))*q(5);                         %T3fast
qdot(6) = p(49)*p(22)*q4F+p(15)*q(3)/(p(16)+q(3))+p(17)*q(3)/(p(18)+q(3))-(p(50)*p(21))*q(6);%T3slow
qdot(7) = SRTSH-fdegTSH*q(7);  %not scaled
%}

% ODEs scaled allometrically
%{
qdot(1) = SR4+p(3)*q(2)+p(4)*q(3)-(p(5)+p(6))*q1F+p(11)*q(11)+u1;       %T4dot
qdot(2) = p(6)*q1F-(p(3)+p(12)+NL)*q(2);                                %T4fast
qdot(3) = p(5)*q1F-(p(4)+p(15)/(p(16)+q(3))+p(17)/(p(18)+q(3)))*q(3);   %T4slow
qdot(4) = SR3+p(20)*q(5)+p(21)*q(6)-(p(22)+p(23))*q4F+p(28)*q(13)+u4;   %T3pdot
qdot(5) = p(23)*q4F+NL*q(2)-(p(20)+p(29))*q(5);                         %T3fast
qdot(6) = p(22)*q4F+p(15)*q(3)/(p(16)+q(3))+p(17)*q(3)/(p(18)+q(3))-(p(21))*q(6);%T3slow
qdot(7) = SRTSH-fdegTSH*q(7);                                           %TSHp
%}

qdot(8) = f4/p(38)*q(1)+p(37)/p(39)*q(4)-p(40)*q(8);                    %T3B
qdot(9) = fLAG*(q(8)-q(9));                                             %T3B LAG
qdot(10)= -p(43)*q(10);                                                 %T4PILLdot
qdot(11)=  p(43)*q(10)-(p(44)+p(11))*q(11);                             %T4GUTdot
qdot(12)= -p(45)*q(12);                                                 %T3PILLdot
qdot(13)=  p(45)*q(12)-(p(46)+p(28))*q(13);                             %T3GUTdot

% Delay ODEs
qdot(14)= -kdelay*q(14) +q(7);                                          %delay1
qdot(15)= kdelay*(q(14) -q(15));                                        %delay2
qdot(16)= kdelay*(q(15) -q(16));                                        %delay3
qdot(17)= kdelay*(q(16) -q(17));                                        %delay4
qdot(18)= kdelay*(q(17) -q(18));                                        %delay5
qdot(19)= kdelay*(q(18) -q(19));                                        %delay6

% ODE vector
dqdt = qdot';
end