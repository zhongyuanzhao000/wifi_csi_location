%画圆函数，（x,y）为圆心坐标，r为半径
function [ ] = circle( x, y, r)
    rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1]),axis equal
end