% desiredpart = 'RTIS1003';
% desiredhand = 'C';

% filename = 'CombinedPrepandAccelTrunkandArm.xlsx'

% Function to Run NMF Analysis and to choose number of synergies. 
% Use SuvadaNMF2025_Func2 for analysis post choosing num syns
% K. Suvada 2025. 


%%%%

function nmf = SuvadaNMF2025_Func1(desiredpart,desiredhand,filename)


data2 = readcell(['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/2025_EXCEL_CLEANEDANDCUT/FINAL/' filename]);

matchingRows = strcmp(data2(2:end, 1),desiredpart) &  strcmp(data2(2:end, 4),desiredhand);

% Extract matching rows (include the header if desired)
result = data2([true; matchingRows], :);

MAT_APA = result';


% Grabbing just EMG values to input into NNMF

NMFMAT = MAT_APA;

%% MissingMus = cell(1,15);
MissingRows = cell(1,15);
musnames = cell(1,15);
selectedrowsmat = cell(1,15);
for p = 1:15
  if  ismissing(NMFMAT{p+10,2}) ==1
      MissingMus{1,p} = NMFMAT{p+10,1};
      MissingRows{1,p} = p+10;

  else 
      musnames{1,p} =  NMFMAT{p+10,1};
      selectedrowsmat{1,p} = p+10;
  end 
end 

% Identify non-empty elements
musnames = musnames(~cellfun('isempty', musnames));
selectedrowsmat = selectedrowsmat(~cellfun('isempty', selectedrowsmat));

selectedrowsmat = cell2mat(selectedrowsmat);


%% Running NMF Algorithm  

data = cell2mat(NMFMAT(selectedrowsmat,2:end));


nmus = size(data,1);

for s=1:nmus
nmf(s).nsyn=s; %The number of synergies
[nmf(s).W,nmf(s).C,nmf(s).err,nmf(s).stdev] = NNMF_stacie_May2013(data,s,1);
[nmf(s).VAFcond, nmf(s).VAFmus, nmf(s).VAF]=funur(data,nmf(s).W,nmf(s).C); %calculate VAF of reconstruction
nmf(s).RECON = nmf(s).W*nmf(s).C;
end

%% Cumulative VAF and error 
figure(1)
errorbar(1:nmus,[nmf.VAF],[nmf.err], 'Color', [0 0.5 0], 'LineWidth', 4) % Dark green color
xlabel('Number of Modules', 'FontSize', 30); 
ylabel('Composite % VAF and Error ', 'FontSize', 16); 
xlim([1 nmus])
ylim([0 105])
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20
yline(90)
pause
%% VAF per Muscle with Error Bars 

figure(2)
VAFmus = []; VAFcond = [];
for ss=1:nmus
VAFmus = [VAFmus, nmf(ss).VAFmus];
VAFcond = [VAFcond, nmf(ss).VAFcond];
end


errorbar(1:nmus,mean(VAFmus),std(VAFmus),'Color', '#dd1c77','LineWidth',3)
hold on
 errorbar(1:nmus, mean(VAFmus), std(VAFmus), 'o', 'Color', '#c994c7' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20
ylabel('Mean % VAF and Error per Muscle', 'FontSize', 35); 
yline(80)
ylim([0 105])

%% Reconstructed Data and Original Input Data

for mm=1:nmus

    figure(3)
    subplot(4,4,mm)
    plot(data(mm,:),'k','LineWidth',4)
    hold on
    title(musnames(mm))

    for ss=1:nmus


        if ss == 3 % For chosen num of synergies
            plot(nmf(ss).RECON(mm, :), 'r', 'LineWidth', 3, 'LineStyle', '--');
        else
            plot(nmf(ss).RECON(mm,:),'Linewidth',1)

        end

        'Synergies'
        ss
%         pause

    end
legend('Original Data', '1', '2', '3', '4', '5','6','7','8','9','10','11','12','13','14','15')


end

%% Plotting Individual Muscle VAFS vs Number of synergies

figure(4)
for mm = 1:nmus
    plot(VAFmus(mm,:),'LineWidth',2)
    hold on

yline(80)
ylabel('VAF per muscle','Fontsize',35)
xlabel('Number of Synergies','Fontsize',35)
set(gca, 'FontSize', 20); % Set the font size for both axes
end


end