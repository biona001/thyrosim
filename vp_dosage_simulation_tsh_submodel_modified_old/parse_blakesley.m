function [time, my400_data, my450_data, my600_data] = parse_blakesley()
    data_400 = xlsread('blakeley_data_400.xlsx');
    data_450 = xlsread('blakeley_data_450.xlsx');
    data_600 = xlsread('blakeley_data_600.xlsx');
    time = data_400(:, 1);
    
    T4_400 = data_400(:, 2)*10.0;
    T3_400 = data_400(:, 3);
    TSH_400 = data_400(:, 4);
    my400_data = [T4_400 T3_400 TSH_400];

    T4_450 = data_450(:, 2)*10.0;
    T3_450 = data_450(:, 3);
    TSH_450 = data_450(:, 4);
    my450_data = [T4_450 T3_450 TSH_450];
    
    T4_600 = data_600(:, 2)*10.0;
    T3_600 = data_600(:, 3);
    TSH_600 = data_600(:, 4);
    my600_data = [T4_600 T3_600 TSH_600];
end