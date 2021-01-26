function [XY_new] = hotelling_deflation(XY, u, v)

XY_new = XY - (u*u')*XY*(v*v');
