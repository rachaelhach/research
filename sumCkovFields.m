function [field1, field2, ckov_sum] = sumCkovFields(PtNumber, Date)

ldir = dir();
filenames = {ldir.name};

cd([pwd '\' filenames{end-1}])

field1 = read_dovi('meas_s1_cam0.dovi');
field1 = sum(field1,3);

figure(1)
subplot_tight(1,3,1)
imshow(field1,[])

cd ..
cd([pwd '\' filenames{end}])

field2 = read_dovi('meas_s1_cam0.dovi');
field2 = sum(field2,3);
subplot(1,3,2)
imshow(field2,[])

ckov_sum = field1 + field2;

subplot(1,3,3)
imshow(ckov_sum,[])

close
fname = sprintf('Pt%dCkov_%s.mat', PtNumber, Date);
save(fname,'ckov_sum')

imshow(ckov_sum, []);
normckovstack = double(ckov_sum)./max(double(ckov_sum(:)));
fname2 = sprintf('Pt%dCkov_%s.png', PtNumber, Date);
imwrite(normckovstack, fname2, 'png', 'Bitdepth', 16, 'Mode', 'lossless')



end

