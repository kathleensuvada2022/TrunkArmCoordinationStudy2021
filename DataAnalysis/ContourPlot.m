%% Plotting Contour of Baseline - July 2024 

% Load in baseline file 
ppsdata=data;

%% Removing Dead Elements for Test Particpant RTIS1004
% Mat 1
if strcmp(partid,'RTIS1004')

       % Element 23
        ppsdata(:,23) = NaN;
        
        % Element 39
        ppsdata(:,39) = NaN;

        % Element 40
        ppsdata(:,40) = NaN;

        % Element 22
        ppsdata(:,22) = NaN;

        % Element 54
        ppsdata(:,54) = NaN;

        % Element 25
        ppsdata(:,25) = NaN;

        % Element 41
        ppsdata(:,41) = NaN;

 % Mat 2

        % Element 497
        ppsdata(:,497) = NaN;

        % Element 481
        ppsdata(:,481) = NaN;

        % Element 465
        ppsdata(:,465) = NaN;

        % Element 449
        ppsdata(:,449) = NaN;

        % Element 433
        ppsdata(:,433) = NaN;

        % Element 417
        ppsdata(:,417) = NaN;

        % Element 401
        ppsdata(:,401) = NaN;

        % Element 482
        ppsdata(:,482) = NaN;

        % Element 466
        ppsdata(:,466) = NaN;

        % Element 450
        ppsdata(:,450) = NaN;

        % Element 354
        ppsdata(:,354) = NaN;

        % Element 467
        ppsdata(:,467) = NaN;

        % Element 469
        ppsdata(:,469) = NaN;

        % Element 487
        ppsdata(:,487) = NaN;

        % Element 471
        ppsdata(:,471) = NaN;

        % Element 472
        ppsdata(:,472) = NaN;

        % Element 273
        ppsdata(:,273) = NaN;

        % Element 264
        ppsdata(:,264) = NaN;

        % Element 257
        ppsdata(:,257) = NaN;

        % Element 455
        ppsdata(:,455) = NaN;

        % Element 386
        ppsdata(:,386) = NaN;

        % Element 387
        ppsdata(:,387) = NaN;

        % Element 501
        ppsdata(:,501) = NaN;

        % Element 502
        ppsdata(:,502) = NaN;

        % Element 488
        ppsdata(:,488) = NaN;

        % Element 434
        ppsdata(:,434) = NaN;

        % Element 381
        ppsdata(:,381) = NaN;

        % Element 365
        ppsdata(:,365) = NaN;

        % Element 398
        ppsdata(:,398) = NaN;

        % Element 382
        ppsdata(:,382) = NaN;

        % Element 366
        ppsdata(:,366) = NaN;

        % Element 479
        ppsdata(:,479) = NaN;

        % Element 512
        ppsdata(:,512) = NaN;

        % Element 496
        ppsdata(:,496) = NaN;

        % Element 368
        ppsdata(:,368) = NaN;

        % Element 463
        ppsdata(:,463) = NaN;

        % Element 464
        ppsdata(:,464) = NaN;

        % Element 473
        ppsdata(:,473) = NaN;

        % Element 506
        ppsdata(:,506) = NaN;

        % Element 350
        ppsdata(:,350) = NaN;


 end
%%

 if strcmp(partid,'RTIS1006')

    % Mat 1
  
    % Element 1
    ppsdata(:,1) = NaN;
    baselinedata(:,1) = NaN;

    % Element 2
    ppsdata(:,2) = NaN;
    baselinedata(:,2) = NaN;

    % Element 3
    ppsdata(:,3) = NaN;
    baselinedata(:,3) = NaN;

    % Element 14
    ppsdata(:,14) = NaN;
    baselinedata(:,14) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;
    baselinedata(:,15) = NaN;

    % Element 16
    ppsdata(:,16) = NaN;
    baselinedata(:,16) = NaN;


    % Mat 2
    % Element 481
    ppsdata(:,481) = NaN;
    baselinedata(:,481) = NaN;

    % Element 465
    ppsdata(:,465) = NaN;
    baselinedata(:,465) = NaN;

    % Element 449
    ppsdata(:,449) = NaN;
    baselinedata(:,449) = NaN;

    % Element 433
    ppsdata(:,433) = NaN;
    baselinedata(:,433) = NaN;

    % Element 417
    ppsdata(:,417) = NaN;
    baselinedata(:,417) = NaN;

    % Element 407
    ppsdata(:,407) = NaN;
    baselinedata(:,407) = NaN;

    % Element 369
    ppsdata(:,369) = NaN;
    baselinedata(:,369) = NaN;

    % Element 353
    ppsdata(:,353) = NaN;
    baselinedata(:,353) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;
    baselinedata(:,498) = NaN;

    % Element 263
    ppsdata(:,263) = NaN;
    baselinedata(:,263) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;
    baselinedata(:,264) = NaN;

    % Element 401
    ppsdata(:,401) = NaN;
    baselinedata(:,401) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;
    baselinedata(:,354) = NaN;

    % Element 497
    ppsdata(:,497) = NaN;
    baselinedata(:,497) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;
    baselinedata(:,466) = NaN;

    % Element 471
    ppsdata(:,471) = NaN;
    baselinedata(:,471) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;
    baselinedata(:,366) = NaN;

    % Element 383
    ppsdata(:,383) = NaN;
    baselinedata(:,383) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;
    baselinedata(:,384) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;
    baselinedata(:,352) = NaN;

    % Element 367
    ppsdata(:,367) = NaN;
    baselinedata(:,367) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;
    baselinedata(:,473) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;
    baselinedata(:,496) = NaN;

 end

 %% RTIS2002
