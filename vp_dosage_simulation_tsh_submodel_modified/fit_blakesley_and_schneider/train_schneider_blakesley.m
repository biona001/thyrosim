%function from https://www.mathworks.com/matlabcentral/answers/54910-stopping-fmincon-based-on-timer
function current_iter = train_schneider_blakesley()
    options = optimset('Display','iter','Algorithm','Interior-Point'); %for show
    setappdata(0,'FMINCONsStopFlag',false); %stopping flag is false
    T = timer('startdelay',1000,'timerfcn',@(src,evt)setappdata(0,'FMINCONsStopFlag',true)); %after 23 hours change the flag to true
    start(T); %start the timer, T minus 10 seconds!
    
    %specify objective function, initial guess, lower & upper bounds
    current_iter = fmincon(@train,[101 47.64 4.57 3.90 6.91 7.66],[],[],[],[],[10.1 4.764 1.0 1.0 1.0 1.0],[300 100.0 15.0 15.0 15.0 15.0],[],options);
    
    function f = train(current_iter)
        fitting_index = [30 31 49 50 51 52];
        if length(fitting_index) ~= length(current_iter)
            error('check vector length bro');
        end

        %specify thyrosim version (either 'new' or 'original')
        %thyrosim_version = 'original';
        thyrosim_version = 'new';
        make_plots = false;

        %import schneider and blakesley data
        schneider_data = readtable('schneider_train_15patients.csv');
        %schneider_data = readtable('schneider_train_100patients.csv');
        [time, blakesley_data] = parse_blakesley();
        blakesley_doses = [0.515; 0.579; 0.7722]; %400/450/600 micrograms

        %calculate error
        blakesley_error_original_thyrosim = 1.6911e+04;
        blakesley_error_new_thyrosim_prior_fit = 1.6908e+04;
        f = 0.0;
        f = f + compute_schneider_error(current_iter, fitting_index, schneider_data, thyrosim_version, make_plots);
        f = f + compute_blakesley_error(current_iter, fitting_index, time, blakesley_data, blakesley_doses, thyrosim_version, make_plots) / blakesley_error_new_thyrosim_prior_fit;
    
        %check if time exceeded
        StopFlag = getappdata(0,'FMINCONsStopFlag'); %get stop flag
        if StopFlag
            %save current error
            st = ['Ran for too long!!! error was ', num2str(f)];
            fileID = fopen(['./fitting_result.txt'], 'w');
            fprintf(fileID,'%s\n',st);
            fclose(fileID);
            
            %save best guess
            fileID = fopen(['./fitting_current_iter.txt'], 'w');
            for i = 1:size(current_iter, 2)
                fprintf(fileID,'%s\n',num2str(current_iter(i)));
            end
            fclose(fileID);
            
            %error out
            error('aborting hue');
        end
    end
end