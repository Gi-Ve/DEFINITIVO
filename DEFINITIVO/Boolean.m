function [BinaryV] = Boolean(V)

V=rescale(V);
L=length(V);
T=0.2*max(V);
BinaryV=NaN(1,L);
%BinaryV=zeros(1,L);

for i=1:L
    
if V(i)>=T
    BinaryV(i)=1;
end


end

