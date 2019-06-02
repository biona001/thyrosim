function f = train(current_iter)
    fitting_index = [];
    
    if length(fitting_index) ~= length(current_iter)
        error('check vector length bro');
    end
    
    %specify thyrosim version (either 'new' or 'original')
    thyrosim_version = 'original';
    %thyrosim_version = 'new';
    make_plots = true;

    %import schneider and blakesley data
    schneider_data = readtable('schneider_train_15patients.csv');
    [time, blakesley_data] = parse_blakesley();
    blakesley_doses = [0.515; 0.579; 0.7722]; %400/450/600 micrograms
        
    %calculate error
    blakesley_error_original_thyrosim = 1.6911e+04;
    blakesley_error_new_thyrosim_prior_fit = 1.6908e+04;
    f = 0.0;
    %f = f + compute_schneider_error(current_iter, fitting_index, schneider_data, thyrosim_version, make_plots);
    f = f + compute_blakesley_error(current_iter, fitting_index, time, blakesley_data, blakesley_doses, thyrosim_version, make_plots) / blakesley_error_new_thyrosim_prior_fit;
    disp(f);
end
