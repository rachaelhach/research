function [registered, ckovim, movingim] = matRegister(ckovim, movingim, movingPoints, fixedPoints, type);

ckovim = cell2mat(struct2cell(load(ckovim)));
movingim = cell2mat(struct2cell(load(movingim)));
movingim = imresize(movingim, [1200 1920]);


tform = fitgeotrans(movingPoints,fixedPoints, type);
registered = imwarp(movingim,tform,'OutputView',imref2d(size(ckovim)));
imshowpair(ckovim, registered)



end

