% June 2024 
% K. Suvada

% Function that sets any faulty elements to NaN in both the trial and the baseline file. Using the Small multiples
% plot in Process_PPS, identify any dead elements (horizontal line) or odd
% waveforms. 

% Output : New PPSdata matrix with NaNs where faulty elements are. 


function ppsdata_clean = CleanPPSElem(ppsdata,baselinedata_full,tpps,t_start,t_end,hand,partid,mtrial_Num,filename,expcond)

baselinedata = baselinedata_full;

%% Controls
    if strcmp(partid,'RTIS1003')
     
        % Mat 1
      
        % Element 1
        ppsdata(:,1) = NaN;
        baselinedata(:,1) = NaN;

        
        % Element 8
        ppsdata(:,8) = NaN;
        baselinedata(:,8) = NaN;

        % Element 9
        ppsdata(:,9) = NaN;
        baselinedata(:,9) = NaN;

        % Element 24
        ppsdata(:,24) = NaN;
        baselinedata(:,24) = NaN;

        % Element 162
        ppsdata(:,162) = NaN;
        baselinedata(:,162) = NaN;

        % Element 177
        ppsdata(:,177) = NaN;
        baselinedata(:,177) = NaN;

        % Element 178
        ppsdata(:,178) = NaN;
        baselinedata(:,178) = NaN;

        % Element 193
        ppsdata(:,193) = NaN;
        baselinedata(:,193) = NaN;

        % Element 194
        ppsdata(:,194) = NaN;
        baselinedata(:,194) = NaN;


        % Mat 2

        % Element 353
        ppsdata(:,353) = NaN;
        baselinedata(:,353) = NaN;

        % Element 498
        ppsdata(:,498) = NaN;
        baselinedata(:,498) = NaN;

        % Element 354
        ppsdata(:,354) = NaN;
        baselinedata(:,354) = NaN;

        % Element 499
        ppsdata(:,499) = NaN;
        baselinedata(:,499) = NaN;

        % Element 355
        ppsdata(:,355) = NaN;
        baselinedata(:,355) = NaN;

        % Element 500
        ppsdata(:,500) = NaN;
        baselinedata(:,500) = NaN;

        % Element 356
        ppsdata(:,356) = NaN;
        baselinedata(:,356) = NaN;

        % Element 389
        ppsdata(:,389) = NaN;
        baselinedata(:,389) = NaN;

        % Element 357
        ppsdata(:,357) = NaN;
        baselinedata(:,357) = NaN;

        % Element 358
        ppsdata(:,358) = NaN;
        baselinedata(:,358) = NaN;

        % Element 503
        ppsdata(:,503) = NaN;
        baselinedata(:,503) = NaN;

        % Element 359
        ppsdata(:,359) = NaN;
        baselinedata(:,359) = NaN;

        % Element 504
        ppsdata(:,504) = NaN;
        baselinedata(:,504) = NaN;

        % Element 360
        ppsdata(:,360) = NaN;
        baselinedata(:,360) = NaN;

        % Element 388
        ppsdata(:,388) = NaN;
        baselinedata(:,388) = NaN;

        % Element 505
        ppsdata(:,505) = NaN;
        baselinedata(:,505) = NaN;

        % Element 361
        ppsdata(:,361) = NaN;
        baselinedata(:,361) = NaN;

        % Element 362
        ppsdata(:,362) = NaN;
        baselinedata(:,362) = NaN;


        % Element 363
        ppsdata(:,363) = NaN;
        baselinedata(:,363) = NaN;

        % Element 364
        ppsdata(:,364) = NaN;
        baselinedata(:,364) = NaN;

        % Element 509
        ppsdata(:,509) = NaN;
        baselinedata(:,509) = NaN;

        % Element 365
        ppsdata(:,365) = NaN;
        baselinedata(:,365) = NaN;

        % Element 366
        ppsdata(:,366) = NaN;
        baselinedata(:,366) = NaN;

        % Element 511
        ppsdata(:,511) = NaN;
        baselinedata(:,511) = NaN;

        % Element 495
        ppsdata(:,495) = NaN;
        baselinedata(:,495) = NaN;

        % Element 479
        ppsdata(:,479) = NaN;
        baselinedata(:,479) = NaN;


        % Element 463
        ppsdata(:,463) = NaN;
        baselinedata(:,463) = NaN;

        % Element 447
        ppsdata(:,447) = NaN;
        baselinedata(:,447) = NaN;


        % Element 431
        ppsdata(:,431) = NaN;
        baselinedata(:,431) = NaN;


        % Element 415
        ppsdata(:,415) = NaN;
        baselinedata(:,415) = NaN;


        % Element 399
        ppsdata(:,399) = NaN;
        baselinedata(:,399) = NaN;

        % Element 383
        ppsdata(:,383) = NaN;
        baselinedata(:,383) = NaN;

        % Element 367
        ppsdata(:,367) = NaN;
        baselinedata(:,367) = NaN;


        % Element 351
        ppsdata(:,351) = NaN;
        baselinedata(:,351) = NaN;


        % Element 335
        ppsdata(:,335) = NaN;
        baselinedata(:,335) = NaN;


        % Element 319
        ppsdata(:,319) = NaN;
        baselinedata(:,319) = NaN;


        % Element 303
        ppsdata(:,303) = NaN;
        baselinedata(:,303) = NaN;


        % Element 287
        ppsdata(:,287) = NaN;
        baselinedata(:,287) = NaN;


        % Element 271
        ppsdata(:,271) = NaN;
        baselinedata(:,271) = NaN;


        % Element 368
        ppsdata(:,368) = NaN;
        baselinedata(:,368) = NaN;


        % Element 380
        ppsdata(:,380) = NaN;
        baselinedata(:,380) = NaN;


        % Element 352
        ppsdata(:,352) = NaN;
        baselinedata(:,352) = NaN;


        % Element 336
        ppsdata(:,336) = NaN;
        baselinedata(:,336) = NaN;

    end 


% RTIS1004

