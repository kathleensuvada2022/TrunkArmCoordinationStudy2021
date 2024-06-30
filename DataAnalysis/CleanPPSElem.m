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
        

%% Stroke






% creating new matrix once replaces bad elements with NaNs

ppsdata_clean = ppsdata;

end