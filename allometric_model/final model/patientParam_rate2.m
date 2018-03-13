function [Vp_new, mass_ratio] = patientParam_rate2(input, p47)
    %input = H, W, sex, age, race
    H = input(1);
    W = input(2);
    sex = input(3);
    age = input(4);
    race = input(5);
    
    %input = [1.7; 70; 1; 30; 0]; %70kg 1.7m male (thyrosim's original input)
    
    female_weight = 60;
    avg_weight = 70*sex + female_weight*(1 - sex);    
    
    % Vp (orginally 3.2)
    % Vp 2.7230 is the prediction for a male 170cm, 70kg, white, age 36.
	%Vp_new = Vb*(1-Hem) + 0.477;    %scale by adding difference in Vp for 70kg to everybody
    %Vp_new = Vb*(1-Hem); 
    %Vp_new = (Vp_new / 2.7230)*3.2;
    
    %mass_ratio = W / 70.0;
    mass_ratio = W / avg_weight;

    Vp_new = p47 * mass_ratio; % this scales plasma volume with exponent of 1
end
