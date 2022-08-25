function [distorted_signal] = center_clipping_final( y,p,center )
% y is the input signal
% p is the percentage that you want to clip.
% cliplevel is the threshold for clipping.
% Center clipping Matlab code written by Ekramul 24.2.2015 accurding
% to the equation 2 (kates at el 2005)

if p==0
    
cliplevel = center(1);
else
 p=p+1;
cliplevel = center(p);
end

N=length(y);

for i = 1:N
  if y(i) > cliplevel 
    y(i) =y(i);
 
  else if y(i) < -cliplevel
         y(i) =y(i);
      else 
          y(i)=0;
      end
  end
end
distorted_signal=y;

end
