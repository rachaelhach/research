function [matstack, avgROI] = takeROI(window);

close all
list = dir('*.mat');
filename = {list.name};
l = size(filename,2);

%read in mat file
matstack = [];
for i = 1:l
    matstack(:,:,i) = cell2mat(struct2cell(load(filename{i})));
end

%defaults first image in stack
imagesc(matstack(:,:,1), window);
hFig = gcf;   
hAx  = gca;
set(hFig,'units','normalized','outerposition',[0 0 1 1]);
%set the axes to full screen
set(hAx,'Unit','normalized','Position',[0 0 1 1]);
axis image; axis off; colormap(jet);
h= imellipse;
mask = createMask(h);

% %mask registered image based on freehand draw
% hFig = gcf;   
% hAx  = gca;
% set(hFig,'units','normalized','outerposition',[0 0 1 1]);
% %set the axes to full screen
% set(hAx,'Unit','normalized','Position',[0 0 1 1]);
%  
% hFH = imfreehand();
% binaryImage = hFH.createMask();

k = waitforbuttonpress;

structBoundaries = bwboundaries(mask);
xy=structBoundaries{1};
x = xy(:, 2); % Columns.
y = xy(:, 1); % Rows.

plotdiv = round(l/4);
close all
for i = 1:l
    figure(1)
    subplot_tight(plotdiv,4,i)
    imagesc(matstack(:,:,i),window)
    axis image; axis off; 
    hold on
    plot(x, y, 'r', 'LineWidth', 1);
    hold off
end

input('Press Enter to Continue...')

%takes averages
avgROI = [];
for i = 1:l
    maskedImage = matstack(:,:,i);
    maskedImage(~mask) = 0;
    avgROI(i) = mean(maskedImage(mask));
end

end

