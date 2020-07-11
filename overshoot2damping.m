function xi = overshoot2damping(OS)
% overshoot2damping: finds value of xi (damping coefficient) that yealds a
% given overshoot value
%
% INPUTS:
% - OS: overshoot value in the range [0,1]
%
% OUTPUTS:
% - xi: damping coefficient

if OS < 0 || OS > 1
    error('Overshoot value must be in the [0,1] interval')
end

xi = -log(OS)/sqrt(pi^2 + log(OS)^2);

end