% Mat 1
if strcmp(partid,'RTIS1004')

       % Element 23
        ppsdata(:,23) = NaN;
        baselinedata(:,23) = NaN;

        
        % Element 39
        ppsdata(:,39) = NaN;
        baselinedata(:,39) = NaN;


        % Element 40
        ppsdata(:,40) = NaN;
        baselinedata(:,40) = NaN;

        % Element 22
        ppsdata(:,22) = NaN;
        baselinedata(:,22) = NaN;

        % Element 54
        ppsdata(:,54) = NaN;
        baselinedata(:,54) = NaN;

        % Element 25
        ppsdata(:,25) = NaN;
        baselinedata(:,25) = NaN;

        % Element 41
        ppsdata(:,41) = NaN;
        baselinedata(:,41) = NaN;

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


        % Element 482
        ppsdata(:,482) = NaN;
        baselinedata(:,482) = NaN;

        % Element 466
        ppsdata(:,466) = NaN;
        baselinedata(:,466) = NaN;

        % Element 450
        ppsdata(:,450) = NaN;
        baselinedata(:,450) = NaN;

        % Element 354
        ppsdata(:,354) = NaN;
        baselinedata(:,354) = NaN;

        % Element 467
        ppsdata(:,467) = NaN;
        baselinedata(:,467) = NaN;

        % Element 469
        ppsdata(:,469) = NaN;
        baselinedata(:,469) = NaN;

        % Element 487
        ppsdata(:,487) = NaN;
        baselinedata(:,487) = NaN;

        % Element 471
        ppsdata(:,471) = NaN;
        baselinedata(:,471) = NaN;

        % Element 472
        ppsdata(:,472) = NaN;
        baselinedata(:,472) = NaN;

        % Element 273
        ppsdata(:,273) = NaN;
        baselinedata(:,273) = NaN;

        % Element 264
        ppsdata(:,264) = NaN;
        baselinedata(:,264) = NaN;

        % Element 257
        ppsdata(:,257) = NaN;
        baselinedata(:,257) = NaN;

        % Element 455
        ppsdata(:,455) = NaN;
        baselinedata(:,455) = NaN;

        % Element 386
        ppsdata(:,386) = NaN;
        baselinedata(:,386) = NaN;

        % Element 387
        ppsdata(:,387) = NaN;
        baselinedata(:,387) = NaN;

        % Element 501
        ppsdata(:,501) = NaN;
        baselinedata(:,501) = NaN;

        % Element 502
        ppsdata(:,502) = NaN;
        baselinedata(:,502) = NaN;

        % Element 488
        ppsdata(:,488) = NaN;
        baselinedata(:,488) = NaN;

        % Element 434
        ppsdata(:,434) = NaN;
        baselinedata(:,434) = NaN;

        % Element 381
        ppsdata(:,381) = NaN;
        baselinedata(:,381) = NaN;

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

        % Element 479
        ppsdata(:,479) = NaN;
        baselinedata(:,479) = NaN;

        % Element 512
        ppsdata(:,512) = NaN;
        baselinedata(:,512) = NaN;

        % Element 496
        ppsdata(:,496) = NaN;
        baselinedata(:,496) = NaN;


        % Element 368
        ppsdata(:,368) = NaN;
        baselinedata(:,368) = NaN;


        % Element 463
        ppsdata(:,463) = NaN;
        baselinedata(:,463) = NaN;

        % Element 464
        ppsdata(:,464) = NaN;
        baselinedata(:,464) = NaN;

        % Element 473
        ppsdata(:,473) = NaN;
        baselinedata(:,473) = NaN;

        % Element 506
        ppsdata(:,506) = NaN;
        baselinedata(:,506) = NaN;

        % Element 350
        ppsdata(:,350) = NaN;
        baselinedata(:,350) = NaN;


end


if strcmp(partid,'RTIS1005')

    % Mat 1

    % Element 178
    ppsdata(:,178) = NaN;
    baselinedata(:,178) = NaN;

    % Element 162
    ppsdata(:,162) = NaN;
    baselinedata(:,162) = NaN;

    % Element 210
    ppsdata(:,210) = NaN;
    baselinedata(:,210) = NaN;

    % Element 242
    ppsdata(:,242) = NaN;
    baselinedata(:,242) = NaN;

    % Element 226
    ppsdata(:,226) = NaN;
    baselinedata(:,226) = NaN;

    % Element 194
    ppsdata(:,194) = NaN;
    baselinedata(:,194) = NaN;

    % Element 193
    ppsdata(:,193) = NaN;
    baselinedata(:,193) = NaN;

    % Element 211
    ppsdata(:,211) = NaN;
    baselinedata(:,211) = NaN;

    % Element 195
    ppsdata(:,195) = NaN;
    baselinedata(:,195) = NaN;

    % Element 161
    ppsdata(:,161) = NaN;
    baselinedata(:,161) = NaN;

    % Element 146
    ppsdata(:,146) = NaN;
    baselinedata(:,146) = NaN;

    % Element 130
    ppsdata(:,130) = NaN;
    baselinedata(:,130) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;
    baselinedata(:,25) = NaN;

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

    % Element 337
    ppsdata(:,337) = NaN;
    baselinedata(:,337) = NaN;

    % Element 305
    ppsdata(:,305) = NaN;
    baselinedata(:,305) = NaN;

    % Element 273
    ppsdata(:,273) = NaN;
    baselinedata(:,273) = NaN;

    % Element 257
    ppsdata(:,257) = NaN;
    baselinedata(:,257) = NaN;

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

    % Element 321
    ppsdata(:,321) = NaN;
    baselinedata(:,321) = NaN;

    % Element 487
    ppsdata(:,487) = NaN;
    baselinedata(:,487) = NaN;

    % Element 338
    ppsdata(:,338) = NaN;
    baselinedata(:,338) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;
    baselinedata(:,467) = NaN;

    % Element 418
    ppsdata(:,418) = NaN;
    baselinedata(:,418) = NaN;

    % Element 402
    ppsdata(:,402) = NaN;
    baselinedata(:,402) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;
    baselinedata(:,483) = NaN;

    % Element 502
    ppsdata(:,502) = NaN;
    baselinedata(:,502) = NaN;

    % Element 507
    ppsdata(:,507) = NaN;
    baselinedata(:,507) = NaN;

    % Element 491
    ppsdata(:,491) = NaN;
    baselinedata(:,491) = NaN;

    % Element 475
    ppsdata(:,475) = NaN;
    baselinedata(:,475) = NaN;

    % Element 459
    ppsdata(:,459) = NaN;
    baselinedata(:,459) = NaN;

    % Element 443
    ppsdata(:,443) = NaN;
    baselinedata(:,443) = NaN;

    % Element 427
    ppsdata(:,427) = NaN;
    baselinedata(:,427) = NaN;

    % Element 411
    ppsdata(:,411) = NaN;
    baselinedata(:,411) = NaN;

    % Element 395
    ppsdata(:,395) = NaN;
    baselinedata(:,395) = NaN;

    % Element 379
    ppsdata(:,379) = NaN;
    baselinedata(:,379) = NaN;

    % Element 363
    ppsdata(:,363) = NaN;
    baselinedata(:,363) = NaN;

    % Element 347
    ppsdata(:,347) = NaN;
    baselinedata(:,347) = NaN;

    % Element 331
    ppsdata(:,331) = NaN;
    baselinedata(:,331) = NaN;

    % Element 315
    ppsdata(:,315) = NaN;
    baselinedata(:,315) = NaN;

    % Element 299
    ppsdata(:,299) = NaN;
    baselinedata(:,299) = NaN;

    % Element 283
    ppsdata(:,283) = NaN;
    baselinedata(:,283) = NaN;

    % Element 267
    ppsdata(:,267) = NaN;
    baselinedata(:,267) = NaN;

    % Element 268
    ppsdata(:,268) = NaN;
    baselinedata(:,268) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;
    baselinedata(:,473) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;
    baselinedata(:,366) = NaN;

    % Element 350
    ppsdata(:,350) = NaN;
    baselinedata(:,350) = NaN;

    % Element 464
    ppsdata(:,464) = NaN;
    baselinedata(:,464) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;
    baselinedata(:,496) = NaN;

    % Element 489
    ppsdata(:,489) = NaN;
    baselinedata(:,489) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

