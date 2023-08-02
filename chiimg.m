function [chiimg, Wip2]=chiimg(img,ip,W,Wip2,range)
% chiimg     Calculate chi-squared image
% Usage: [chiimg Wip2]=chiimg(img,ip,[W=ip],[Wip2],[range='full']);
%{
% Calculates an image of chi-squared of the form 
% chiimg=int(W(x-x0)(img(x)-ip(x-x0))^2 dx) using convolution.  Chi-squared
% is an image which can be larger than (range=='full'[default]), smaller
% than (range=='valid'), or the same size as (range='same') the input image
% img. chiimg is minimum where img and the test image ip are most alike in
% a squared-difference sense.  W ([default]W==ip) limits the area to be
% consider by weighting chiimg.  
%}
if(~exist('range','var'))
  range='full';
end
if(~exist('W','var') || isempty(W))
  W=ip;
end
if(~exist('Wip2','var') || isempty(Wip2))  % Wip2 can be pre calculated since it does not depend on img
  blk=ones(size(img));                     % Blank image
  Wip2=(conv2(blk,ip.^2.*W,range));        % Weighting factor
end

ip=ip(end:-1:1,end:-1:1);  % Flip for convolution
W=W(end:-1:1,end:-1:1);    % Flip for convolution

chiimg=1+(-2*conv2(img,ip.*W,range)+conv2(img.^2,W,range))./Wip2;    % best fit ignoring overlap  
