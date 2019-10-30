% Program plots the NEW 5-PARAMETER VGH empirical sea clutter model
% e:\work\matldat\seacl\VGH_SeaClutterModelNewGrazAng.m
% Also plots points from Nathanson 2nd ed.
% Now optimized to 60 deg grazing angle
% Average absolute error to 60 deg: 2.64 Hor, 2.54 V
%Author: Rashmi Mital
%Date: 11/30/2007
clc;
clear all;
close all;
%DEFINE CONSTANTS
c = 2.997924562e8; %Speed of Light
% Define INPUTS
%Grazing angle (data available for 0.1 0.3 1.0 3.0 10.0 30.0 60.0)
GrAng =[0.1 0.3 1.0 3.0 10.0 30.0 60.0];
%GrAng =[0.1 0.3 1.0 3.0 10.0];
%GrAng =[0.3];
NGrAng = length(GrAng);
% Nathanson Frequencies
Freq_Nath = [0.5 1.25 3 5.6 9.3 17 35];
NFreq = length(Freq_Nath);
phi = 0; %Angle betwen boresight and upwind (deg), only affects GTRI model
phi_rad = deg2rad(phi);
% Just a dummy in this program
ThWind = 0;
% Grazing Angle axis for plotting empirical curves
GrAngPlot = (0.1:0.01:60); %Frequency in GHz
GrAngMin=GrAng(1);
GrAngMax=max(GrAng);
%GrAngMax=freq(end);
%Choose Model to Compare with Nathanson Data
Model = 'NRL'; %Option: 'NRL', 'GTI','HYB','TSC'
% GRAPHICS DEFINITIONS
ha=[];hl=[];hp=[];ht=[];htx=[];hty=[];
set(0,'Units','pixels')
% Set SCreen Size
scnsize=get(0,'ScreenSize');
%pos1 = [5+scnsize(1),0.02*scnsize(4),.99*scnsize(3),.75*scnsize(4)];
FigFont = 28;
CircSize = 14;
LineSize = 7;
AxWidth = 4;
% Use these for saved jpg figures
% FigFont = 21;
% CircSize = 7;
% LineSize = 4;
% AxWidth = 3;
% Initialize figure number
nFig = 0;
% Defines units for values returned by ScreenSize
% Define colors for curves and points
Cols = 'bgrcmyk';
ColsMat = [ 0.161 0.698 0.725; % magenta
 0.608 0.18 0.8; % violet
 1.0 0.0 0.0; % red
 0.541 0.416 0.361; % brown
 0.067 0.204 0.898; % dark blue
 0.0 0.0 0.0; % black
 0.224 0.678 0.333]; % dark green