end

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

        

%% Stroke


if strcmp(partid,'RTIS2001')

    if strcmp(hand,'Right') % Paretic 

    % Element 193
    ppsdata(:,193) = NaN;
    baselinedata(:,193) = NaN;

    % Element 161
    ppsdata(:,161) = NaN;
    baselinedata(:,161) = NaN;

    % Element 242
    ppsdata(:,242) = NaN;
    baselinedata(:,242) = NaN;

    % Element 226
    ppsdata(:,226) = NaN;
    baselinedata(:,354) = NaN;

    % Element 210
    ppsdata(:,210) = NaN;
    baselinedata(:,210) = NaN;

    % Element 178
    ppsdata(:,178) = NaN;
    baselinedata(:,178) = NaN;

    % Element 162
    ppsdata(:,162) = NaN;
    baselinedata(:,162) = NaN;

    % Element 209
    ppsdata(:,209) = NaN;
    baselinedata(:,209) = NaN;

    % Element 241
    ppsdata(:,241) = NaN;
    baselinedata(:,241) = NaN;

    % Element 225
    ppsdata(:,225) = NaN;
    baselinedata(:,225) = NaN;

    % Element 129
    ppsdata(:,129) = NaN;
    baselinedata(:,129) = NaN;

    % Element 113
    ppsdata(:,113) = NaN;
    baselinedata(:,113) = NaN;

    % Element 194
    ppsdata(:,194) = NaN;
    baselinedata(:,194) = NaN;

    % Element 146
    ppsdata(:,146) = NaN;
    baselinedata(:,146) = NaN;

    % Element 130
    ppsdata(:,130) = NaN;
    baselinedata(:,130) = NaN;

    % Element 114
    ppsdata(:,114) = NaN;
    baselinedata(:,114) = NaN;

    % Element 66
    ppsdata(:,66) = NaN;
    baselinedata(:,66) = NaN;

    % Element 50
    ppsdata(:,50) = NaN;
    baselinedata(:,50) = NaN;

    % Element 243
    ppsdata(:,243) = NaN;
    baselinedata(:,243) = NaN;

    % Element 211
    ppsdata(:,211) = NaN;
    baselinedata(:,211) = NaN;

    % Element 195
    ppsdata(:,195) = NaN;
    baselinedata(:,195) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;
    baselinedata(:,24) = NaN;

    % Element 177
    ppsdata(:,177) = NaN;
    baselinedata(:,177) = NaN;

    % Element 39
    ppsdata(:,39) = NaN;
    baselinedata(:,39) = NaN;

    % Element 145
    ppsdata(:,145) = NaN;
    baselinedata(:,145) = NaN;

     % Element 25
    ppsdata(:,25) = NaN;
    baselinedata(:,25) = NaN;


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

    % Element 369
    ppsdata(:,369) = NaN;
    baselinedata(:,369) = NaN;

    % Element 353
    ppsdata(:,353) = NaN;
    baselinedata(:,353) = NaN;

    % Element 337
    ppsdata(:,337) = NaN;
    baselinedata(:,337) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;
    baselinedata(:,466) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;
    baselinedata(:,354) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;
    baselinedata(:,264) = NaN;

    % Element 385
    ppsdata(:,385) = NaN;
    baselinedata(:,385) = NaN;

    % Element 321
    ppsdata(:,321) = NaN;
    baselinedata(:,321) = NaN;

    % Element 305
    ppsdata(:,305) = NaN;
    baselinedata(:,305) = NaN;

    % Element 273
    ppsdata(:,273) = NaN;
    baselinedata(:,273) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;
    baselinedata(:,482) = NaN;

    % Element 338
    ppsdata(:,338) = NaN;
    baselinedata(:,338) = NaN;

    % Element 263
    ppsdata(:,263) = NaN;
    baselinedata(:,263) = NaN;

    % Element 274
    ppsdata(:,274) = NaN;
    baselinedata(:,274) = NaN;

    % Element 398
    ppsdata(:,398) = NaN;
    baselinedata(:,398) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;
    baselinedata(:,382) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;
    baselinedata(:,366) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;
    baselinedata(:,473) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;
    baselinedata(:,365) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;
    baselinedata(:,352) = NaN;

    % Element 336
    ppsdata(:,336) = NaN;
    baselinedata(:,336) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;
    baselinedata(:,512) = NaN;

    else

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

    % Element 6
    ppsdata(:,6) = NaN;
    baselinedata(:,6) = NaN;

    % Element 7
    ppsdata(:,7) = NaN;
    baselinedata(:,7) = NaN;

    % Element 8
    ppsdata(:,8) = NaN;
    baselinedata(:,8) = NaN;

    % Element 9
    ppsdata(:,9) = NaN;
    baselinedata(:,9) = NaN;

    % Element 11
    ppsdata(:,11) = NaN;
    baselinedata(:,11) = NaN;

    % Element 12
    ppsdata(:,12) = NaN;
    baselinedata(:,12) = NaN;

    % Element 14
    ppsdata(:,14) = NaN;
    baselinedata(:,14) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;
    baselinedata(:,15) = NaN;

    % Element 16
    ppsdata(:,16) = NaN;
    baselinedata(:,16) = NaN;

    % Element 13
    ppsdata(:,13) = NaN;
    baselinedata(:,13) = NaN;

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

    % Element 305
    ppsdata(:,305) = NaN;
    baselinedata(:,305) = NaN;

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

    % Element 370
    ppsdata(:,370) = NaN;
    baselinedata(:,370) = NaN;
  
    % Element 354
    ppsdata(:,354) = NaN;
    baselinedata(:,354) = NaN;

    % Element 338
    ppsdata(:,338) = NaN;
    baselinedata(:,338) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;
    baselinedata(:,483) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;
    baselinedata(:,264) = NaN;

    % Element 337
    ppsdata(:,337) = NaN;
    baselinedata(:,337) = NaN;

    % Element 321
    ppsdata(:,321) = NaN;
    baselinedata(:,321) = NaN;

    % Element 273
    ppsdata(:,273) = NaN;
    baselinedata(:,273) = NaN;

    % Element 402
    ppsdata(:,402) = NaN;
    baselinedata(:,402) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;
    baselinedata(:,467) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;
    baselinedata(:,266) = NaN;

    % Element 316
    ppsdata(:,316) = NaN;
    baselinedata(:,316) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;
    baselinedata(:,366) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;
    baselinedata(:,352) = NaN;

    % Element 336
    ppsdata(:,336) = NaN;
    baselinedata(:,336) = NaN;


    end
end


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


