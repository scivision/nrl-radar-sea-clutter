function SigZ = NRL_SigmaSea(fGHz,SS,Pol,Psi,ThWind)
% Vilhelm Gregers-Hansen, Naval Research Laboratory
% 5 May 2010
% SigmaSea computes reflectivity coefficient for sea clutter in dB
% fGHz is radar frequency in GHz
% SS is sea state (0-7)
% Pol is polarization - Pol=V or Pol=H
% Psi is grazing angle in deg
% ThWind is look direction relative to wind - NOT USED by VGHSigmaSea
% Convert grazing angle to radians
Psi_rad = Psi*pi/180;
if(Pol=='H')
 % These coefficients were optimized for 0 to 60 deg grazing angle
 CC1= -73.0; CC2= 20.781; CC3= 7.351; CC4= 25.65; CC5= 0.0054;

elseif(Pol=='V')
 % These coefficients were optimized for 0 to 60 deg grazing angle
 CC1= -50.796; CC2= 25.93; CC3= 0.7093; CC4= 21.588; CC5= 0.00211;

end
 SigZ = CC1 + CC2*log10(sin(Psi_rad)) + (27.5+CC3*Psi)*log10(fGHz)./ ...
 (1.+0.95*Psi) + CC4*(SS+1).^(1.0 ./(2+0.085*Psi+0.033*SS))+ ...
 CC5*Psi.^2;

end % function