%########################################################################
% READ ALL NATHANSON TABLES

 % Initialize Tables
 Measured_SigmaHH=zeros(7,7,7); % SSPlus1,Freq,GrazAng
 Measured_SigmaVV=zeros(7,7,7);

 Measured_SigmaHH(:,:,1) = ...
 [ 0 0 -90 -87 0 0 0;
 0 0 -80 -75 -71 0 0;
 -95 -90 -75 -67 -59 -48 0;
 -90 -82 -68 -69 -53 0 0;
 0 -74 -63 -60 -48 0 0;
 0 -70 -63 -58 -42 0 0;
 0 0 0 0 0 0 0];

 Measured_SigmaVV(:,:,1) = ...
 [ 0 0 0 0 0 0 0;
 0 0 -80 -72 -65 0 0;
 -90 -87 -75 -67 -56 0 0;
 -88 -82 -75 -60 -51 0 -47;
 -85 -78 -67 -58 -48 0 -45;
 -80 -70 -63 -55 -44 0 -42;
 0 0 -56 0 0 0 0];

 Measured_SigmaHH(:,:,2) = ...
 [ 0 0 -83 -79 -74 0 0;
 0 0 -74 -68 -66 -58 0;
 -78 0 -66 -60 -56 -53 0;
 0 -68 -60 -50 -46 -42 0;
 0 0 -55 0 -42 -39 0;
 0 -64 -52 -44 -39 -38 0;
 0 0 -46 0 -34 -37 0];

 Measured_SigmaVV(:,:,2) = ...
 [ 0 -83 0 0 0 -63 -55;
 0 -78 -64 -60 -58 -54 -46;
 -80 -73 -62 -55 -52 -52 -43;
 -78 -70 -58 -50 -45 -47 -40;
 -75 -65 -57 0 -43 -44 -38;
 -73 -64 -52 0 -39 -39 -35;
 0 0 0 0 -34 -37 -31];

 Measured_SigmaHH(:,:,3) = ...
 [-86 -80 -75 -70 -60 -60 -60;
 -84 -73 -66 -56 -51 -48 -48;
 -82 -65 -55 -48 -46 -41 -38;
 -73 -60 -48 -43 -40 -37 -36;
 -63 -56 -45 -39 -36 -34 -34;
 -60 -50 -42 -36 -34 -34 0;
 0 0 -41 0 -32 -32 0];

 Measured_SigmaVV(:,:,3) = ...
 [ 0 -68 0 0 -60 -60 -60;
 -70 -65 -56 -53 -50 -50 -48;
 -63 -58 -53 -47 -44 -42 -40;
 -58 -54 -48 -43 -39 -37 -34;
 -58 -45 -42 -39 -37 -35 -32;
 0 -43 -38 -35 -33 -34 -31;
 0 0 -33 0 -31 -32 0];

 Measured_SigmaHH(:,:,4) = ...
 [-75 -72 -68 -63 -58 0 -53;
 -70 -62 -59 -54 -50 -45 -43;
 -66 -59 -53 -48 -43 -38 -40;
 -61 -55 -46 -42 -39 -35 -37;
 -54 -48 -41 -38 -35 -32 -32;
 -53 -46 -40 -36 -33 -30 0;
 0 0 -37 0 -30 -28 0];

 Measured_SigmaVV(:,:,4) = ...
 [ 0 0 0 -60 -56 -50 -48;
 -60 -53 -52 -49 -45 -41 -41;
 -53 -50 -49 -45 -41 -39 -37;
 -43 -43 -43 -40 -38 -36 -34;
 -38 -38 -38 -36 -35 -33 -31;
 -40 -38 -35 -35 -33 -31 -30;
 0 0 0 0 -28 -28 0];

 Measured_SigmaHH(:,:,5) = ...
 [ 0 -60 0 -44 -56 0 0;
 0 -56 0 -53 -51 0 0;
 -54 -53 -51 -48 -43 -37 -36;
 -50 -48 -46 -40 -37 -32 -31;
 -48 -45 -40 -36 -34 -29 -29;
 -46 -43 -38 -36 -30 -26 -27;
 -44 -40 -37 -35 -27 -24 0];

 Measured_SigmaVV(:,:,5) = ...
 [ 0 -45 0 -44 -47 -45 -44;
 -38 -39 -40 -41 -42 -40 -38;
 -35 -37 -38 -39 -36 -34 -33;
 -34 -34 -34 -34 -32 -31 -31;
 -32 -31 -31 -32 -29 -28 -29;
 -30 -30 -28 -28 -25 -23 -26;
 -30 -29 -28 -27 -22 -18 0];

 Measured_SigmaHH(:,:,6) = ...
 [ 0 -50 -50 -50 -48 -45 0;
 0 -46 0 -48 -44 -38 0;
 -42 -41 -40 -42 -38 -35 -35;
 -40 -39 -38 -37 -34 -28 -29;
 -38 -37 -37 -35 -29 -21 -21;
 -35 -34 -32 -30 -26 -18 -20;
 -33 -32 -30 -29 -21 -16 0];

 Measured_SigmaVV(:,:,6) = ...
 [ 0 -42 -42 -42 -37 -33 0;
 -38 -38 -40 -42 -36 -31 -35;
 -30 -31 -32 -34 -32 -26 -30;
 -28 -30 -29 -28 -26 -23 -23;
 -28 -28 -27 -25 -24 -22 -22;
 -28 -24 -23 -22 -22 -18 -20;
 -25 -32 -30 -29 -21 -16 0];
 Measured_SigmaHH(:,:,7) = ...
 [ -32 -32 -32 -27 -25 -22 -26;
 -22 -24 -25 -26 -24 -20 0;
 -22 -21 -21 -22 -23 -18 0;
 -21 -20 -20 -20 -21 -16 -16;
 -21 -18 -17 -16 -15 -12 -12;
 -21 -18 -17 -17 -14 -10 0;
 -20 -19 -17 -16 -12 -10 0];

 Measured_SigmaVV(:,:,7) = ...
 [-32 -33 -34 -26 -23 -22 0;
 -23 -22 -24 -24 -24 -20 -24;
 -20 -21 -21 -23 -18 -18 -19;
 -18 -18 -19 -18 -16 -14 -14;
 -14 -15 -15 -15 -14 -11 -10;
 -18 -15 -15 -15 -13 -11 -4;
 -18 -17 -15 -14 -11 -10 0];


 for iFreq = 1:NFreq
 FNow = Freq_Nath(iFreq);
 nFig = nFig + 2;

 % Default plot limits
 SigmaMin=-100;
 SigmaMax=0;

 % Define Plot Axes
 minyaxis=SigmaMin;
 maxyaxis=SigmaMax;
 minxaxis=GrAngMin;
 maxxaxis=GrAngMax;


 hFig=figure(nFig-1); % Plot Hor Pol

 %set(hFig,'Position',pos1);

 ht(end+1)=gca;
 ha(end+1)=gca;
 set (ha(end),'PlotBoxAspectRatio',[1 .2 .5])

 % Do all sea states for HH
 for SeaSt=0:6
 SeaState=SeaSt;
 SS_Plus1 = SeaState + 1;

 Pol = 'H';

 switch upper(Model)
 case 'NRL'
 SigZHor = NRL_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot,ThWind);
 case 'GTI'
 for iAng = 1 : length(GrAngPlot)
 SigZHor(iAng) = GTI_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot(iAng),ThWind);
 end
 case 'HYB'
 for iAng = 1 : length(GrAngPlot)
 SigZHor(iAng) = HYB_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot(iAng),ThWind);
 end
 case 'TSC'
 for iAng = 1: length(GrAngPlot)
 SigZHor(iAng) = TSC_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot(iAng),ThWind);
 end
   otherwise, error('invalid model')
 end

