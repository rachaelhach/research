function [ua_map, us_map, ueff_map] = opMaps2mat_exp(exp,mFolder,outname,wl,uba, ubs, ta, ts, tuf, pct)

close all

readoptions.TissueName = mFolder;
readoptions.outname=outname;
readoptions.DataDirectory= [pwd '\'];
readoptions.OutputDirectory= [pwd '\'];
readoptions.Measurement='nir'   % specifies wavelength regime
out=ReadReflectRSData(readoptions); %loads data

figure(1)
subplot_tight(1,3,1)
ua = out.op_maps(:,:,wl,1);
imagesc(imrotate(ua,180));
axis image; axis off; caxis([0 uba]); colorbar;
title(['Absorption u_{a} at ' num2str(out.parameters.wavelengths(wl)) 'nm'])

subplot_tight(1,3,2);
us = out.op_maps(:,:,wl,2);
imagesc(imrotate(us,180));
axis image; axis off; caxis([0 ubs]); colorbar;
title(['Reduced Scatter u_{s}'' at ' num2str(out.parameters.wavelengths(wl)) 'nm'])

subplot_tight(1,3,3);
ueff = sqrt(3.*ua.*us);
uf_ub =  sqrt(3.*uba.*ubs);
imagesc(imrotate(ueff,180));
axis image; axis off; caxis([0 uf_ub]); colorbar;
title(['Effective Attenuation u_{eff} at ' num2str(out.parameters.wavelengths(wl)) 'nm']);

hFig = figure(1);
set(hFig, 'Position', [500 500 800 200]);

k = waitforbuttonpress;

% close all
% 
% imagesc(imrotate(ueff,180));
% caxis([0 uf_ub]);
% 
% %mask registered image based on freehand draw
% hFig = gcf;   
% hAx  = gca;
% set(hFig,'units','normalized','outerposition',[0 0 1 1]);
% %set the axes to full screen
% set(hAx,'Unit','normalized','Position',[0 0 1 1]);
%  
% hFH = imfreehand();
% binaryImage = hFH.createMask();
% 
% k = waitforbuttonpress;
% 
% structBoundaries = bwboundaries(binaryImage);
% xy=structBoundaries{1};
% x = xy(:, 2); % Columns.
% y = xy(:, 1); % Rows.
% hold on; 
% plot(x, y, 'r', 'LineWidth', 1);
% 
% out.mask = binaryImage;

close

figure(1)
clear gcf
[ua_map] = removeSP_ReflectRS(ua, ta);
ua_map = medfilt2(ua_map,[4 4]);
imshow(imrotate(ua_map,180));
colormap(gca,hot)
set(gcf, 'Position', [100 400 700 500]);
ax = gca;
ax.FontSize = 16;
axis image; axis off; caxis([0 uba]); colorbar;
title(['Absorption u_{a} at ' num2str(out.parameters.wavelengths(wl)) 'nm'])
tightfig;
fname = sprintf('%s_ua_%dpct.png', exp, pct);
%imwrite(out.mask.*imrotate(ua,180), fname, 'png', 'Bitdepth', 16, 'Mode', 'lossless')
export_fig(gcf, fname)
fname2 = sprintf('%s_ua_%dpct.mat', exp, pct);
save(fname2,'ua_map')

figure(2)
clear gcf
[us_map] = removeSP_ReflectRS(us,ts);
us_map = medfilt2(us_map,[4 4]);
imshow(imrotate(us_map,180));
colormap(gca,hot)
set(gcf, 'Position', [400 300 700 500]);
ax = gca;
ax.FontSize = 16;
axis image; axis off; caxis([0 ubs]); colorbar;
title(['Reduced Scatter u''_{s} at ' num2str(out.parameters.wavelengths(wl)) 'nm'])
tightfig;
fname = sprintf('%s_us_%dpct.png', exp, pct);
%imwrite(out.mask.*imrotate(ua,180), fname, 'png', 'Bitdepth', 16, 'Mode', 'lossless')
export_fig(gcf, fname)
fname2 = sprintf('%s_us_%dpct.mat', exp, pct);
save(fname2,'us_map')

figure(3)
clear gcf
[ueff_map] = removeSP_ReflectRS(ueff,tuf);
ueff_map = medfilt2(ueff_map,[4 4]);
imshow(imrotate(ueff_map,180));
colormap(gca,hot)
set(gcf, 'Position', [700 200 700 500]);
ax = gca;
ax.FontSize = 16;
axis image; axis off; caxis([0 uf_ub]); colorbar;
title(['Effective Attenuation u_{eff} at ' num2str(out.parameters.wavelengths(wl)) 'nm'])
tightfig;
fname = sprintf('%s_ueff_%dpct.png', exp, pct);
%imwrite(out.mask.*imrotate(ua,180), fname, 'png', 'Bitdepth', 16, 'Mode', 'lossless')
export_fig(gcf, fname)
fname2 = sprintf('%s_ueff_%dpct.mat', exp, pct);
save(fname2,'ueff_map')

end



