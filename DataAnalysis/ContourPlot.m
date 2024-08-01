%% Plotting Contour of Baseline - July 2024 

% Load in baseline file 
ppsdata=data;

%% Removing Dead Elements for Test Particpant RTIS1004
% Mat 1
% if strcmp(partid,'RTIS1004')

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


% end


%%
baseline_mat1 = ppsdata(:,1:256);
baseline_mat2 = ppsdata(:,257:end);
baseline_t = t;

Pressuremat2_frame= zeros(16,16,nframes);
nframes = length(baseline_t);

%Reshaping and populating matrix to correspond to layout of the mat 
for i=1:nframes
Pressuremat2_frame(:,:,i) =flipud(reshape(baseline_mat2(i,:),[16,16])'); 
end

% Averaging the baseline file across all frames
Pressuremat2_Baseline_Final = mean(Pressuremat2_frame,3);

% Setting Any Values that are 0 to Nans

Pressuremat2_Baseline_Final(Pressuremat2_Baseline_Final == 0) = NaN;

%     %%  Contour Plot 
