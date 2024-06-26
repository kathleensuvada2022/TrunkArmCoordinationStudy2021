% June 2024 
% K. Suvada

% Function that sets any faulty elements to NaN. Using the Small multiples
% plot in Process_PPS, identify any dead elements (horizontal line) or odd
% waveforms. 

% Output : New PPSdata matrix with NaNs where faulty elements are. 


function ppsdata_clean = CleanPPSElem(ppsdata,tpps,t_start,t_end,hand,partid,mtrial_Num,filename,expcond)

%% Controls
    if strcmp(partid,'RTIS1003')
     
        % Mat 1
      
        % Element 1
        ppsdata(:,1) = NaN;
        
        % Element 8
        ppsdata(:,8) = NaN;

        % Element 9
        ppsdata(:,9) = NaN;

        % Element 24
        ppsdata(:,24) = NaN;

        % Element 162
        ppsdata(:,162) = NaN;

        % Element 177
        ppsdata(:,177) = NaN;

        % Element 178
        ppsdata(:,178) = NaN;

        % Element 193
        ppsdata(:,193) = NaN;

        % Element 194
        ppsdata(:,194) = NaN;


        % Mat 2

        % Element 353
        ppsdata(:,353) = NaN;
        
        % Element 498
        ppsdata(:,498) = NaN;

        % Element 354
        ppsdata(:,354) = NaN;

        % Element 499
        ppsdata(:,499) = NaN;

        % Element 355
        ppsdata(:,355) = NaN;

        % Element 500
        ppsdata(:,500) = NaN;

        % Element 356
        ppsdata(:,356) = NaN;

        % Element 389
        ppsdata(:,389) = NaN;

        % Element 357
        ppsdata(:,357) = NaN;

        % Element 358
        ppsdata(:,358) = NaN;

        % Element 503
        ppsdata(:,503) = NaN;

        % Element 359
        ppsdata(:,359) = NaN;

        % Element 504
        ppsdata(:,504) = NaN;

        % Element 360
        ppsdata(:,360) = NaN;

        % Element 388
        ppsdata(:,388) = NaN;


        % Element 505
        ppsdata(:,505) = NaN;
        
        % Element 361
        ppsdata(:,361) = NaN;

        % Element 362
        ppsdata(:,362) = NaN;

        % Element 363
        ppsdata(:,363) = NaN;

        % Element 364
        ppsdata(:,364) = NaN;

        % Element 509
        ppsdata(:,509) = NaN;

        % Element 365
        ppsdata(:,365) = NaN;

        % Element 366
        ppsdata(:,366) = NaN;

        % Element 511
        ppsdata(:,511) = NaN;

        % Element 495
        ppsdata(:,495) = NaN;
        
        % Element 479
        ppsdata(:,479) = NaN;

        % Element 463
        ppsdata(:,463) = NaN;

        % Element 447
        ppsdata(:,447) = NaN;

        % Element 431
        ppsdata(:,431) = NaN;

        % Element 415
        ppsdata(:,415) = NaN;

        % Element 399
        ppsdata(:,399) = NaN;

        % Element 383
        ppsdata(:,383) = NaN;

        % Element 367
        ppsdata(:,367) = NaN;

        % Element 351
        ppsdata(:,351) = NaN;

        % Element 335
        ppsdata(:,335) = NaN;

        % Element 319
        ppsdata(:,319) = NaN;

        % Element 303
        ppsdata(:,303) = NaN;

        % Element 287
        ppsdata(:,287) = NaN;

        % Element 271
        ppsdata(:,271) = NaN;

        % Element 368
        ppsdata(:,368) = NaN;

        % Element 380
        ppsdata(:,380) = NaN;

        % Element 352
        ppsdata(:,352) = NaN;

        % Element 336
        ppsdata(:,336) = NaN;
    end 


% RTIS1004

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


if strcmp(partid,'RTIS1005')

    % Mat 1

    % Element 178
    ppsdata(:,178) = NaN;

    % Element 162
    ppsdata(:,162) = NaN;

    % Element 210
    ppsdata(:,210) = NaN;

    % Element 242
    ppsdata(:,242) = NaN;

    % Element 226
    ppsdata(:,226) = NaN;

    % Element 194
    ppsdata(:,194) = NaN;

    % Element 193
    ppsdata(:,193) = NaN;

    % Element 211
    ppsdata(:,211) = NaN;

    % Element 195
    ppsdata(:,195) = NaN;

    % Element 161
    ppsdata(:,161) = NaN;

    % Element 146
    ppsdata(:,146) = NaN;

    % Element 130
    ppsdata(:,130) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;

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

    % Element 385
    ppsdata(:,385) = NaN;

    % Element 369
    ppsdata(:,369) = NaN;

    % Element 353
    ppsdata(:,353) = NaN;

    % Element 337
    ppsdata(:,337) = NaN;

    % Element 305
    ppsdata(:,305) = NaN;

    % Element 273
    ppsdata(:,273) = NaN;

    % Element 257
    ppsdata(:,257) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;

    % Element 450
    ppsdata(:,450) = NaN;

    % Element 434
    ppsdata(:,434) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;

    % Element 370
    ppsdata(:,370) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;

    % Element 321
    ppsdata(:,321) = NaN;

    % Element 487
    ppsdata(:,487) = NaN;

    % Element 338
    ppsdata(:,338) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;

    % Element 418
    ppsdata(:,418) = NaN;

    % Element 402
    ppsdata(:,402) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;

    % Element 502
    ppsdata(:,502) = NaN;

    % Element 507
    ppsdata(:,507) = NaN;

    % Element 491
    ppsdata(:,491) = NaN;

    % Element 475
    ppsdata(:,475) = NaN;

    % Element 459
    ppsdata(:,459) = NaN;

    % Element 443
    ppsdata(:,443) = NaN;

    % Element 427
    ppsdata(:,427) = NaN;

    % Element 411
    ppsdata(:,411) = NaN;

    % Element 395
    ppsdata(:,395) = NaN;

    % Element 379
    ppsdata(:,379) = NaN;

    % Element 363
    ppsdata(:,363) = NaN;

    % Element 347
    ppsdata(:,347) = NaN;

    % Element 331
    ppsdata(:,331) = NaN;

    % Element 315
    ppsdata(:,315) = NaN;

    % Element 299
    ppsdata(:,299) = NaN;

    % Element 283
    ppsdata(:,283) = NaN;

    % Element 267
    ppsdata(:,267) = NaN;

    % Element 268
    ppsdata(:,268) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;

    % Element 350
    ppsdata(:,350) = NaN;

    % Element 464
    ppsdata(:,464) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;

    % Element 489
    ppsdata(:,489) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
end



        

%% Stroke






% creating new matrix once replaces bad elements with NaNs

ppsdata_clean = ppsdata;

end