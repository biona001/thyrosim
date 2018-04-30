%calculates total T4 dose per person per day
function T4dose = ojomo(height, weight)
    BMI = weight / height^2;
    T4dose = -0.018*BMI + 2.13; %mcg/kg/day
    T4dose = T4dose * weight / 777.0; %micromoles/person/day
end