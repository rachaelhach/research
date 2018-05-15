% to read in ckov images
 
%file path to data
%cd 'G:\Pt35\Cherenkov\2018.04.16\2018-04-16 10-37-51-433\'
close all
clear all
test_im = read_dovi('meas_s1_cam0.dovi');
test_im = sum(test_im,3);
imagesc(test_im)

RPO = test_im;
LAO = test_im;
total = RPO+LAO;

%check the date
save('Pt36Ckov_2018_04_04.mat','total')
save('Pt36QA_2018_04_16.mat','test_im')




ckovim = read_dovi('meas_s1_cam0.dovi');
ckovim = sum(ckovim,3);
save('Pt35Ckov_2018_04_13.mat','ckovim')
 
%file path to QA
%cd 'G:\Pt35\Cherenkov\2018.04.16\2018-04-16 10-45-45-622\'
qadata = read_dovi('meas_s1_cam0.dovi');
qadata = sum(qadata,3);
save('Pt35QA_2018_04_13.mat','qadata')

%% intensity correction

filenameQA = {'Pt35QA_2018_03_29.mat'
    'Pt35QA_2018_03_30.mat'
    'Pt35QA_2018_04_02.mat'
    'Pt35QA_2018_04_03.mat'
    'Pt35QA_2018_04_04.mat'
    'Pt35QA_2018_04_05.mat'
    'Pt35QA_2018_04_06.mat'
    'Pt35QA_2018_04_09.mat'
    'Pt35QA_2018_04_10.mat'
    'Pt35QA_2018_04_11.mat'
    'Pt35QA_2018_04_12.mat'
    'Pt35QA_2018_04_13.mat'};

filenameCkov = {'Pt35Ckov_2018_03_29.mat'
    'Pt35Ckov_2018_03_30.mat'
    'Pt35Ckov_2018_04_02.mat'
    'Pt35Ckov_2018_04_03.mat'
    'Pt35Ckov_2018_04_04.mat'
    'Pt35Ckov_2018_04_05.mat'
    'Pt35Ckov_2018_04_06.mat'
    'Pt35Ckov_2018_04_09.mat'
    'Pt35Ckov_2018_04_10.mat'
    'Pt35Ckov_2018_04_11.mat'
    'Pt35Ckov_2018_04_12.mat'
    'Pt35Ckov_2018_04_13.mat'};


%Pt36 Data
filenameQA = {'Pt36QA_2018_04_03.mat'
    'Pt36QA_2018_04_04.mat'
    'Pt36QA_2018_04_05.mat'
    %'Pt36QA_2018_04_06.mat'
    'Pt36QA_2018_04_09.mat'
    'Pt36QA_2018_04_10.mat'
    'Pt36QA_2018_04_12.mat'
    'Pt36QA_2018_04_13.mat'
    'Pt36QA_2018_04_16.mat'};

filenameCkov = {'Pt36Ckov_2018_04_03.mat'
    'Pt36Ckov_2018_04_04.mat'
    'Pt36Ckov_2018_04_05.mat'
    'Pt36Ckov_2018_04_06.mat'
    'Pt36Ckov_2018_04_09.mat'
    'Pt36Ckov_2018_04_10.mat'
    'Pt36Ckov_2018_04_12.mat'
    'Pt36Ckov_2018_04_13.mat'
    'Pt36Ckov_2018_04_16.mat'};





ckovstack = []; qastack = []; avgQA = []; ckov_scaled = [];
for i = 1:length(filenameCkov)
    clear max
    ckovdata = cell2mat(struct2cell(load(filenameCkov{i})));
    ckovstack(:,:,i) = ckovdata;
    qadata = cell2mat(struct2cell(load(filenameQA{i})));
    qastack(:,:,i) = qadata;
    binQA = imbinarize(qadata,0.2.*max(qadata(:)));
    
    threshQA = qadata.*binQA;
    avgQA(i) = mean(threshQA(threshQA~=0));
    
    ckov_scaled(:,:,i) = ckovstack(:,:,i)./avgQA(i); %gives the full image stacks 
    
end

%delineate an ROI
imagesc(ckovstack(:,:,3))
hFig = gcf;
hAx  = gca;
set(hFig,'units','normalized','outerposition',[0 0 1 1]);
set(hAx,'Unit','normalized','Position',[0 0 1 1]);
 
