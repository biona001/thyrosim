function [time, T4, T3, TSH] = parse_blakesley()
    mydata = xlsread('BlakesleyData.xlsx');
    time = mydata(:, 1);
    T4 = mydata(:, 2);
    T3 = mydata(:, 3);
    TSH = mydata(:, 4);
end