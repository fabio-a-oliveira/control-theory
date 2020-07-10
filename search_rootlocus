function [s,k] = search_rlocus(tf, mode, parameter)
% search_rlocus: Searches the root locus for point that matches requested
% parameter. Looks for a point along a line where the imaginary part of
% G(s) is zero. May perform multiple attempts starting at different points 
% along the line until the real part of G(s) is negative.
%
% INPUTS:
% - tf: Must be either a 'tf' or 'zpk', symbolic not implemented.
% - mode: Must be either 'overshoot' (relative, not percentage), 'xi' (damping
% ratio), 'sigma' (natural frequency * damping ratio) or 'frequency'
% (damped frequency).
% - parameter: Will be used as OS, xi, sigma or wd, depending on selected
% mode.
%
% OUTPUTS:
% - s: Point on that s plane that matches requested parameter.
% - k: Cascade gain required for requested point.

if ~isa(tf,'zpk') && ~isa(tf,'tf')
    error('1st argument must be a valid transfer function (either tf or zpk)')
end
    
if strcmp(mode,'overshoot')
    OS = parameter;
    xi = -log(OS)/sqrt(pi^2 + log(OS)^2);
    theta = pi-acos(xi);
    if OS > 1 || OS < 0
        error('Overshoot value must be in the [0,1] range')
    end
elseif strcmp(mode,'xi')
    xi = parameter;
    theta = pi-acos(xi);
    if xi > 1 || xi < 0
        error('Damping ratio must be in the [0,1] range')
    end
elseif strcmp(mode,'sigma')
    sigma = parameter;
elseif strcmp(mode,'frequency')
    wd = parameter;
else
    error('Invalid mode. Valid entries are overshoot, xi, sigma, frequency.')
end

solution = false;
attempts = 0;
while solution == false
    t = 10*rand();
    attempts = attempts + 1;
    dt = 0.001;
    
    for n=1:100
        if strcmp(mode,'overshoot') || strcmp(mode,'xi')
            S = t * (cos(theta) + 1i*sin(theta));
            dS = (t+dt)  * (cos(theta) + 1i*sin(theta)) - S;
        elseif strcmp(mode,'sigma')
            S = -sigma + 1i * t;
            dS = -sigma + 1i * (t+dt) - S;
        elseif strcmp(mode,'frequency')
            S = -t + 1i * wd;
            dS = -(t+dt) + 1i * wd - S;
        end
        G = imag(evalfr(tf,S));
        dG = imag(evalfr(tf,S+dS)) - G;
        dG_dt = dG/dt;
        t = t - G/dG_dt;
    end
    
    if real(evalfr(tf,S)) < 0
        solution = true;
    end
    
    if attempts >= 100
       error('Too many attempts. Specification is probably not found on root locus.') 
    end
    
end

s = S;
k = -1/real(evalfr(tf, s));

end
