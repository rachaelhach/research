function [binaryImage, avgROI] = drawROI(matfile, MU, n)

im = cell2mat(struct2cell(load(matfile)));

%set the axes to full screen
% set(hFig,'units','normalized','outerposition',[0 0 1 1]);
% set(hAx,'Unit','normalized','Position',[0 0 1 1]);
% axis image; axis off; colormap(jet);
% ellipse= imellipse;
% mask = createMask(ellipse);
% close

avgROI = [];
for i = 1:n
    imagesc(im, window);
    hFig = gcf;
    hAx  = gca;

    %mask registered image based on freehand draw
    set(hFig,'units','normalized','outerposition',[0 0 1 1]);
    %set the axes to full screen
    set(hAx,'Unit','normalized','Position',[0 0 1 1]);
    hFH = imfreehand();
    binaryImage(:,:,i) = hFH.createMask();
    maskedImage = im;
    maskedImage(~mask) = 0;
    avgROI(i) = mean(maskedImage(mask));
end

end

