function [ckovim, movingim] = matselect(ckovim, movingim, t1,t2);

ckovim = cell2mat(struct2cell(load(ckovim)));
movingim = cell2mat(struct2cell(load(movingim)));
movingim = imresize(movingim, [1200 1920]);

var = cpselect((movingim./max(movingim(:)))*t1,(ckovim./max(ckovim(:)))*t2);
end

