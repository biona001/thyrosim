data = csvread('patient_data.csv',2);
div = data(:, 1);
bv = data(:, 2);

f = fit(div,bv,'exp2');
plot(f,div,bv);