% SigZHor = VGHSigmaSeaNew(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot,ThWind);

 SigmaHH = SigZHor;

 % Plot empirical curve first
 NOWColorH=ColsMat(SeaSt+1,:);
 %figure(nFig-1)
 % hl(end+1) = semilogx(freq,SigmaHH,'LineWidth',LineSize);
 hl(end+1) = semilogx(GrAngPlot,SigmaHH);
 hold on
 set(hl(end),'Color',ColsMat(SeaSt+1,:));
 end

 for SeaSt=0:6
 SeaState=SeaSt;
 SS_Plus1 = SeaState + 1;
 % Plot measured values from Nathanson
 for ii=1:NGrAng
 if Measured_SigmaHH(SS_Plus1,iFreq,ii) ~= 0
 hp(end+1) = semilogx(GrAng(ii),Measured_SigmaHH(SS_Plus1,iFreq,ii),'o');
 set(hp(end),'Color',ColsMat(SeaSt+1,:)); % Use as example for custom colors
 hold on
 end
 end
 end % END Sea State Loop

 grid on;



 set(gca,'YLim',[minyaxis maxyaxis],'XLim',[minxaxis maxxaxis]);
 htx(end+1) = xlabel('Grazing Angle - \beta (deg) ');
 hty(end+1) = ylabel('Reflectivity - \sigma_{HH}^0 (dB)');

 %set(ha,'YLim',[minyaxis maxyaxis],'XLim',[minxaxis maxxaxis]);
