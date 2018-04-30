%calculates total T4 dose per person per day
function T4dose = cunningham(weight, sex, age)
    T4dose = 0.0;
    if sex == 1
        LBM = (79.5 - 0.24*weight - 0.15*age)*weight / 73.2;
        T4dose = 3.9*LBM - 40;
    elseif sex == 0
        LBM = (69.8 - 0.26*weight - 0.12*age)*weight / 73.2;
        T4dose = 3.4*LBM - 12;
    end
    T4dose = T4dose / 777.0; %concert micrograms to micromoles
end