if strcmp(partid,'RTIS2003')
    if strcmp(hand,'Left') % Paretic 

    % Mat 1 

    % Element 193
    ppsdata(:,193) = NaN;
    baselinedata(:,193) = NaN;

    % Element 243
    ppsdata(:,243) = NaN;
    baselinedata(:,243) = NaN;

    % Element 227
    ppsdata(:,227) = NaN;
    baselinedata(:,227) = NaN;

    % Element 211
    ppsdata(:,211) = NaN;
    baselinedata(:,211) = NaN;

    % Element 195
    ppsdata(:,195) = NaN;
    baselinedata(:,195) = NaN;

    % Element 179
    ppsdata(:,179) = NaN;
    baselinedata(:,179) = NaN;

    % Element 163
    ppsdata(:,163) = NaN;
    baselinedata(:,163) = NaN;

    % Element 147
    ppsdata(:,147) = NaN;
    baselinedata(:,147) = NaN;

    % Element 131
    ppsdata(:,131) = NaN;
    baselinedata(:,131) = NaN;

    % Element 115
    ppsdata(:,115) = NaN;
    baselinedata(:,115) = NaN;

    % Element 99
    ppsdata(:,99) = NaN;
    baselinedata(:,99) = NaN;

    % Element 83
    ppsdata(:,83) = NaN;
    baselinedata(:,83) = NaN;

    % Element 67
    ppsdata(:,67) = NaN;
    baselinedata(:,67) = NaN;

    % Element 51
    ppsdata(:,51) = NaN;
    baselinedata(:,51) = NaN;

    % Element 35
    ppsdata(:,35) = NaN;
    baselinedata(:,35) = NaN;

    % Element 19
    ppsdata(:,19) = NaN;
    baselinedata(:,19) = NaN;

    % Element 3
    ppsdata(:,3) = NaN;
    baselinedata(:,3) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;
    baselinedata(:,24) = NaN;

    % Element 161
    ppsdata(:,161) = NaN;
    baselinedata(:,161) = NaN;

    % Element 23
    ppsdata(:,23) = NaN;
    baselinedata(:,23) = NaN;

    % Element 177
    ppsdata(:,177) = NaN;
    baselinedata(:,177) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;
    baselinedata(:,25) = NaN;

    % Element 255
    ppsdata(:,255) = NaN;
    baselinedata(:,255) = NaN;

    % Element 239
    ppsdata(:,239) = NaN;
    baselinedata(:,239) = NaN;

    % Element 223
    ppsdata(:,223) = NaN;
    baselinedata(:,223) = NaN;

    % Element 207
    ppsdata(:,207) = NaN;
    baselinedata(:,207) = NaN;

    % Element 191
    ppsdata(:,191) = NaN;
    baselinedata(:,191) = NaN;

    % Element 175
    ppsdata(:,175) = NaN;
    baselinedata(:,175) = NaN;

    % Element 159
    ppsdata(:,159) = NaN;
    baselinedata(:,159) = NaN;

    % Element 143
    ppsdata(:,143) = NaN;
    baselinedata(:,143) = NaN;

    % Element 127
    ppsdata(:,127) = NaN;
    baselinedata(:,127) = NaN;

    % Element 111
    ppsdata(:,111) = NaN;
    baselinedata(:,111) = NaN;

    % Element 95    baselinedata(:,498) = NaN;

    ppsdata(:,95) = NaN;
    baselinedata(:,95) = NaN;

    % Element 79
    ppsdata(:,79) = NaN;
    baselinedata(:,79) = NaN;

    % Element 63
    ppsdata(:,63) = NaN;
    baselinedata(:,63) = NaN;

   % Element 47
    ppsdata(:,47) = NaN;
    baselinedata(:,47) = NaN;

    % Element 31
    ppsdata(:,31) = NaN;
    baselinedata(:,31) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;
    baselinedata(:,15) = NaN;

    % Mat 2 

    % Element 353
    ppsdata(:,353) = NaN;
    baselinedata(:,353) = NaN;

    % Element 305
    ppsdata(:,305) = NaN;
    baselinedata(:,305) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;
    baselinedata(:,498) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;
    baselinedata(:,354) = NaN;

    % Element 306
    ppsdata(:,306) = NaN;
    baselinedata(:,306) = NaN;

    % Element 499
    ppsdata(:,499) = NaN;
    baselinedata(:,499) = NaN;

    % Element 355
    ppsdata(:,355) = NaN;
    baselinedata(:,355) = NaN;

    % Element 307
    ppsdata(:,307) = NaN;
    baselinedata(:,307) = NaN;

    % Element 500
    ppsdata(:,500) = NaN;
    baselinedata(:,500) = NaN;

    % Element 356
    ppsdata(:,356) = NaN;
    baselinedata(:,356) = NaN;

    % Element 308
    ppsdata(:,308) = NaN;
    baselinedata(:,308) = NaN;

    % Element 501
    ppsdata(:,501) = NaN;
    baselinedata(:,501) = NaN;

    % Element 485
    ppsdata(:,485) = NaN;
    baselinedata(:,485) = NaN;

    % Element 469
    ppsdata(:,469) = NaN;
    baselinedata(:,469) = NaN;

    % Element 453
    ppsdata(:,453) = NaN;
    baselinedata(:,453) = NaN;

    % Element 437
    ppsdata(:,437) = NaN;
    baselinedata(:,437) = NaN;

    % Element 421
    ppsdata(:,421) = NaN;
    baselinedata(:,421) = NaN;

    % Element 405
    ppsdata(:,405) = NaN;
    baselinedata(:,405) = NaN;

    % Element 389
    ppsdata(:,389) = NaN;
    baselinedata(:,389) = NaN;

    % Element 373
    ppsdata(:,373) = NaN;
    baselinedata(:,373) = NaN;

    % Element 357
    ppsdata(:,357) = NaN;
    baselinedata(:,357) = NaN;

    % Element 341
    ppsdata(:,341) = NaN;
    baselinedata(:,341) = NaN;

    % Element 325
    ppsdata(:,325) = NaN;
    baselinedata(:,325) = NaN;

    % Element 309
    ppsdata(:,309) = NaN;
    baselinedata(:,309) = NaN;

    % Element 293
    ppsdata(:,293) = NaN;
    baselinedata(:,293) = NaN;

    % Element 277
    ppsdata(:,277) = NaN;
    baselinedata(:,277) = NaN;

    % Element 261
    ppsdata(:,261) = NaN;
    baselinedata(:,261) = NaN;

    % Element 503
    ppsdata(:,503) = NaN;
    baselinedata(:,503) = NaN;

    % Element 359
    ppsdata(:,359) = NaN;
    baselinedata(:,359) = NaN;

    % Element 311
    ppsdata(:,311) = NaN;
    baselinedata(:,311) = NaN;

    % Element 504
    ppsdata(:,504) = NaN;
    baselinedata(:,504) = NaN;

    % Element 488
    ppsdata(:,488) = NaN;
    baselinedata(:,488) = NaN;

    % Element 360
    ppsdata(:,360) = NaN;
    baselinedata(:,360) = NaN;

    % Element 312
    ppsdata(:,312) = NaN;
    baselinedata(:,312) = NaN;

    % Element 358
    ppsdata(:,358) = NaN;
    baselinedata(:,358) = NaN;

   % Element 310
    ppsdata(:,310) = NaN;
    baselinedata(:,310) = NaN;

    % Element 505
    ppsdata(:,505) = NaN;
    baselinedata(:,505) = NaN;

    % Element 361
    ppsdata(:,361) = NaN;
    baselinedata(:,361) = NaN;

    % Element 313
    ppsdata(:,313) = NaN;
    baselinedata(:,313) = NaN;

    % Element 362
    ppsdata(:,362) = NaN;
    baselinedata(:,362) = NaN;

    % Element 314
    ppsdata(:,314) = NaN;
    baselinedata(:,314) = NaN;

    % Element 363
    ppsdata(:,363) = NaN;
    baselinedata(:,363) = NaN;

    % Element 315
    ppsdata(:,315) = NaN;
    baselinedata(:,315) = NaN;

    % Element 364
    ppsdata(:,364) = NaN;
    baselinedata(:,364) = NaN;

    % Element 316
    ppsdata(:,316) = NaN;
    baselinedata(:,316) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;
    baselinedata(:,365) = NaN;

    % Element 317
    ppsdata(:,317) = NaN;
    baselinedata(:,317) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;
    baselinedata(:,366) = NaN;

    % Element 318
    ppsdata(:,318) = NaN;
    baselinedata(:,318) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;
    baselinedata(:,511) = NaN;

   % Element 367
    ppsdata(:,367) = NaN;
    baselinedata(:,367) = NaN;

    % Element 319
    ppsdata(:,319) = NaN;
    baselinedata(:,319) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;
    baselinedata(:,512) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 320
    ppsdata(:,320) = NaN;
    baselinedata(:,320) = NaN;

    % Element 506
    ppsdata(:,506) = NaN;
    baselinedata(:,506) = NaN;



    else 

    % Mat 1 

    % Element 243
    ppsdata(:,243) = NaN;
    baselinedata(:,243) = NaN;

    % Element 227
    ppsdata(:,227) = NaN;
    baselinedata(:,227) = NaN;

    % Element 211
    ppsdata(:,211) = NaN;
    baselinedata(:,211) = NaN;

    % Element 195
    ppsdata(:,195) = NaN;
    baselinedata(:,195) = NaN;

    % Element 179
    ppsdata(:,179) = NaN;
    baselinedata(:,179) = NaN;

    % Element 163
    ppsdata(:,163) = NaN;
    baselinedata(:,163) = NaN;

    % Element 147
    ppsdata(:,147) = NaN;
    baselinedata(:,147) = NaN;

    % Element 131
    ppsdata(:,131) = NaN;
    baselinedata(:,131) = NaN;

    % Element 115
    ppsdata(:,115) = NaN;
    baselinedata(:,115) = NaN;

    % Element 99
    ppsdata(:,99) = NaN;
    baselinedata(:,99) = NaN;

    % Element 83
    ppsdata(:,83) = NaN;
    baselinedata(:,83) = NaN;

    % Element 67
    ppsdata(:,67) = NaN;
    baselinedata(:,67) = NaN;

    % Element 51
    ppsdata(:,51) = NaN;
    baselinedata(:,51) = NaN;

    % Element 35
    ppsdata(:,35) = NaN;
    baselinedata(:,35) = NaN;

    % Element 19
    ppsdata(:,19) = NaN;
    baselinedata(:,19) = NaN;

    % Element 3
    ppsdata(:,3) = NaN;
    baselinedata(:,3) = NaN;

    % Mat 2 

    % Element 465
    ppsdata(:,465) = NaN;
    baselinedata(:,465) = NaN;

    % Element 449
    ppsdata(:,449) = NaN;
    baselinedata(:,449) = NaN;

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

    % Element 501
    ppsdata(:,501) = NaN;
    baselinedata(:,501) = NaN;

    % Element 485
    ppsdata(:,485) = NaN;
    baselinedata(:,485) = NaN;

    % Element 469
    ppsdata(:,469) = NaN;
    baselinedata(:,469) = NaN;

    % Element 453
    ppsdata(:,453) = NaN;
    baselinedata(:,453) = NaN;

    % Element 437
    ppsdata(:,437) = NaN;
    baselinedata(:,437) = NaN;

    % Element 421
    ppsdata(:,421) = NaN;
    baselinedata(:,421) = NaN;

    % Element 405
    ppsdata(:,405) = NaN;
    baselinedata(:,405) = NaN;

    % Element 389
    ppsdata(:,389) = NaN;
    baselinedata(:,389) = NaN;

    % Element 373
    ppsdata(:,373) = NaN;
    baselinedata(:,373) = NaN;

    % Element 357
    ppsdata(:,357) = NaN;
    baselinedata(:,357) = NaN;

    % Element 341
    ppsdata(:,341) = NaN;
    baselinedata(:,341) = NaN;

    % Element 325
    ppsdata(:,325) = NaN;
    baselinedata(:,325) = NaN;

    % Element 309
    ppsdata(:,309) = NaN;
    baselinedata(:,309) = NaN;

    % Element 293
    ppsdata(:,293) = NaN;
    baselinedata(:,293) = NaN;

    % Element 277
    ppsdata(:,277) = NaN;
    baselinedata(:,277) = NaN;

    % Element 261
    ppsdata(:,261) = NaN;
    baselinedata(:,261) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;
    baselinedata(:,264) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;
    baselinedata(:,467) = NaN;

    % Element 500
    ppsdata(:,500) = NaN;
    baselinedata(:,500) = NaN;

    % Element 433
    ppsdata(:,433) = NaN;
    baselinedata(:,433) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 448
    ppsdata(:,448) = NaN;
    baselinedata(:,448) = NaN;



    end 
