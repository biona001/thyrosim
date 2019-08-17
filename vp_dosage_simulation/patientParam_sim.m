function [Vp_new, Vtsh_new, Vp_ratio] = patientParam_sim(input)
    %input = H, W, sex (1 = male)
    p47 = 3.2; %original Vp
    p48 = 5.2; %original TSH 
    H = input(1);
    W = input(2);
    sex = input(3);
                    
    Hem = 0.40 + 0.05*sex;     %.45 for male and .4 for females (by default)
	BMI = W/H^2;    % BMI
    
    %Feldschuh's blood volume (L), H measured in cm
    if sex == 1
        IW = 176.3 - 2.206*(H*100) + 0.00935*(H*100)^2;
    elseif sex == 0
        IW = 145.8 - 1.827*(H*100) + 0.007955*(H*100)^2;
    end
    
    %sums of exponential (fitted from feldschuh's data)
%     Div = (W - IW) / IW * 100; %deviation from ideal weight
%     a = 30.19;
%     b = -0.01744;
%     c = 39.47;
%     d = 0.0006516;
%     Vb_per_kg = a*exp(b*Div) + c*exp(d*Div);

    % hill function fitted to feldchush data
    Div = (W - IW) / IW * 100; %deviation from ideal weight
    a = 1.42634 * 10^4;
    n = 0.745964264;
    K = 100.0;
    Vb_per_kg = a * (100.0 + Div)^(n - 1) / ((100 + Div)^n + K^n);
    Vb = Vb_per_kg * W / 1000;
    
    %average male/female data in US
    male_ref_vp = 2.92;
    female_ref_vp = 2.48;
    %male_height = 1.77; %these are parameter we used to get male_ref_vp
    %female_height = 1.63;
    %male_weight = 70.0;
    %female_weight = 59.0;
    
       
    %scaling predicted plasma volumn up since feldschuch's data predicts 70 kg would give 2.7 L
	Vp_new = Vb*(1-Hem);       % Vp (orginally 3.2)
    if sex == 1
        Vp_new = Vp_new * 3.2 / male_ref_vp;    
    else
        Vp_new = Vp_new * 3.2 / female_ref_vp;   
    end
    
    % Vp is orginally 3.2, but 2.7230 is predicted for a male 170cm, 70kg, white, age 36.
    % so we scale up Vp for everyone by adding the difference in Vp to everybody
	%Vp_new = Vb*(1-Hem) + 0.477;    
    %Vp_new = Vb*(1-Hem); 
    %Vp_new = (Vp_new / 2.7230)*3.2;
    
	Vtsh_old = p48;              % Vtsh (not changed
	Vtsh_new = Vtsh_old + Vp_new - p47; 
    %Vtsh_new = 2.0 + Vp_new; 
	Vp_ratio = p47 / Vp_new;      % ratio for plasma volume
end
