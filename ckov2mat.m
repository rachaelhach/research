function [ckov_sum, s] = ckov2mat(PtNumber, Date)

    file_stack = read_dovi('meas_s1_cam0.dovi');
    ckov_sum = sum(file_stack,3);
    s = size(file_stack,3);

    fname = sprintf('Pt%dCkov_%s.mat', PtNumber, Date);
    save(fname,'ckov_sum')
    
    imshow(ckov_sum, [])
    normckovstack = double(ckov_sum)./max(double(ckov_sum(:)));
    fname2 = sprintf('Pt%dCkov_%s.png', PtNumber, Date);
    imwrite(normckovstack, fname2, 'png', 'Bitdepth', 16, 'Mode', 'lossless')
    
end