%draw new mask
hFH = imfreehand();
binaryImage = hFH.createMask();
 
%plots new mask about old image
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1};
x = xy(:, 2); % Columns.
y = xy(:, 1); % Rows.
hold on;
plot(x, y, 'r', 'LineWidth', 3);

avgCkovRaw = []; avgCkovScaled = [];
for i = 1:length(filenameCkov)
    blackMaskedImage = ckovstack(:,:,i);
    blackMaskedImage(~binaryImage) = 0;
    avgCkovRaw(i) = mean(blackMaskedImage(binaryImage));

    blackMaskedImage = ckov_scaled(:,:,i);
    blackMaskedImage(~binaryImage) = 0;
    avgCkovScaled(i) = mean(blackMaskedImage(binaryImage));
    
end

%day = [0:1:length(filenameCkov)-1];
normalized_raw = (avgCkovRaw./max(avgCkovRaw(:)));
normalized_qa = avgQA./max(avgQA(:));
normalized_scaled = avgCkovScaled(:)./max(avgCkovScaled(:));
%day = ['04/03' '04/04' '04/05' '04/06' '04/09' '04/10' '04/12' '04/13' '04/16'];

data = [normalized_raw(:), normalized_qa(:)];
figure(1)
bar(data, 'grouped')
title('Normalized Cherenkov ROI vs. Normalized QA ROI')
legend('Chkov ROI Patient Data', 'QA Board 20% Chkov Avg')

data2 = [normalized_raw(:), normalized_scaled(:)];
figure(2)
bar(data2, 'grouped')
title('Normalized Cherenkov ROI vs. Scaled ROI Using QA Board')
legend('Chkov Pt. ROI Normalized', 'Ckov Pt. ROI (QA Board Corrected)')
stdevraw =std(normalized_raw); stdevscaled=std(normalized_scaled); stdevQA = std(normalized_qa);

%not normalized
data = [avgCkovRaw(:), avgQA(:)];
figure(1)
bar(data, 'grouped')
title('Pt 36: Cherenkov w/in Pt ROI vs. QA Board ROI')
legend('Chkv ROI Patient Data', 'QA Board 20% Chkov Avg')

data2 = [avgCkovRaw(:),avgQA(:),avgCkovScaled(:).*1e5];
figure(3)
bar(data2, 'grouped')
title('Pt 36: Cherenkov w/in ROI, QA Board ROI, & QA Corrected ROI')
ylabel('Average Counts in ROI')
legend('Ckov ROI Patient Data', 'QA ROI 20% Chkov', 'Ckov Pt ROI (QA Board Correction)')

figure(2)
bar(avgCkovRaw, avgCkovScaled)
xlabel('Day of Treatment')
ylabel('Average Counts in ROI / Average QA Counts')

close all
for j = 1:8
figure(j+2)
imagesc(ckovstack(:,:,j))
caxis([0 1.2e5]); axis image; axis off
colormap(gray)
%hold on 
%plot(x,y,'r','LineWidth',2)
fig = gcf;
fig = double(fig);
saveas(fig,['Pt36_' num2str(j) '.png']);
end



%% Evaluating Treatment field using Align RT light.

%for align
clear 
test1 = read_dovi('meas_s0_cam0.dovi');
test1 = sum(test1,3);

test2 = read_dovi('meas_s0_cam0.dovi');
test2 = sum(test2,3);

total = test1+test2;

%for cherenkov 
clear
test1 = read_dovi('meas_s1_cam0.dovi');
test1 = sum(test1,3);

test2 = read_dovi('meas_s1_cam0.dovi');
test2 = sum(test2,3);

total = test1+test2;


save('Pt32_2018_02_21_ART.mat','total')
save('Pt32_2018_02_21_BKG.mat','total')
save('Pt32_2018_02_12_CKOV_10MV.mat','total')
save('Pt32_2018_02_12_CKOV_6MV.mat','total')

%% reading in the align files
clear 
filenameALN = {'Pt32_2018_02_12_ART.mat'
    'Pt32_2018_02_20_ART.mat'
    'Pt32_2018_02_21_ART.mat'
    'Pt32_2018_02_23_ART.mat'};

filenameBKG = {'Pt32_2018_02_12_BKG.mat'
    'Pt32_2018_02_20_BKG.mat'
    'Pt32_2018_02_21_BKG.mat'
    'Pt32_2018_02_23_BKG.mat'};

