function Y = getNormalization(X1, X2)
% --------------------------------------------------------------------
% Normalizating data set
% --------------------------------------------------------------------
% Input:
%       - X, input data
% Output:
%       - Y, output data
%------------------------------------------
% Author: Lei Du, leidu@iu.edu
% Date created: DEC-19-2014
% Updated: Jan-16-2015
% @Indiana University School of Medicine.
% -----------------------------------------

[~,n] = size(X1);
Y = X1;

for j = 1 : n
    Xv = X1(:,j);
    Xz = X2(:,j);
    Xvn = (Xv-mean(Xz))/std(Xz);
    Y(:,j) = Xvn;
end
