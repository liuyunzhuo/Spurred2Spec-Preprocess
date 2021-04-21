function [R,G,B]=spec2RGB(Wavelength)

%clc,clear;
%Wavelength=input('Wavelength=?');
gamma = 0.8;
IntensityMax = 255; 
rectify = 1;
if Wavelength >= 380 && Wavelength <= 440
    attenuation = 0.3 + 0.7 * (Wavelength - 380) / (440 - 380);
    Red = ((-(Wavelength - 440) / (440 - 380)) * attenuation)^gamma;
    Green = 0.0;
    Blue = rectify*(1.0 * attenuation)^gamma;
elseif Wavelength >= 440 && Wavelength <= 490
    Red = 0.0;
    Green = ((Wavelength - 440) / (490 - 440))^gamma;
    Blue = 1.0;
elseif Wavelength >= 490 && Wavelength <= 510
    Red = 0.0;
    Green = 1.0;
    Blue = (-(Wavelength - 510) / (510 - 490))^gamma;
elseif Wavelength >= 510 && Wavelength <= 580
    Red = ((Wavelength - 510) / (580 - 510))^gamma;
    Green = 1.0;
    Blue = 0.0;
elseif Wavelength >= 580 && Wavelength <= 645
    Red = 1.0;
    Green = (-(Wavelength - 645) / (645 - 580))^gamma;
    Blue = 0.0;
elseif Wavelength >= 645 && Wavelength <= 750
    attenuation = 0.3 + 0.7 * (750 - Wavelength) / (750 - 645);
    Red = (1.0 * attenuation)^gamma;
    Green = 0.0;
    Blue = 0.0;
else
    Red = 0.0;
    Green = 0.0;
    Blue = 0.0;
end
R = Red; 
G = Green; 
B = Blue ;
% R = R./(R+G+B); G = G./(R+G+B); B = B./(R+G+B);