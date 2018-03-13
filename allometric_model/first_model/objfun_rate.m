% given set of parameters, evaluates least squares on t3 and tsh
% of 9 patients. 
% goal: perturb given parameters so that least squares are minimized

function f = objfun_rate()
    %fitting_index = [5 4 22 21 28];
    %fitting_index = [5 4 22 21 17 28];
    %fitting_index = [5 4 22 21 17 18 15 16 28];
    %fitting_index = [52];
    fitting_index = [];
    current_iter = [];
    
    %if length(fitting_index) ~= length(current_iter)
    %    error('check vector length bro');
    %end
    
    %final t3 dosage, 0.046 = 30mcg 0.069 = 45mcg
    %dose = [0.046 0.046 0.069 0.069 0.046 0.046 0.069 0.046 0.046]; %9 normal weight
    %dose = [0.046 0.069 0.069 0.069 0.069 0.046]; %6 overweight patients
    dose = [0.046 0.046 0.069 0.069 0.046 0.046 0.069 0.046 0.046 0.046 0.069 0.069 0.069 0.069 0.046]; %all patients together 
    %dose = [0.046 0.069];
    
    [a, b, c, d, t4_std, t3_std, tsh_std] = data_test2();
    f = 0.0;
    
    for i=1:length(a)
        patient_param = a(i,:);  
        patient_t4 = b(i,:);
        patient_t3 = c(i,:);
        patient_tsh = d(i,:);
       
        [t4_values, t3_values, tsh_values] = thyrosim_oral_repeat_rate(fitting_index,current_iter, patient_param, patient_t4(1), patient_t3(1), patient_tsh(1), dose(i));
        
        %just least squares
        %{
        f = f + (patient_t4(2) - t4_values(2))^2/1000;
        f = f + (patient_t4(3) - t4_values(3))^2/1000;
        f = f + (patient_t4(4) - t4_values(5))^2/1000;
        f = f + (patient_t4(5) - t4_values(7))^2/1000;
        f = f + (patient_t4(6) - t4_values(9))^2/1000;
        f = f + (patient_t4(7) - t4_values(11))^2/1000;
        f = f + (patient_t4(8) - t4_values(13))^2/1000;
        f = f + (patient_t4(9) - t4_values(15))^2/1000;
        f = f + (patient_t4(10) - t4_values(17))^2/1000;
        
        f = f + (patient_t3(2) - t3_values(2))^2;
        f = f + (patient_t3(3) - t3_values(3))^2;
        f = f + (patient_t3(4) - t3_values(5))^2;
        f = f + (patient_t3(5) - t3_values(7))^2;
        f = f + (patient_t3(6) - t3_values(9))^2;
        f = f + (patient_t3(7) - t3_values(11))^2;
        f = f + (patient_t3(8) - t3_values(13))^2;
        f = f + (patient_t3(9) - t3_values(15))^2;
        f = f + (patient_t3(10) - t3_values(17))^2;
        %}
        
        
        %weighted least squares
        %first point not considered because they are the same
        
        f = f + (patient_t4(2) - t4_values(2))^2/t4_std(2)^2;
        f = f + (patient_t4(3) - t4_values(3))^2/t4_std(3)^2;
        f = f + (patient_t4(4) - t4_values(5))^2/t4_std(4)^2;
        f = f + (patient_t4(5) - t4_values(7))^2/t4_std(5)^2;
        f = f + (patient_t4(6) - t4_values(9))^2/t4_std(6)^2;
        f = f + (patient_t4(7) - t4_values(11))^2/t4_std(7)^2;
        f = f + (patient_t4(8) - t4_values(13))^2/t4_std(8)^2;
        f = f + (patient_t4(9) - t4_values(15))^2/t4_std(9)^2;
        f = f + (patient_t4(10) - t4_values(17))^2/t4_std(10)^2;
        
        f = f + (patient_t3(2) - t3_values(2))^2/t3_std(2)^2;
        f = f + (patient_t3(3) - t3_values(3))^2/t3_std(3)^2;
        f = f + (patient_t3(4) - t3_values(5))^2/t3_std(4)^2;
        f = f + (patient_t3(5) - t3_values(7))^2/t3_std(5)^2;
        f = f + (patient_t3(6) - t3_values(9))^2/t3_std(6)^2;
        f = f + (patient_t3(7) - t3_values(11))^2/t3_std(7)^2;
        f = f + (patient_t3(8) - t3_values(13))^2/t3_std(8)^2;
        f = f + (patient_t3(9) - t3_values(15))^2/t3_std(9)^2;
        f = f + (patient_t3(10) - t3_values(17))^2/t3_std(10)^2;
        
        %{
        f = f + (((patient_tsh(2) - tsh_values(2)))/scale(3))^2;
        f = f + ((patient_tsh(3) - tsh_values(3))/scale(3))^2;
        f = f + ((patient_tsh(4) - tsh_values(5))/scale(3))^2;
        f = f + ((patient_tsh(5) - tsh_values(7))/scale(3))^2;
        f = f + ((patient_tsh(6) - tsh_values(9))/scale(3))^2;
        f = f + ((patient_tsh(7) - tsh_values(11))/scale(3))^2;
        f = f + ((patient_tsh(8) - tsh_values(13))/scale(3))^2;
        f = f + ((patient_tsh(9) - tsh_values(15))/scale(3))^2;
        f = f + ((patient_tsh(10) - tsh_values(17))/scale(3))^2;
        %}
    end
    
end

%normal weight t3 + t4 WLS, fitting absorption, first sample = 25 min 
%current_iter = [584 0.108 127 0.0689 0.00074619 0.88]
%lb = [58.4 0.0108 12.7 0.00689 0.000074619 0.088]
%ub = [5840 1.08 1270 0.689 0.0074619 8.8]

%all patients t3 + t4 WLS, fitting absorption, first sample = 25 min 
%current_iter = [584 0.108 127 0.0689 0.00074619 0.88]
%lb = [58.4 0.0108 12.7 0.00689 0.000074619 0.088]
%ub = [5840 1.08 1270 0.689 0.0074619 8.8]

%current_iter = [584 0.108 127 0.0689 0.88]


%current_iter = [-0.25]