end

if strcmp(partid,'RTIS2006')
    if strcmp(hand,'Right') % Paretic 

    % Mat 1
    % Element 193
    ppsdata(:,193) = NaN;
    baselinedata(:,193) = NaN;

    % Element 161
    ppsdata(:,161) = NaN;
    baselinedata(:,161) = NaN;

    % Element 178
    ppsdata(:,178) = NaN;
    baselinedata(:,178) = NaN;

    % Element 162
    ppsdata(:,162) = NaN;
    baselinedata(:,162) = NaN;

    % Element 210
    ppsdata(:,210) = NaN;
    baselinedata(:,210) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;
    baselinedata(:,25) = NaN;

    % Mat 2

    % Element 417
    ppsdata(:,417) = NaN;
    baselinedata(:,417) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;
    baselinedata(:,498) = NaN;

    % Element 499
    ppsdata(:,499) = NaN;
    baselinedata(:,499) = NaN;

    % Element 502
    ppsdata(:,502) = NaN;
    baselinedata(:,502) = NaN;

    % Element 503
    ppsdata(:,503) = NaN;
    baselinedata(:,503) = NaN;

    % Element 263
    ppsdata(:,263) = NaN;
    baselinedata(:,263) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;
    baselinedata(:,482) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;
    baselinedata(:,466) = NaN;

   % Element 434
    ppsdata(:,434) = NaN;
    baselinedata(:,434) = NaN;

    % Element 487
    ppsdata(:,487) = NaN;
    baselinedata(:,487) = NaN;

    % Element 504
    ppsdata(:,504) = NaN;
    baselinedata(:,504) = NaN;

    % Element 450
    ppsdata(:,450) = NaN;
    baselinedata(:,450) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;
    baselinedata(:,511) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;
    baselinedata(:,365) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;
    baselinedata(:,368) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;
    baselinedata(:,496) = NaN;

    else 