filenameCk10 = {'Pt32_2018_02_12_CKOV_10MV.mat'
    'Pt32_2018_02_20_CKOV_10MV.mat'
    'Pt32_2018_02_21_CKOV_10MV.mat'
    'Pt32_2018_02_23_CKOV_10MV.mat'};

filenameCk6 = {'Pt32_2018_02_12_CKOV_6MV.mat'
    'Pt32_2018_02_20_CKOV_6MV.mat'
    'Pt32_2018_02_21_CKOV_6MV.mat'
    'Pt32_2018_02_23_CKOV_6MV.mat'};



ckovstack = []; alnstack = []; ckov_scaled = [];  avgCkovraw = [];  avgAlign = []; roi_scaled = []; alnstackrs = []; threshAlign = [];
for i = 1:length(filenameCk6)
    clear max
    ckovdata6mv = cell2mat(struct2cell(load(filenameCk6{i})));
    ckovdata10mv = cell2mat(struct2cell(load(filenameCk10{i})));
    ckovstack(:,:,i) = ckovdata6mv+ckovdata10mv; 
    
    alndata = cell2mat(struct2cell(load(filenameALN{i})));
    bkgdata = cell2mat(struct2cell(load(filenameBKG{i})));
    alnstack(:,:,i) = alndata-bkgdata*4; %scaled for number 800 frames used vs 200 for background
    alnstackrs(:,:,i) = imresize(alnstack(:,:,i), [1200 1920]);

    ckovdata = ckovdata6mv+ckovdata10mv;
    binckov = imbinarize(ckovstack(:,:,i),0.2*max(ckovdata(:)));
    
    threshCkov = ckovstack(:,:,i).*binckov;
    avgCkovraw(i) = mean(threshCkov(threshCkov~=0));
    threshAlign(:,:,i) = alnstackrs(:,:,i).*binckov;
    avgAlign(i) =  mean(threshAlign(threshAlign~=0));
    
    ckov_scaled(:,:,i) = ckovstack(:,:,i)./avgAlign(i); %gives the full image stacks 
    
    roi_scaled(i) = avgCkovraw(i)./avgAlign(i);
    
end


data2 = [avgCkovraw(:),avgAlign(:)./10,roi_scaled(:)*1e5];
figure(3)
bar(data2, 'grouped')
title('Pt 32: Cherenkov w/in ROI, Align Light (Bkg Sub), & Align Corrected ROI')
ylabel('Average Counts in ROI')
legend('Ckov ROI 20% Threshold', 'Align Light (20% Ckov Threshold', 'Ckov Pt ROI (Align Light Correction)')

%day = [0:1:length(filenameCkov)-1];
normalized_raw = (avgCkovraw./max(avgCkovraw(:)));
normalized_aln = avgAlign./max(avgAlign(:));
normalized_scaled = roi_scaled(:)./max(roi_scaled(:));


data3 = [normalized_raw(:),normalized_aln(:),normalized_scaled(:)];
figure(3)
bar(data3, 'grouped')
title('Pt 32: Cherenkov w/in ROI (N), Align Light (Bkg Sub, N), & Align Corrected ROI (N)')
ylabel('Average Counts in ROI')
legend('Ckov ROI 20% Threshold', 'Align Light (20% Ckov Threshold', 'Ckov Pt ROI (Align Light Correction)')


stdevraw =std(normalized_raw); stdevscaled=std(normalized_scaled); stdevaln = std(normalized_aln);

close all
for j = 1:4
figure()
imagesc(ckovstack(:,:,j))
caxis([0 6.0e4]); axis image; axis off
colormap(gray)
%hold on 
%plot(x,y,'r','LineWidth',2)
fig = gcf;
fig = double(fig);
saveas(fig,['Pt32_ckov' num2str(j) '.png']);
close
figure()
imagesc(threshAlign(:,:,j))
caxis([0 1e6]); axis image; axis off
colormap(gray)
%hold on 
%plot(x,y,'r','LineWidth',2)
fig = gcf;
fig = double(fig);
saveas(fig,['Pt32_aln' num2str(j) '.png']);
close
end



%% 
binQA = imbinarize(qadata,0.2.*max(quadata(:)));
threshQA = qadata.*binQA;
avgQA = mean(threshQA(threshQA~=0));

imagesc(ckovim)