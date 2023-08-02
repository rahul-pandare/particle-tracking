function [img1] = clip(img,hi,lo)
%clip is used to apply thresholds to intensity values

img(img>hi)=hi;
img(img<lo)=lo;
img1=img;
end