% Non Paretic Limb 

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

    % Element 6
    ppsdata(:,6) = NaN;
    baselinedata(:,6) = NaN;

    % Element 7
    ppsdata(:,7) = NaN;
    baselinedata(:,7) = NaN;

    % Element 8
    ppsdata(:,8) = NaN;
    baselinedata(:,8) = NaN;


    % Element 39
    ppsdata(:,39) = NaN;
    baselinedata(:,39) = NaN;

    % Element 40
    ppsdata(:,40) = NaN;
    baselinedata(:,40) = NaN;

    % Element 23
    ppsdata(:,23) = NaN;
    baselinedata(:,23) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;
    baselinedata(:,24) = NaN;

    % Element 40
    ppsdata(:,40) = NaN;
    baselinedata(:,40) = NaN;

    % Element 9
    ppsdata(:,9) = NaN;
    baselinedata(:,9) = NaN;

    % Element 10
    ppsdata(:,10) = NaN;
    baselinedata(:,10) = NaN;

    % Element 11
    ppsdata(:,11) = NaN;
    baselinedata(:,11) = NaN;

    % Element 12
    ppsdata(:,12) = NaN;
    baselinedata(:,12) = NaN;

    % Element 13
    ppsdata(:,13) = NaN;
    baselinedata(:,13) = NaN;

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

    % Mat 2

   % Element 433
    ppsdata(:,433) = NaN;
    baselinedata(:,433) = NaN;

    % Element 417
    ppsdata(:,417) = NaN;
    baselinedata(:,417) = NaN;

    % Element 401
    ppsdata(:,401) = NaN;
    baselinedata(:,401) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;
    baselinedata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;
    baselinedata(:,482) = NaN;


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

    % Element 485
    ppsdata(:,485) = NaN;
    baselinedata(:,485) = NaN;

    % Element 502
    ppsdata(:,502) = NaN;
    baselinedata(:,502) = NaN;

    % Element 486
    ppsdata(:,486) = NaN;
    baselinedata(:,486) = NaN;

    % Element 470
    ppsdata(:,470) = NaN;
    baselinedata(:,470) = NaN;

    % Element 503
    ppsdata(:,503) = NaN;
    baselinedata(:,503) = NaN;

    % Element 487
    ppsdata(:,487) = NaN;
    baselinedata(:,487) = NaN;

    % Element 471
    ppsdata(:,471) = NaN;
    baselinedata(:,471) = NaN;

    % Element 504
    ppsdata(:,504) = NaN;
    baselinedata(:,504) = NaN;

    % Element 488
    ppsdata(:,488) = NaN;
    baselinedata(:,488) = NaN;

    % Element 472
    ppsdata(:,472) = NaN;
    baselinedata(:,472) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;
    baselinedata(:,264) = NaN;

    % Element 505
    ppsdata(:,505) = NaN;
    baselinedata(:,505) = NaN;

    % Element 489
    ppsdata(:,489) = NaN;
    baselinedata(:,489) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;
    baselinedata(:,473) = NaN;

    % Element 506
    ppsdata(:,506) = NaN;
    baselinedata(:,506) = NaN;

    % Element 490
    ppsdata(:,490) = NaN;
    baselinedata(:,490) = NaN;

    % Element 474
    ppsdata(:,474) = NaN;
    baselinedata(:,474) = NaN;

    % Element 428
    ppsdata(:,428) = NaN;
    baselinedata(:,428) = NaN;


    end 
end


if strcmp(partid,'RTIS2007')
    if strcmp(hand,'Right') % Paretic 

    % Mat 1
    % Element 242
    ppsdata(:,242) = NaN;

    % Element 226
    ppsdata(:,226) = NaN;

    % Element 210
    ppsdata(:,210) = NaN;

    % Element 194
    ppsdata(:,194) = NaN;

    % Element 178
    ppsdata(:,178) = NaN;

    % Element 162
    ppsdata(:,162) = NaN;

    % Element 146
    ppsdata(:,146) = NaN;

    % Element 130
    ppsdata(:,130) = NaN;

    % Element 114
    ppsdata(:,114) = NaN;

    % Element 98
    ppsdata(:,98) = NaN;

    % Element 82
    ppsdata(:,82) = NaN;

    % Element 66
    ppsdata(:,66) = NaN;

    % Element 50
    ppsdata(:,50) = NaN;

    % Element 34
    ppsdata(:,34) = NaN;

    % Element 18
    ppsdata(:,18) = NaN;

    % Element 2
    ppsdata(:,2) = NaN;

    % Mat 2

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

    % Element 481
    ppsdata(:,481) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;

    % Element 401
    ppsdata(:,401) = NaN;

    % Element 497
    ppsdata(:,497) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;

   % Element 365
    ppsdata(:,365) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;

    % Element 336
    ppsdata(:,336) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;

    % Element 267
    ppsdata(:,267) = NaN;

    % Element 268
    ppsdata(:,268) = NaN;


    else % Non Paretic


    % Mat 1
    % Element 178
    ppsdata(:,178) = NaN;

    % Element 162
    ppsdata(:,162) = NaN;

    % Element 39
    ppsdata(:,39) = NaN;

    % Element 40
    ppsdata(:,40) = NaN;

    % Element 23
    ppsdata(:,23) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;

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

   % Element 263
    ppsdata(:,263) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;

    % Element 305
    ppsdata(:,305) = NaN;

    % Element 273
    ppsdata(:,273) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;

    % Element 509
    ppsdata(:,509) = NaN;

    % Element 398
    ppsdata(:,398) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;

   % Element 399
    ppsdata(:,399) = NaN;

    % Element 383
    ppsdata(:,383) = NaN;

    % Element 367
    ppsdata(:,367) = NaN;

    % Element 351
    ppsdata(:,351) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;

    % Element 400
    ppsdata(:,400) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;

     % Element 477
    ppsdata(:,477) = NaN;

    % Element 463
    ppsdata(:,463) = NaN;

    % Element 464
    ppsdata(:,464) = NaN;

    % Element 448
    ppsdata(:,382) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;


    end
end

