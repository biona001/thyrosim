%calculates total T4 dose per person per day
function T4dose = donna(height, weight, age)
    T4dose = 0.0;
    BMI = weight / height^2;
    if BMI <= 23
        if age <= 40;
            T4dose = 1.8*weight;
        elseif age > 55
            T4dose = 1.6*weight;
        else
            T4dose = 1.7*weight;
        end
    elseif BMI > 28
        if age <= 40;
            T4dose = 1.6*weight;
        elseif age > 55
            T4dose = 1.4*weight;
        else
            T4dose = 1.5*weight;
        end
    else
        if age <= 40;
            T4dose = 1.7*weight;
        elseif age > 55
            T4dose = 1.5*weight;
        else
            T4dose = 1.6*weight;
        end
    end
    T4dose = T4dose / 777.0; %concert micrograms to micromoles
end