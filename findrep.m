
function [ band ] = findrep( val, vector )
% return 1= repeated  0= not repeated
band= 0;
for i=1:size(vector, 2)
    if val== vector(i)
        band=1;
        break;
    end
end
end
%_________________________________________________________________________%
%[Used in vectorAttack.m for Strategy 1: Group Attack Eq.2, Section 2.2.1]%