if strcmp(partid,'RTIS2008')
    if strcmp(hand,'Right') % Paretic 

    % Mat 1
    % Element 24
    ppsdata(:,24) = NaN;

    % Element 39
    ppsdata(:,39) = NaN;

    % Element 40
    ppsdata(:,40) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;

    % Element 242
    ppsdata(:,242) = NaN;

    % Element 226
    ppsdata(:,226) = NaN;

    % Element 210
    ppsdata(:,210) = NaN;

    % Element 178
    ppsdata(:,178) = NaN;

    % Element 211
    ppsdata(:,211) = NaN;

    % Element 195
    ppsdata(:,195) = NaN;

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

    % Element 354
    ppsdata(:,354) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;

    % Element 398
    ppsdata(:,398) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;

   % Element 366
    ppsdata(:,366) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;

    % Element 336
    ppsdata(:,336) = NaN;



    else  % Non Paretic




           % Mat 1
    % Element 193
    ppsdata(:,193) = NaN;

    % Element 1
    ppsdata(:,1) = NaN;

    % Element 2
    ppsdata(:,2) = NaN;

    % Element 242
    ppsdata(:,242) = NaN;

    % Element 226
    ppsdata(:,226) = NaN;

    % Element 210
    ppsdata(:,24) = NaN;

       
    % Element 211
    ppsdata(:,211) = NaN;

    % Element 39
    ppsdata(:,39) = NaN;

    % Element 23
    ppsdata(:,23) = NaN;

    % Element 40
    ppsdata(:,40) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;

    % Element 16
    ppsdata(:,16) = NaN;

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

    % Element 369
    ppsdata(:,369) = NaN;

    % Element 353
    ppsdata(:,353) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;


    % Element 466
    ppsdata(:,466) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;

    % Element 370
    ppsdata(:,370) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;

    % Element 471
    ppsdata(:,471) = NaN;

    % Element 472
    ppsdata(:,472) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;

    % Element 401
    ppsdata(:,401) = NaN;

   % Element 450
    ppsdata(:,450) = NaN;

    % Element 434
    ppsdata(:,434) = NaN;

    % Element 385
    ppsdata(:,385) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;

    % Element 315
    ppsdata(:,315) = NaN;

    % Element 299
    ppsdata(:,299) = NaN;

    % Element 283
    ppsdata(:,283) = NaN;

    % Element 267
    ppsdata(:,267) = NaN;

   % Element 382
    ppsdata(:,382) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;

     % Element 368
    ppsdata(:,368) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;

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



    end 

end 

if strcmp(partid,'RTIS2009')
    if strcmp(hand,'Right') % Paretic 
    % Mat 1
    % Element 40
    ppsdata(:,40) = NaN;

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

    % Element 354
    ppsdata(:,354) = NaN;

    % Element 486
    ppsdata(:,486) = NaN;

    % Element 467
    ppsdata(:,467) = NaN;

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

    % Element 511
    ppsdata(:,511) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;

    else % NP

 % Mat 2

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

    % Element 273
    ppsdata(:,273) = NaN;

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

    % Element 418
    ppsdata(:,418) = NaN;

   % Element 402
    ppsdata(:,402) = NaN;

    % Element 370
    ppsdata(:,370) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;

    % Element 499
    ppsdata(:,499) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;

    % Element 387
    ppsdata(:,387) = NaN;


       % Element 500
    ppsdata(:,500) = NaN;

    % Element 502
    ppsdata(:,502) = NaN;

    % Element 504
    ppsdata(:,504) = NaN;

    % Element 321
    ppsdata(:,321) = NaN;

    % Element 503
    ppsdata(:,503) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;

       % Element 305
    ppsdata(:,305) = NaN;

    % Element 257
    ppsdata(:,257) = NaN;

    % Element 472
    ppsdata(:,472) = NaN;

    % Element 497
    ppsdata(:,497) = NaN;

    % Element 338
    ppsdata(:,338) = NaN;











        % Element 473
    ppsdata(:,473) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;

   % Element 509
    ppsdata(:,509) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;

    % Element 398
    ppsdata(:,398) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;

    % Element 383
    ppsdata(:,383) = NaN;

    % Element 400
    ppsdata(:,400) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

   % Element 352
    ppsdata(:,352) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;

    % Element 399
    ppsdata(:,399) = NaN;

    % Element 351
    ppsdata(:,351) = NaN;

    % Element 448
    ppsdata(:,448) = NaN;

    % Element 490
    ppsdata(:,490) = NaN;


       % Element 474
    ppsdata(:,474) = NaN;

    % Element 367
    ppsdata(:,367) = NaN;

    % Element 464
    ppsdata(:,464) = NaN;

   
    end 
end


if strcmp(partid,'RTIS2010')
  
    if strcmp(hand,'Right') % Paretic 
        % Mat 1
    % Element 39
    ppsdata(:,39) = NaN;

    % Element 23
    ppsdata(:,23) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;

    % Element 41
    ppsdata(:,41) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;

    % Element 42
    ppsdata(:,42) = NaN;

    % Element 26
    ppsdata(:,26) = NaN;

    % Mat 2

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

    % Element 498
    ppsdata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;

    % Element 497
    ppsdata(:,497) = NaN;

   % Element 386
    ppsdata(:,386) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;

    % Element 383
    ppsdata(:,383) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;

    % Element 367
    ppsdata(:,367) = NaN;

    % Element 399
    ppsdata(:,399) = NaN;


    else 


           % Mat 1
    % Element 1
    ppsdata(:,1) = NaN;

    % Element 2
    ppsdata(:,2) = NaN;

    % Element 3
    ppsdata(:,3) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;

    % Element 23
    ppsdata(:,23) = NaN;

    % Element 39
    ppsdata(:,39) = NaN;

    % Element 22
    ppsdata(:,22) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;

    % Element 16
    ppsdata(:,16) = NaN;


    % Mat 2

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

    % Element 369
    ppsdata(:,369) = NaN;

    % Element 353
    ppsdata(:,353) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;

    % Element 466
    ppsdata(:,466) = NaN;

    % Element 434
    ppsdata(:,434) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;

   % Element 499
    ppsdata(:,499) = NaN;

    % Element 501
    ppsdata(:,501) = NaN;

    % Element 485
    ppsdata(:,485) = NaN;

    % Element 469
    ppsdata(:,469) = NaN;

    % Element 453
    ppsdata(:,453) = NaN;

    % Element 437
    ppsdata(:,437) = NaN;

    % Element 421
    ppsdata(:,421) = NaN;

    % Element 405
    ppsdata(:,405) = NaN;



    % Element 389
    ppsdata(:,389) = NaN;

    % Element 373
    ppsdata(:,373) = NaN;

    % Element 357
    ppsdata(:,357) = NaN;

    % Element 341
    ppsdata(:,341) = NaN;

   % Element 325
    ppsdata(:,325) = NaN;

    % Element 309
    ppsdata(:,309) = NaN;

    % Element 293
    ppsdata(:,293) = NaN;

    % Element 277
    ppsdata(:,277) = NaN;

    % Element 261
    ppsdata(:,261) = NaN;

    % Element 502
    ppsdata(:,502) = NaN;

    % Element 503
    ppsdata(:,503) = NaN;

    % Element 504
    ppsdata(:,504) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;

    % Element 488
    ppsdata(:,488) = NaN;

   % Element 385
    ppsdata(:,385) = NaN;

    % Element 500
    ppsdata(:,500) = NaN;

    % Element 497
    ppsdata(:,497) = NaN;

    % Element 450
    ppsdata(:,450) = NaN;

    % Element 370
    ppsdata(:,370) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;

    % Element 505
    ppsdata(:,505) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;


    % Element 511
    ppsdata(:,511) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;

    % Element 400
    ppsdata(:,400) = NaN;

   % Element 384
    ppsdata(:,384) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;

    % Element 506
    ppsdata(:,506) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;

    % Element 383
    ppsdata(:,383) = NaN;

    % Element 351
    ppsdata(:,351) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;

    % Element 464
    ppsdata(:,464) = NaN;

    % Element 448
    ppsdata(:,448) = NaN;

    end 

