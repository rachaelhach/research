function [QAstack_sum, avgQA] = QAboard2mat(PtNumber, Date)

    file_stack = read_dovi('meas_s1_cam0.dovi');
    QAstack_sum = sum(file_stack,3);

    fname = sprintf('Pt%dQA_%s.mat', PtNumber, Date);
    save(fname,'QAstack_sum')
    
    imshow(QAstack_sum,[])
    normQAstack = double(QAstack_sum)./max(double(QAstack_sum(:)));
    fname2 = sprintf('Pt%dQA_%s.png', PtNumber, Date);
    imwrite(normQAstack, fname2, 'png', 'Bitdepth', 16, 'Mode', 'lossless')
    
    binQA = imbinarize(QAstack_sum,0.2.*max(QAstack_sum(:)));
    threshQA = QAstack_sum.*binQA;
    avgQA = mean(threshQA(threshQA~=0));
    
end

