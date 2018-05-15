function [ckov_sum] = ckov2mat_exp(expname, pct, window)

file_stack = read_dovi('meas_s1_cam0.dovi');
ckov_sum = sum(file_stack,3);
s = size(file_stack,3);

imagesc(ckov_sum, window)

k = waitforbuttonpress;

fname = sprintf('%s_ckov_%dpct.mat', expname, pct);
save(fname,'ckov_sum')

fname2 = sprintf('%s_ckov_%dpct.png',  expname, pct);
colormap(gca,gray)
ax = gca;
ax.FontSize = 16;
axis image; axis off; caxis(window);
title(['Cherenkov Image; Blood Conc. = ' num2str(pct) '%'])
%tightfig;
export_fig(gcf, fname2)

end

