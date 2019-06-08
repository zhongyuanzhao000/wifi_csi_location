%仿真验证基于一发三收的定位算法
clc; clear; close all;
% 收发器坐标如下：
x_t = 0; y_t = 0; %发射器T坐标
x_r1 = 0; y_r1 = 4; %接收器R1的坐标
x_r2 = 4; y_r2 = 0; %接收器R2的坐标
x_r3 = 4; y_r3 = 4; %接收器R3的坐标

%获取接收器R1、接收器R2和接收器R3实测的路径变化速度，分别为v_path1、v_path2、v_path3
[cir, tang] = get_circle_position([2,2], 1, 0.5); % 获取轨迹圆上的各个点的坐标cir，以及每个点的切线的向量坐标tang
cir = round(cir*100)/100;     %将坐标值保留至两位小数
tang = round(tang*100)/100;

% figure;
% plot(tang(:,1),tang(:,2));

cnt = size(cir,1); % 获取坐标点的个数
v_path = zeros(cnt,3);
for i = 1 : cnt
    x_p1 = (cir(i,1) - x_t)/sqrt((cir(i,1)-x_t)^2+(cir(i,2)-y_t)^2) +(cir(i,1) - x_r1)/sqrt((cir(i,1)-x_r1)^2+(cir(i,2)-y_r1)^2);
    y_p1 = (cir(i,2) - y_t)/sqrt((cir(i,1)-x_t)^2+(cir(i,2)-y_t)^2) +(cir(i,2) - y_r1)/sqrt((cir(i,1)-x_r1)^2+(cir(i,2)-y_r1)^2);
    x_p2 = (cir(i,1) - x_t)/sqrt((cir(i,1)-x_t)^2+(cir(i,2)-y_t)^2) +(cir(i,1) - x_r2)/sqrt((cir(i,1)-x_r2)^2+(cir(i,2)-y_r2)^2);
    y_p2 = (cir(i,2) - y_t)/sqrt((cir(i,1)-x_t)^2+(cir(i,2)-y_t)^2) +(cir(i,2) - y_r2)/sqrt((cir(i,1)-x_r2)^2+(cir(i,2)-y_r2)^2);
    x_p3 = (cir(i,1) - x_t)/sqrt((cir(i,1)-x_t)^2+(cir(i,2)-y_t)^2) +(cir(i,1) - x_r3)/sqrt((cir(i,1)-x_r3)^2+(cir(i,2)-y_r3)^2);
    y_p3 = (cir(i,2) - y_t)/sqrt((cir(i,1)-x_t)^2+(cir(i,2)-y_t)^2) +(cir(i,2) - y_r3)/sqrt((cir(i,1)-x_r3)^2+(cir(i,2)-y_r3)^2);
    
    v_path(i,1) = tang(i,1) * x_p1 + tang(i,2) * y_p1;
    v_path(i,2) = tang(i,1) * x_p2 + tang(i,2) * y_p2;
    v_path(i,3) = tang(i,1) * x_p3 + tang(i,2) * y_p3;
end
[raw, col] = size(v_path); 

for ii = 1 : raw

    v_path1 = v_path(ii,1);
    v_path2 = v_path(ii,2);
    v_path3 = v_path(ii,3);
    
    %假设的人体坐标为x_h,y_h
    prob_max = 0; %最大位置可能性
    x_vh_res = 0; y_vh_res = 0;
    x_h_res = 0; y_h_res = 0; 
    %遍历监测区域可能的位置坐标
    for x_h = 0.1 :0.01: 4
        for y_h = 0.1 :0.01: 4
            %x_p = (x_h - x_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(x_h - x_r)/sqrt((x_h-x_r)^2+(y_h-y_r)^2);
            %y_p = (y_h - y_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(y_h - y_r)/sqrt((x_h-x_r)^2+(y_h-y_r)^2);
            %计算收、发器之间的向量
            x_p1 = (x_h - x_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(x_h - x_r1)/sqrt((x_h-x_r1)^2+(y_h-y_r1)^2);
            y_p1 = (y_h - y_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(y_h - y_r1)/sqrt((x_h-x_r1)^2+(y_h-y_r1)^2);
            x_p2 = (x_h - x_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(x_h - x_r2)/sqrt((x_h-x_r2)^2+(y_h-y_r2)^2);
            y_p2 = (y_h - y_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(y_h - y_r2)/sqrt((x_h-x_r2)^2+(y_h-y_r2)^2);
            x_p3 = (x_h - x_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(x_h - x_r3)/sqrt((x_h-x_r3)^2+(y_h-y_r3)^2);
            y_p3 = (y_h - y_t)/sqrt((x_h-x_t)^2+(y_h-y_t)^2) +(y_h - y_r3)/sqrt((x_h-x_r3)^2+(y_h-y_r3)^2);

            %根据v_path1、v_path2以及收、发端的位置，计算人体速度向量vh的向量坐标
            x_vh = (v_path1*y_p2 - v_path2*y_p1)/(x_p1*y_p2 - x_p2*y_p1);
            y_vh = (v_path1*x_p2 - v_path2*x_p1)/(y_p1*x_p2 - y_p2*x_p1);

            %计算接收器R3的 期望的路径变化速度v_path3_e
            v_path3_e = x_vh * x_p3 + y_vh * y_p3;

            %计算人体位于当前位置的可能性
            prob = 1/(v_path3_e-v_path3)^2;
            if prob == Inf
                x_h_res = x_h;
                y_h_res = y_h;
                break;
            end
            if(prob > prob_max)
                prob_max = prob;
                x_vh_res = x_vh; 
                y_vh_res = y_vh;
                x_h_res = x_h;
                y_h_res = y_h;
            end
        end
    end
    figure(10);
%     axis([0  5  0  5]);
    axis equal
%     str = ['人体位置的坐标为:( ',num2str(x_h_res),' , ',num2str(y_h_res),' )','速度向量坐标为:( ',num2str(x_vh_res),' , ',num2str(y_vh_res),' )'];
%     title(str);
    circle(x_h_res, y_h_res, 0.05);
    drawArrow([x_h_res  y_h_res],[x_h_res+x_vh_res  y_h_res+y_vh_res]);
    hold on;
end
xlabel('x轴'); ylabel('y轴');
title('定位跟踪的轨迹图');