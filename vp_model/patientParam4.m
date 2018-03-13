function [Vp_new, Vtsh_new, Vp_ratio, SM_ratio, Vtsh_ratio] = patientParam4(input, p47, p48)
    %input = H, W, sex, age, race
    H = input(1);
    W = input(2);
    sex = input(3);
    age = input(4);
    race = input(5);
                    
    Hem = 0.40 + 0.05*sex;     %.45 for male and .4 for females (by default)
	BMI = W/H^2;    % BMI
    
    %Nadler's blood volume (L)
    %Vb = (0.3561 + sex*0.0108)*H^3 + (0.03308 - sex*0.00089)*W + 0.1833 + sex*0.4208;   

    %Feldschuh's blood volume (L), H measured in cm
    if sex == 1
        IW = 176.3 - 2.206*(H*100) + 0.00935*(H*100)^2;
    elseif sex == 0
        IW = 145.8 - 1.827*(H*100) + 0.007955*(H*100)^2;
    end
    
    %{ 
    %4th order polynomail
    Div = (W - IW) / IW * 100; %deviation from ideal weight
    Vb_per_kg = 70.03 - 0.491*Div + 0.003854*Div^2 - 0.000001379*Div^3 + 0.00000001794*Div^4;
    Vb = Vb_per_kg * W / 1000;    
    %}
    
    %sums of exponential
    Div = (W - IW) / IW * 100; %deviation from ideal weight
    a = 30.19;
    b = -0.01744;
    c = 39.47;
    d = 0.0006516;
    Vb_per_kg = a*exp(b*Div) + c*exp(d*Div);
    Vb = Vb_per_kg * W / 1000; 
    
	SM_old = 30.57;    %skeletal muscle mass of original tyrosim model (kg)
	SM_new = 0.244*W + 7.8*H - 0.098*age + 6.6*sex + race -3.3; % model 2
    
    %average male/female data in US
    male_height = 1.77;
    female_height = 1.63;
    male_weight = 70.0;
    female_weight = 59.0;
    male_ref_vp = 2.92;
    female_ref_vp = 2.48;
    
	Vp_new = Vb*(1-Hem);       % Vp (orginally 3.2)
    
    %scaling predicted plasma volumn up since feldschuch's data predicts 70 kg would give 2.7 L
    if sex == 1
        Vp_new = Vp_new * 3.2 / male_ref_vp;    
    else
        Vp_new = Vp_new * 3.2 / female_ref_vp;   
    end
	Vtsh_old = p48;              % Vtsh (not changed
	Vtsh_new = Vtsh_old + Vp_new - p47; 
    %Vtsh_new = 2.0 + Vp_new; 
	Vp_ratio = p47 / Vp_new;      % ratio for plasma volume
	SM_ratio = SM_old / SM_new;  % ratio for SM
	Vtsh_ratio = Vtsh_old / Vtsh_new;  % ratio for Vtsh

	return 
end
