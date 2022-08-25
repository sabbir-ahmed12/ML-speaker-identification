function [ distorted_signal ] = peak_clipping_final(y,p,center)
% y is the input signal
% p is the percentage that you want to clip.
% cliplevel is the threshold for clipping.
% Peak clipping Matlab code written by Ekramul 24.2.2015 according
%  to the equation 1 (kates at el 2005)


if p==0
    
cliplevel = center(1);
else
 p=p+1;
cliplevel = center(p);
end

N=length(y);

for i = 1:N
  if y(i) > cliplevel 
    y(i) =cliplevel;
 
  else if y(i) < -cliplevel
         y(i) =-cliplevel;
      else 
          y(i)=y(i);
      end
  end
end

distorted_signal=y;

end


% for i = 1:N,
%   if abs(y(i)) > cliplevel
%     y(i) = sign(y(i))*cliplevel;
%   end
% end
