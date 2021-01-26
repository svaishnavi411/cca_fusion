function [XY_new] = hotelling_deflation_normalized(XY, u, v)

factor = sum(sum((XY .*(u*v')))) / sum(sum(((u*v') .*(u*v'))));
XY_new = (XY - factor*(u*v')); 
XY_new = XY_new/norm(XY_new, "fro");
