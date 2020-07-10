function [H] = lead_compensator(tf,s,mode,angular_contribution,angular_unit)
% lead_compensator: Calculates lead/PD cascade compensator with zero, pole and gain
% to match a required angular contribution. Requires either zero or pole to
% be selected, will calculate the other one based on the required angular
% contribution. Uses the plant transfer function to calculate the necessary
% gain.
%
% INPUTS:
% - tf: Tranfer function for the plant. Must be either a 'tf' or 'zpk', 
% symbolic not implemented.
% - s: Point on s-plane to be included in the root locus via compensator.
% - mode: Must be either 'zero_first', 'pole_first' or 'zero_only'. Determines
% which parameter will be selected by the user and which will be calculated by
% the function. For PD controller, use 'zero_only'.
% - angular_contribution: Angular contribution required from controller
% zero and pole.
% - angular_unit: Must be either 'radians' or 'degrees'.
%
% OUTPUTS:
% - H: zpk transfer function for the compensator

if ~isa(tf,'zpk') && ~isa(tf,'tf')
    error('1st argument must be a valid transfer function (either tf or zpk)')
end

if strcmp(angular_unit,'radians')
    angle = angular_contribution;
elseif strcmp(angular_unit,'degrees')
    angle = angular_contribution * pi/180;
else
    error('Invalid angular unit. Valid entries are radians, degrees.')
end

if strcmp(mode,'zero_first')
    lead_zero = s;
    theta_lead_zero = atan2((imag(s)-imag(lead_zero)),(real(s)-real(lead_zero)));
    theta_lead_pole = theta_lead_zero - angle;
    lead_pole = real(s) - imag(s)/tan(theta_lead_pole);
    
    H_unit_gain = zpk(lead_zero,lead_pole,1);
    k = -1/real(evalfr(tf*H_unit_gain,s));
    H = zpk(lead_zero,lead_pole,k);
    
    if lead_pole > 0  || lead_zero > 0
        warning('Controller pole/zero is positive.')
    end
    
elseif strcmp(mode,'pole_first')
    lead_pole = s;
    theta_lead_pole = atan2((imag(s)-imag(lead_pole)),(real(s)-real(lead_pole)));
    theta_lead_zero = theta_lead_pole + angle;
    lead_zero = real(s) - imag(s)/tan(theta_lead_zero);
    
    H_unit_gain = zpk(lead_zero,lead_pole,1);
    k = -1/real(evalfr(tf*H_unit_gain,s));
    H = zpk(lead_zero,lead_pole,k);
    
    if lead_pole > 0 || lead_zero > 0
        warning('Controller pole/zero is positive.')
    end
    
elseif strcmp(mode, 'zero_only') % PD controller, no pole
    theta_lead_zero = angle;
    lead_zero = real(s) - imag(s)/tan(theta_lead_zero);
    
    H_unit_gain = zpk(lead_zero,[],1);
    k = -1/real(evalfr(tf*H_unit_gain,s));
    H = zpk(lead_zero,[],k);
    
    if lead_zero > 0
        warning('Controller zero is positive.')
    end
    
else
    error('Invalid mode. Valid entries are zero_first, pole_first, zero_only.')
end

end
