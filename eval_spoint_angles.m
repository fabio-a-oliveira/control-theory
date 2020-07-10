function [angles_controller,angles_zeros,angles_poles] = eval_spoint_angles(tf,s,mode)
% eval_spoint_angles: Evaluates the angle between each zero and pole of a
% transfer function and a given point in the s-plane. Output in either
% radians or degrees, depending on the mode input. With a single output,
% returns only the required controller contribution.
%
% INPUTS:
% - tf: Must be either a 'tf' or 'zpk', symbolic not implemented.
% - mode: Must be either 'radians' or 'degrees'.
% - s: Point on the s-plane to which the angles will be evaluated.
%
% OUTPUTS:
% - angles_zeros: Angular contribution for each of the tf zeros.
% - angles_poles: Angular contribution for each of the tf poles.
% - angles_controller: Angular contribution required from a cascade
% controller in order for s-point to be in root locus of the resulting
% transfer function.

if ~isa(tf,'zpk') && ~isa(tf,'tf')
    error('1st argument must be a valid transfer function (either tf or zpk)')
end

if strcmp(mode,'radians')
    unit = 1;
elseif strcmp(mode,'degrees')
    unit = pi/180;
else
    error('Invalid mode. Valid entries are radians, degrees.')
end

[Z,P,K] = zpkdata(tf);
z = Z{1};
p = P{1};

angles_zeros = mod(atan2((imag(s)-imag(z)),(real(s)-real(z))),2*pi);
angles_poles = mod(atan2((imag(s)-imag(p)),(real(s)-real(p))),2*pi);
angles_controller = mod(sum(angles_zeros) - sum(angles_poles),2*pi);

angles_zeros = angles_zeros / unit;
angles_poles = angles_poles / unit;
angles_controller = angles_controller / unit;

end
