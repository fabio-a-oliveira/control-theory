function OS = damping2overshoot(xi)
% damping2overshoot: finds overshoot for a given damping coefficient value
%
% INPUTS:
% - xi: damping coefficient
%
% OUTPUTS:
% - OS: overshoot value in the range [0,1]

if xi < 0 || xi > 1
    error('Damping coefficient value must be in the [0,1] interval')
end

OS = exp(-xi*pi/sqrt(1-xi^2));

end
