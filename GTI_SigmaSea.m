function SigZ=GTI_SigmaSea(fGHz,Pol,Psi,ThWind)

% This function implements the sea clutter reflectivity model
% described in Horst, Dyer, and Tuley, Radar sea clutter model.

% Relative wind direction at 0 is worst case
% At S-band average is 2 dB lower
% At X-band average is 3.85 dB lower

% Model not valid for Sea State 0 - will return SigZ = -200 dB for this
% case

% SigmaSea computes reflectivity coefficient for sea clutter in dB
% fGHz is radar frequency in GHz
% SS is sea state (0-7)
% Pol is polarization - Pol=V or Pol=H
% Psi is grazing angle in deg

% VALUES DEFINED FOR STAND-ALONE TEST OF FUNCTION
% fGHz = (0.5:0.1:40)
% SS = 1
% Pol = 'H'
% Psi = .1
% ThWind = 0

% Constants and conversions
c = 0.2997924562; % Speed of Light in Giga meters per second
GrazAng = deg2rad(Psi);
phi_rad = deg2rad(ThWind);
Vw = 2.15*((SeaState+0)^1.04);
hav = 4.52*(10.0^(-3.0))*(Vw^(2.5));

lambda = c/fGHz;
if SeaState>0

 % Determine SigZ using GTI clutter model
 if fGHz <= 12

 % hav = 4.52*(10.0^(-3.0))*(Vw^(2.5));
 sigma_phi = (14.4 * lambda + 5.5).*GrazAng.*hav./(lambda+0.015);

 Ai = (sigma_phi.^4)./(1 + sigma_phi.^4);
 Au = exp((0.2.*abs(cos(phi_rad)).*(1 - 2.8.*(GrazAng)))./(lambda + 0.015).^0.4);

 qw = 1.1./(lambda + 0.015)^0.4;
 % Vw = 8.67*hav^0.4;

 Aw = ((1.94*Vw)./(1+Vw./15.4)).^qw;

 sigmaHH = 10.*log10(3.9e-6 .* lambda .* GrazAng.^0.4 .* Ai .* Au .* Aw);
 if Pol == 'H'

 SigZ = sigmaHH;
 elseif Pol == 'V'
 if fGHz >= 3
 sigmaVV = sigmaHH - 1.05.*log(hav + 0.015) + 1.09.*log(lambda) + 1.27.*log((GrazAng) + 0.0001) + 9.70;
 elseif fGHz < 3
 sigmaVV = sigmaHH - 1.73.*log(hav + 0.015) + 3.76.*log(lambda) + 2.46.*log((GrazAng) + 0.0001) + 22.2;
 end
 SigZ = sigmaVV;
 else
 error('No valid polarization in SigmaSeaGTI')
 end

 elseif fGHz > 12

 % hav = 4.52*(10.0^(-3.0))*(Vw^(2.5));
 sigma_phi = (14.4*lambda + 5.5).*GrazAng.*hav./(lambda+0.015);

 Ai = (sigma_phi.^4)./(1 + sigma_phi.^4);
 Au = exp(0.25.*abs(cos(phi_rad)).*(1-2.8.*sin(GrazAng).*lambda.^(-0.33)));

 qw = 1.93*lambda^(-0.04);
 % Vw = 8.67.*hav^(0.4);

 Aw = ((1.94*Vw)./(1+Vw./15.4)).^qw;
 sigmaHH = 10.*log10(5.78e-6 .* GrazAng.^0.547 .* Ai .* Au .* Aw);
 sigmaVV = sigmaHH - 1.38.*log(hav) + 3.43.*log(lambda) + 1.31.*log(GrazAng+eps) + 18.55;

 if Pol == 'H'
 SigZ = sigmaHH;
 elseif Pol == 'V'
 SigZ = sigmaVV;
 else
 error('No valid polarization in SigmaSeaGTI')
 end

 end
else
 SigZ = -200*ones(size(fGHz));
end

end % function
