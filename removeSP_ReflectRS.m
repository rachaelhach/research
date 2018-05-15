function [imOut] = removeSP_ReflectRS(imIn, thresh);
im = imIn;
im(im>thresh)=1e-9;
imOut = im;
end

