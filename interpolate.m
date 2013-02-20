function [ thrust ] = interpolate( curve, t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    thrust = curve(2, sum(curve(1, :) <= t));

end

