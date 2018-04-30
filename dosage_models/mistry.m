%calculates total T4 dose per person per day
function T4dose = mistry(weight, age)
    T4dose = 0.943*weight - 1.165*age + 125.8;
    T4dose = T4dose / 777.0;
end