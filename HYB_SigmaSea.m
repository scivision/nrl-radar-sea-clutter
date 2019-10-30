function SigZ = HYB_SigmaSea(fGHz,SS,Pol,Psi,ThWind)

% This function implements the Hybrid sea clutter reflectivity model
% described in Reilly and Dockery : Influence of evaporation duct
% on radar sea return, IEE Proc. Pt. F, April 1990.

% Wind direction is relative to radar look direction - upwind is 0 deg
% ThWind=0 deg is worst case (highest reflectivity)
% At S-band average is 2 dB lower
% At X-band average is 3.85 dB lower

% Model is not valid for Sea State 0
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

if freq > 12.5
 SigZRef = 3.25*log10(freq) - 42.0;
else
 SigZRef = 24.4*log10(freq)-65.2;
end

SigHeight = 0.031*SeaState^2;
hWave = 0.08*SeaState^2;

% Grazing Angle Adjustment
% ========================
GrazAngRef = deg2rad(0.1);
GrazAngTrans = asin(0.66*Lambda/SigHeight);
%GrazAngTrans = asin(0.0632*Lambda/SigHeight); % DSTO Report

if GrazAngTrans<GrazAngRef
 if GrazAng > GrazAngRef
 KGraz = 10*log10(GrazAng/GrazAngRef);
 else
 KGraz=0;
 end
else % Transitional >= Reference
 if GrazAng<GrazAngRef
 KGraz=0;
 elseif (GrazAng >= GrazAngRef) && (GrazAng<=GrazAngTrans)
 KGraz = 20*log10(GrazAng/GrazAngRef);
 else
 KGraz = 10*log10(GrazAng/GrazAngTrans)+20*log10(GrazAngTrans/GrazAngRef);
 end
end

% Sea State Adjustment
% ====================
KSea = 5*(SeaState - 5);

% Polarization Adjustment
% =======================
if Pol=='H'
 if freq<3
 KPol = 1.7*log(hWave+0.015) - 3.8*log(Lambda) - 2.5*log(GrazAng/57.3 + 0.0001)-22.2;
 elseif (freq>=3) && (freq<=10)
 KPol = 1.1*log(hWave+0.015) - 1.1*log(Lambda) - 1.3*log(GrazAng/57.3 + 0.0001)-9.7;
 else
 KPol = 1.4*log(hWave) - 3.4*log(Lambda) - 1.3*log(GrazAng/57.3)-18.6;
 end
elseif Pol == 'V'
 KPol = 0;
else
 error('Incorrect Polarization Specified')
end

% Wind Direction Adjustment
% =========================
KDir = (2+1.7*log(0.1/Lambda))*(cos(ThWind)-1);

% Resultant Sigma Zero
% ====================
SigZ = SigZRef + KGraz +KSea + KPol + KDir;

end % function