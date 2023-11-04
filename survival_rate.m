
function [ o ] =  survival_rate(  fit, min, max )
    for i=1:size(fit,2)
         o(i)= (max-fit(i))/(max-min);
    end
end
%_________________________________________________________________________%
%[Improves the algorithm by replacing vectors with low survival value with values generated by Eq.6 ] 
%[The fitness value is normalized]
