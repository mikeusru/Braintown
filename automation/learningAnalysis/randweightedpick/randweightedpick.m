function Y=randweightedpick(h,n)
% RANDWEIGHTEDPICK: Randomly pick n from size(h)>=n elements,
% biased with linear weights as given in h, without replacement.
% Works with infinity and zero weighting entries,
% but always picks them sequentially in this case.
%
% Syntax: Y=randweightedpick(h,n)
%
% Example:
%
% randweightedpick([2,0,5,Inf,3,Inf,0],7)
%
% returns [4,6,...,2,7] all the time as [4,6] are infinities and [2,7] are
% zeros; in between, the results will be a permutation of [1,3,5]:
%
% [...,3,5,1,...] 30.0% of the time {5/(2+3+5) * 3/(2+3)}
% [...,3,1,5,...] 20.0% of the time {5/(2+3+5) * 2/(2+3)}
% [...,5,3,1,...] 21.4% of the time {3/(2+3+5) * 5/(2+5)}
% [...,1,3,5,...] 12.5% of the time {2/(2+3+5) * 5/(3+5)}
% [...,5,1,3,...] 8.6% of the time {3/(2+3+5) * 2/(2+5)}
% [...,1,5,3,...] 7.5% of the time {2/(2+3+5) * 3/(3+5)}
%
% Y returns the vector of indices corresponding to the weights in h.
%
% Author: Adam W. Gripton (a.gripton -AT- hw.ac.uk) 2012/03/21
%
if nargin<=1
    n=1;
end
n=floor(max(1,n(1)));
h=h(:);
u=size(h,1);
n=min(n,u);
H=h;
HI=(1:u)';
Y=zeros(n,1);
for k=1:n
    Hu=size(H,1);
    Hs=H./sum(H);
    Hsc=cumsum(Hs);
    s=rand(1,1);
    s_under=sum(Hsc<s)+1; %lol
    Y(k)=HI(s_under);
    keeps=true(Hu,1);keeps(s_under)=false;
    H=H(keeps);HI=HI(keeps);
end