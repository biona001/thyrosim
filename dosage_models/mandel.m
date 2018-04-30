function T4dose = mandel(weight)
    %convert microgram/KG to micrograms/person to micromoles/person
    T4dose = 1.6*weight / 777.0; 
end