if strcmp(partid,'RTIS2002')

    if strcmp(hand,'Left') % Paretic 
    % Element 1
    ppsdata(:,1) = NaN;
    baselinedata(:,1) = NaN;

    % Element 2
    ppsdata(:,2) = NaN;
    baselinedata(:,2) = NaN;

    % Element 3
    ppsdata(:,3) = NaN;
    baselinedata(:,3) = NaN;

    % Element 4
    ppsdata(:,4) = NaN;
    baselinedata(:,4) = NaN;

    % Element 5
    ppsdata(:,5) = NaN;
    baselinedata(:,5) = NaN;

    % Element 7
    ppsdata(:,7) = NaN;
    baselinedata(:,7) = NaN;

    % Element 8
    ppsdata(:,8) = NaN;
    baselinedata(:,8) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;
    baselinedata(:,24) = NaN;

    % Element 14
    ppsdata(:,14) = NaN;
    baselinedata(:,14) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;
    baselinedata(:,15) = NaN;

    % Element 16
    ppsdata(:,16) = NaN;
    baselinedata(:,16) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;
    baselinedata(:,25) = NaN;

    % Element 12
    ppsdata(:,12) = NaN;
    baselinedata(:,12) = NaN;

    % Element 13
    ppsdata(:,13) = NaN;
    baselinedata(:,13) = NaN;

    % Element 11
    ppsdata(:,11) = NaN;
    baselinedata(:,11) = NaN;

    % Element 9
    ppsdata(:,9) = NaN;
    baselinedata(:,9) = NaN;

    % Element 10
    ppsdata(:,10) = NaN;
    baselinedata(:,10) = NaN;


    % Mat 2
    % Element 497
    ppsdata(:,497) = NaN;
    baselinedata(:,497) = NaN;

    % Element 481
    ppsdata(:,481) = NaN;
    baselinedata(:,481) = NaN;

    % Element 465
    ppsdata(:,465) = NaN;
    baselinedata(:,465) = NaN;

    % Element 449
    ppsdata(:,449) = NaN;
    baselinedata(:,449) = NaN;

    % Element 433
    ppsdata(:,433) = NaN;
    baselinedata(:,433) = NaN;

    % Element 417
    ppsdata(:,417) = NaN;
    baselinedata(:,417) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;
    baselinedata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;
    baselinedata(:,482) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;
    baselinedata(:,466) = NaN;

    % Element 450
    ppsdata(:,450) = NaN;
    baselinedata(:,450) = NaN;

    % Element 434
    ppsdata(:,434) = NaN;
    baselinedata(:,434) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;
    baselinedata(:,386) = NaN;

    % Element 370
    ppsdata(:,370) = NaN;
    baselinedata(:,370) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;
    baselinedata(:,354) = NaN;

   % Element 499
    ppsdata(:,499) = NaN;
    baselinedata(:,499) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;
    baselinedata(:,483) = NaN;

    % Element 387
    ppsdata(:,387) = NaN;
    baselinedata(:,387) = NaN;

    % Element 371
    ppsdata(:,371) = NaN;
    baselinedata(:,371) = NaN;

    % Element 472
    ppsdata(:,472) = NaN;
    baselinedata(:,472) = NaN;

    % Element 471
    ppsdata(:,471) = NaN;
    baselinedata(:,471) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;
    baselinedata(:,467) = NaN;

    % Element 339
    ppsdata(:,339) = NaN;
    baselinedata(:,339) = NaN;

    % Element 485
    ppsdata(:,485) = NaN;
    baselinedata(:,485) = NaN;

    % Element 470
    ppsdata(:,470) = NaN;
    baselinedata(:,470) = NaN;

   % Element 473
    ppsdata(:,473) = NaN;
    baselinedata(:,473) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;
    baselinedata(:,365) = NaN;

    % Element 398
    ppsdata(:,398) = NaN;
    baselinedata(:,398) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;
    baselinedata(:,382) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;
    baselinedata(:,366) = NaN;


   % Element 512
    ppsdata(:,512) = NaN;
    baselinedata(:,512) = NaN;

    % Element 448
    ppsdata(:,448) = NaN;
    baselinedata(:,448) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;
    baselinedata(:,496) = NaN;

    % Element 336
    ppsdata(:,336) = NaN;
    baselinedata(:,336) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;
    baselinedata(:,352) = NaN;

    % Element 474
    ppsdata(:,474) = NaN;
    baselinedata(:,474) = NaN;

    else 

    % Non Paretic Arm RIGHT 
    % Mat 2
    % Element 497
    ppsdata(:,497) = NaN;
    baselinedata(:,497) = NaN;

    % Element 481
    ppsdata(:,481) = NaN;
    baselinedata(:,481) = NaN;

    % Element 465
    ppsdata(:,465) = NaN;
    baselinedata(:,465) = NaN;

    % Element 449
    ppsdata(:,449) = NaN;
    baselinedata(:,449) = NaN;

    % Element 433
    ppsdata(:,433) = NaN;
    baselinedata(:,433) = NaN;

    % Element 417
    ppsdata(:,417) = NaN;
    baselinedata(:,417) = NaN;

    % Element 401
    ppsdata(:,401) = NaN;
    baselinedata(:,401) = NaN;

    % Element 385
    ppsdata(:,385) = NaN;
    baselinedata(:,385) = NaN;

    % Element 369
    ppsdata(:,369) = NaN;
    baselinedata(:,369) = NaN;

    % Element 353
    ppsdata(:,353) = NaN;
    baselinedata(:,353) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;
    baselinedata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;
    baselinedata(:,482) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;
    baselinedata(:,466) = NaN;

    % Element 450
    ppsdata(:,450) = NaN;
    baselinedata(:,450) = NaN;

   % Element 434
    ppsdata(:,434) = NaN;
    baselinedata(:,434) = NaN;

    % Element 418
    ppsdata(:,418) = NaN;
    baselinedata(:,418) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;
    baselinedata(:,386) = NaN;

    % Element 402
    ppsdata(:,402) = NaN;
    baselinedata(:,402) = NaN;

    % Element 370
    ppsdata(:,370) = NaN;
    baselinedata(:,370) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;
    baselinedata(:,354) = NaN;

    % Element 338
    ppsdata(:,338) = NaN;
    baselinedata(:,338) = NaN;

    % Element 499
    ppsdata(:,499) = NaN;
    baselinedata(:,499) = NaN;

    % Element 387
    ppsdata(:,387) = NaN;
    baselinedata(:,387) = NaN;

    % Element 371
    ppsdata(:,371) = NaN;
    baselinedata(:,371) = NaN;

   % Element 500
    ppsdata(:,500) = NaN;
    baselinedata(:,500) = NaN;

    % Element 501
    ppsdata(:,501) = NaN;
    baselinedata(:,501) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;
    baselinedata(:,483) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;
    baselinedata(:,467) = NaN;

    % Element 451
    ppsdata(:,451) = NaN;
    baselinedata(:,451) = NaN;


   % Element 435
    ppsdata(:,435) = NaN;
    baselinedata(:,435) = NaN;

    % Element 419
    ppsdata(:,419) = NaN;
    baselinedata(:,419) = NaN;

    % Element 339
    ppsdata(:,339) = NaN;
    baselinedata(:,339) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;
    baselinedata(:,266) = NaN;

    % Element 351
    ppsdata(:,351) = NaN;
    baselinedata(:,351) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;
    baselinedata(:,352) = NaN;

    end 
end


%%
ppsdata=data; % for not removing dead elements from trials

baseline_mat1 = ppsdata(:,1:256);
baseline_mat2 = ppsdata(:,257:end);
baseline_t = t;
nframes = length(baseline_t);
%%
Pressuremat2_frame= zeros(16,16,nframes);
Pressuremat1_frame= zeros(16,16,nframes);


%Reshaping and populating matrix to correspond to layout of the mat 
for i=1:nframes
Pressuremat2_frame(:,:,i) =flipud(reshape(baseline_mat2(i,:),[16,16])'); 
Pressuremat1_frame(:,:,i) =flipud(reshape(baseline_mat1(i,:),[16,16])'); 

end

% Averaging the baseline file across all frames
Pressuremat2_Baseline_Final = mean(Pressuremat2_frame,3);
Pressuremat1_Baseline_Final = mean(Pressuremat1_frame,3);

% Setting Any Values that are 0 to Nans

% Pressuremat2_Baseline_Final(Pressuremat2_Baseline_Final == 0) = NaN;

  %%  Contour Plot 

  contourf(Pressuremat2_Baseline_Final)
colorbar 