end 


if strcmp(partid,'RTIS2011')
  
    if strcmp(hand,'Left') % Paretic 
    
    % Mat 1
   % Element 209
    ppsdata(:,209) = NaN;

    % Element 193
    ppsdata(:,193) = NaN;

    % Element 210
    ppsdata(:,210) = NaN;

    % Element 211
    ppsdata(:,211) = NaN;

    % Element 39
    ppsdata(:,39) = NaN;

    % Element 23
    ppsdata(:,23) = NaN;

    % Element 1
    ppsdata(:,1) = NaN;

    % Element 3
    ppsdata(:,3) = NaN;

    % Element 4
    ppsdata(:,4) = NaN;

    % Element 5
    ppsdata(:,5) = NaN;

    % Element 6
    ppsdata(:,6) = NaN;

    % Element 7
    ppsdata(:,7) = NaN;

    % Element 24
    ppsdata(:,24) = NaN;


    % Element 226
    ppsdata(:,226) = NaN;

    % Element 8
    ppsdata(:,8) = NaN;

    % Element 194
    ppsdata(:,194) = NaN;


    % Element 195
    ppsdata(:,195) = NaN;

    % Element 2
    ppsdata(:,2) = NaN;

    % Element 242
    ppsdata(:,242) = NaN;

    % Element 225
    ppsdata(:,225) = NaN;

    % Element 41
    ppsdata(:,41) = NaN;

    % Element 25
    ppsdata(:,25) = NaN;

    % Element 218
    ppsdata(:,218) = NaN;

    % Element 219
    ppsdata(:,219) = NaN;

    % Element 224
    ppsdata(:,224) = NaN;

    % Element 9
    ppsdata(:,9) = NaN;

    % Element 10
    ppsdata(:,10) = NaN;

    % Element 11
    ppsdata(:,11) = NaN;

    % Element 12
    ppsdata(:,12) = NaN;

    % Element 13
    ppsdata(:,13) = NaN;

    % Element 14
    ppsdata(:,14) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;

    % Element 16
    ppsdata(:,16) = NaN;

    % Element 235
    ppsdata(:,235) = NaN;

    % Element 202
    ppsdata(:,202) = NaN;

    % Element 234
    ppsdata(:,234) = NaN;

    % Element 250
    ppsdata(:,250) = NaN;

    % Element 251
    ppsdata(:,251) = NaN;

    % Mat 2
   % Element 369
    ppsdata(:,369) = NaN;

    % Element 353
    ppsdata(:,353) = NaN;

    % Element 498
    ppsdata(:,498) = NaN;

    % Element 482
    ppsdata(:,482) = NaN;

    % Element 499
    ppsdata(:,499) = NaN;

    % Element 483
    ppsdata(:,483) = NaN;

    % Element 386
    ppsdata(:,386) = NaN;

    % Element 370
    ppsdata(:,370) = NaN;

    % Element 354
    ppsdata(:,354) = NaN;

    % Element 387
    ppsdata(:,387) = NaN;

    % Element 371
    ppsdata(:,371) = NaN;

    % Element 500
    ppsdata(:,500) = NaN;

    % Element 501
    ppsdata(:,501) = NaN;


    % Element 485
    ppsdata(:,485) = NaN;

    % Element 502
    ppsdata(:,502) = NaN;

    % Element 486
    ppsdata(:,486) = NaN;

    
    % Element 470
    ppsdata(:,470) = NaN;

    % Element 503
    ppsdata(:,503) = NaN;


    % Element 487
    ppsdata(:,487) = NaN;

    % Element 471
    ppsdata(:,471) = NaN;

    % Element 263
    ppsdata(:,263) = NaN;


    % Element 504
    ppsdata(:,504) = NaN;

    % Element 488
    ppsdata(:,488) = NaN;

    % Element 472
    ppsdata(:,472) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;

    % Element 505
    ppsdata(:,505) = NaN;

    % Element 350
    ppsdata(:,350) = NaN;

    % Element 489
    ppsdata(:,489) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;

    % Element 265
    ppsdata(:,265) = NaN;

    % Element 506
    ppsdata(:,506) = NaN;

    % Element 490
    ppsdata(:,490) = NaN;

    % Element 474
    ppsdata(:,474) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;

    % Element 381
    ppsdata(:,381) = NaN;

    % Element 398
    ppsdata(:,398) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;

    % Element 399
    ppsdata(:,399) = NaN;

    % Element 383
    ppsdata(:,383) = NaN;

    % Element 367
    ppsdata(:,367) = NaN;

    % Element 351
    ppsdata(:,351) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;

    % Element 511
    ppsdata(:,511) = NaN;

    % Element 509
    ppsdata(:,509) = NaN;


    else % Non Paretic

    % Element 1
    ppsdata(:,1) = NaN;

    % Element 2
    ppsdata(:,2) = NaN;

    % Element 15
    ppsdata(:,15) = NaN;

    % Element 16
    ppsdata(:,16) = NaN;

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

    % Element 483
    ppsdata(:,483) = NaN;


    % Element 467
    ppsdata(:,467) = NaN;

    % Element 472
    ppsdata(:,472) = NaN;

    % Element 264
    ppsdata(:,264) = NaN;


    % Element 498
    ppsdata(:,498) = NaN;

    % Element 488
    ppsdata(:,488) = NaN;

    % Element 486
    ppsdata(:,486) = NaN;

    % Element 470
    ppsdata(:,470) = NaN;

    % Element 489
    ppsdata(:,489) = NaN;

    % Element 473
    ppsdata(:,473) = NaN;

    % Element 266
    ppsdata(:,266) = NaN;

    % Element 477
    ppsdata(:,477) = NaN;

    % Element 365
    ppsdata(:,365) = NaN;

    % Element 398
    ppsdata(:,398) = NaN;

    % Element 382
    ppsdata(:,382) = NaN;

    % Element 366
    ppsdata(:,366) = NaN;

    % Element 383
    ppsdata(:,383) = NaN;

    % Element 367
    ppsdata(:,367) = NaN;

    % Element 512
    ppsdata(:,512) = NaN;

    % Element 496
    ppsdata(:,496) = NaN;

    % Element 464
    ppsdata(:,464) = NaN;

    % Element 384
    ppsdata(:,384) = NaN;

    % Element 368
    ppsdata(:,368) = NaN;

    % Element 352
    ppsdata(:,352) = NaN;

    % Element 480
    ppsdata(:,480) = NaN;

    % Element 491
    ppsdata(:,491) = NaN;

    

    end 


end 

% creating new matrix once replaces bad elements with NaNs

ppsdata_clean = ppsdata;

end