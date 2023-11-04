      
function [ vAttack ] = vectorAttack( SearchAgents_no,na )
c=1; 
vAttack=[];
 while(c<=na)
    idx =round( 1+ (SearchAgents_no-1) * rand());
    if ~findrep(idx, vAttack)
        vAttack(c) = idx;
        c=c+1;
    end
 end
%_________________________________________________________________________%
%[Used in the Strategy 1: Group Attack, Eq. 2, Section 2.2.1]%