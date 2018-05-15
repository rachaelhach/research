function [rgb] = demodulate2RGB(pct);
close all
%%Load Images
file = dir('*raw');
path = fopen([file.folder '\' file.name]);

wl = 4;
sf = 5;

numRaw = wl*sf*3; %includes phase information
numDem = wl*sf; %number of demodulated images

data = fread(path, 696*520*numRaw, 'float32');
fclose(path);
data = reshape(data, [696, 520, numRaw]);

demod = zeros([696,520,numDem]);
n = 1;

for i = 1:3:numRaw
    demod(:,:,n) = ((2^(1/2))/3).*((((data(:,:,i)-data(:,:,i+1)).^2)+((data(:,:,i)-data(:,:,i+2)).^2)+((data(:,:,i+1)-data(:,:,i+2)).^2)).^(1/2));
    n = n+1;
end

% for k = 1:numDem
%     figure
%     imshow(demod(:,:,k),[])
% end
t = 1;

b = demod(:,:,t);
b = b-min(b(:));
b = b./max(b(:));

g = demod(:,:,t+sf);
g = g-min(g(:));
g = g./max(g(:));

r = demod(:,:,t+(3*sf));
r = r-min(r(:));
r = r./max(r(:));

rgb = cat(3,r,g,b);
figure(1)
imshow(imrotate(rgb,90))

fname = sprintf('Reflect_Demod%dpct.png', pct);
imwrite(rgb, fname, 'png', 'Bitdepth', 16, 'Mode', 'lossless')

fname2 = sprintf('Reflect_Demod%dpct.mat', pct);
save(fname2,'rgb')

end

