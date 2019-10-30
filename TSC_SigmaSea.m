function SigZ = TSC_SigmaSea(fGHz,SS,Pol,Psi,ThWind)

% This function implements the TSC model implemented in Antipov,
% "Simulation of Sea Clutter Returns", DSTO, 1999

% Wind direction is relative to radar look direction - upwind is 0 deg
% ThWind=0 deg is worst case (highest reflectivity)
% At S-band average is 2 dB lower
% At X-band average is 3.85 dB lower

% Vilhelm Gregers-Hansen 08 FEB 2009

% Model is not valid for Sea State 0 - set result to -200 dB
if SS<1
 SigZ = -200*ones(size(fGHz));
 return
end

% SigmaSea computes reflectivity coefficient for sea clutter in dB
% fGHz is radar frequency in GHz
% SS is sea state (0-7)
% Pol is polarization - Pol=V or Pol=H
% Psi is grazing angle in deg

% fGHz = 3
% SS = 3
% Pol = 'H'
% Psi = 1

% Conversions

GrazAng = deg2rad(Psi);

SeaState = SS;

freq = fGHz;

Lambda = 0.3/freq;

ThWindRad = deg2rad(ThWind);

SigHeight = 0.115*SeaState^1.95;
SigAlpha = 14.9*GrazAng*(SigHeight+0.25)/Lambda;
GA = SigAlpha^1.5/(1.0+SigAlpha^1.5);

% Wind Velocity
Vw = 6.2*SS^0.8;

% Wind Speed Factor Gw
% ========================

Q = GrazAng^0.6;

A1 = (1+(Lambda/0.03)^3)^0.1;
A2 = (1+(Lambda/0.1)^3)^0.1;
A3 = (1+(Lambda/0.3)^3)^(Q/3);
A4 = 1+0.35*Q;
A = 2.63*A1/(A2*A3*A4);
Gw = ((Vw+4.0)/15)^A;

GrazAngRef = deg2rad(0.1);
GrazAngTrans = asin(0.66*Lambda/SigHeight);
%GrazAngTrans = asin(0.0632*Lambda/SigHeight); % DSTO Report

% Aspect Factor Gu - Special case of 45 degrees ignored
% ====================
Gu = exp(0.3*cos(ThWindRad)*(exp(-GrazAng/0.17)/(Lambda^2+0.005)^0.2));

% Compute Reflectivity coefficient
% =========================

SigZH = 10*log10(1.7E-5*GrazAng^0.5*Gu*Gw*GA/(Lambda+0.05^1.8));
if Pol=='H'
 SigZ = SigZH;
else
 if fGHz<2
 SigZ = SigZH-10*log10(1.73*log(2.507*SigHeight+0.05)+3.76*log(Lambda)...
 +2.46*log(sin(GrazAng+0.0001))+19.8);
 else
 SigZ = SigZH-10*log10(1.05*log(2.507*SigHeight+0.05)+1.09*log(Lambda)...
 +1.27*log(sin(GrazAng+0.0001))+9.65);
 end
end

end % function
