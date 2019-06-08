%% 绘制带箭头的直线
function drawArrow(start_point, end_point,arrColor,lineColor,arrowSize,lineWidth)
% 从start_point到end_point画一箭头,arrColor箭头颜色,arrSize，箭头大小
%判断参数多少
switch nargin
    case 2
        arrColor  = 'r';
        lineColor = 'b';
        arrowSize = 2;
        lineWidth = 1;
    case 3
        lineColor = 'b';
        arrowSize = 2;
        lineWidth = 1;
    case 4
        arrowSize = 2;
        lineWidth = 1;
    case 5
        lineWidth = 1;
end
K                = 0.05;                    % 箭头比例系数
theta            = pi / 8;                  % 箭头角度
A1 = [cos(theta), -sin(theta);
    sin(theta), cos(theta)];                % 旋转矩阵
theta = -theta;
A2 = [cos(theta), -sin(theta);
    sin(theta), cos(theta)];                % 旋转矩阵
 
arrow           = start_point' - end_point';
%使得箭头跟直线长短无关(固定值)
arrow(arrow>=0) = arrowSize;
arrow(arrow<0)  = -arrowSize;
 
arrow_1         = A1 * arrow;
arrow_2         = A2 * arrow;
arrow_1         = K * arrow_1 + end_point'; % 箭头的边的x坐标
arrow_2         = K * arrow_2 + end_point'; % 箭头的变的y坐标
 
hold on;
grid on;
axis equal;
plot([start_point(1), end_point(1)], [start_point(2), end_point(2)],lineColor,'lineWidth',lineWidth);
% 三角箭头(填充)
triangle_x      = [arrow_1(1),end_point(1),arrow_2(1),arrow_1(1)];
triangle_y      = [arrow_1(2),end_point(2),arrow_2(2),arrow_1(2)];
fill(triangle_x,triangle_y,arrColor);
% 线段箭头(不填充)
% plot([arrow_1(1), end_point(1)], [arrow_1(2), end_point(2)],color,'lineWidth',arrowSize);
% plot([arrow_2(1), end_point(1)], [arrow_2(2), end_point(2)], color,'lineWidth',arrowSize);
hold off;
end