%  set(ha,'FontWeight','Bold');
%  set(ha,'FontSize',FigFont-2);
%  set(ha,'FontName','Arial')
%  set(htx,'FontSize',FigFont);
%  set(htx,'FontName','Arial')
%  set(htx,'FontWeight','Bold');
%  set(hty,'FontSize',FigFont);
%  set(hty,'FontName','Arial')
%
%  set(hty,'FontWeight','Bold');
%  set(hl,'LineWidth',LineSize);
%  set(hp,'LineWidth',CircSize);
%  set(ha,'LineWidth',AxWidth);
 set(ha,'xtick',[0.1,.2,0.3,0.5,0.7,1.0,2.0,3.0,4.0,7.0,10.0,20.0,...
 30.0,50.0,70.,90.]);
 set(ha,'XLim',[0.1 90])

 % whitebg(gcf,[1 1 1])

 set (gca,'PlotBoxAspectRatio',[1 .7 1])
 FilFig = ['HH_VGHNew' num2str(round(10*FNow))];
 %saveas(gcf, [FilFig '.jpg'])
 %pause

 hFig=figure(nFig); % Plot Vert Pol First

 ht(end+1)=gca;
 ha(end+1)=gca;
 %set(gcf,'Position',pos1);
 %set (ha(end),'PlotBoxAspectRatio',[1 .7 1])

 % Do all sea states for VV
 for SeaSt=0:6
 SeaState=SeaSt;
 SS_Plus1 = SeaState + 1;
 Pol = 'V';

 switch upper(Model)
 case 'NRL'
 SigZVer = NRL_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot,ThWind);
 case 'GTI'
 for iAng = 1: length(GrAngPlot)
 SigZVer(iAng) = GTI_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot(iAng),ThWind);
 end
 case 'HYB'
 for iAng = 1: length(GrAngPlot)
 SigZVer(iAng) = HYB_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot(iAng),ThWind);
 end
 case 'TSC'
 for iAng = 1:length(GrAngPlot)
 SigZVer(iAng) = TSC_SigmaSea(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot(iAng),ThWind);
 end
 end
% SigZVer = VGHSigmaSeaNew(Freq_Nath(iFreq),SeaState,Pol,GrAngPlot,ThWind);
 SigmaVV = SigZVer;

 NOWColorV=ColsMat(SeaSt+1,:);

 hl(end+1) = semilogx(GrAngPlot,SigmaVV); %'LineWidth',7);
 set(hl(end),'Color',ColsMat(SeaSt+1,:));
 hold on
 end

 for SeaSt=0:6
 SeaState=SeaSt;
 SS_Plus1 = SeaState + 1;
 Pol = 'V';
 % Plot measured values from Nathanson




 for ii=1:NGrAng
 if Measured_SigmaVV(SS_Plus1,iFreq,ii) ~= 0
 hp(end+1) = semilogx(GrAng(ii),Measured_SigmaVV(SS_Plus1,iFreq,ii),'o'); %,'LineWidth',CircSize);
 %htemp=semilogx(Freq_Nath(ii),Measured_SigmaVV(SS_Plus1,ii),'-','LineWidth',1);
 set(hp(end),'Color',ColsMat(SeaSt+1,:));
 hold on
 end
 end

 hold on;
 end % END Sea State Loop

 grid on;

 set(gca,'YLim',[minyaxis maxyaxis],'XLim',[minxaxis maxxaxis]);
 htx(end+1) = xlabel('Grazing Angle - \beta (deg) ');
 hty(end+1) = ylabel('Reflectivity - \sigma_{VV}^0 (dB)');
 %title('DOPPLER ESTIMATION','FontSize',20,'FontWeight','bold');


 grid on;

 %set(ha,'YLim',[minyaxis maxyaxis],'XLim',[minxaxis maxxaxis]);
%  set(ha,'FontWeight','Bold');
%  set(ha,'FontSize',FigFont-2);
%  set(ha,'FontName','Arial')
%  set(htx,'FontSize',FigFont);
%  set(htx,'FontName','Arial')
%  set(htx,'FontWeight','Bold');
%  set(hty,'FontSize',FigFont);
%  set(hty,'FontName','Arial')
%  set(hty,'FontWeight','Bold');
%  set(hl,'LineWidth',LineSize);
%  set(hp,'LineWidth',CircSize);
%  set(ha,'LineWidth',AxWidth);
 set(ha,'xtick',[0.1,.2,0.3,0.5,0.7,1.0,2.0,3.0,4.0,7.0,10.0,20.0,...
 30.0,50.0,70.,90.0]);
 set(ha,'XLim',[0.1 90])

 % whitebg(gcf,[1 1 1])

 set (gca,'PlotBoxAspectRatio',[1 .7 1])
 FilFig = ['VV_VGHNew' num2str(round(10*FNow))];
 %saveas(gcf, [FilFig '.jpg'])

end % END Frequency Loop
