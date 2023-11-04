
function [ sumatory ] = Attack( SearchAgents_no, na, Positions, r )
sumatory=0;
vAttack= vectorAttack( SearchAgents_no, na );
     for j=1:size(vAttack,2)
           sumatory= sumatory + Positions(vAttack(j),:)- Positions(r,:);                       
     end 
     sumatory=sumatory/na;
end
%_________________________________________________________________________%
%[Used in the Strategy 1: Group Attack, Eq. 2, Section 2.2.1]%
