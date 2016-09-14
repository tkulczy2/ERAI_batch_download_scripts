function [Q] = approx(X,digits)

%
% S. HSIANG
% HSIANG@NBER.ORG
% 7.11
%
% ---------------------
%
% approx(X,digits)
%
% Approximates X to a number of decimal places specified by DIGITS via
% truncation (not rounding) of a number after DIGITS decimals.
%


factor = 10^digits;

Q = floor(factor*X)/factor;




