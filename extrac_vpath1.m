%在选定的包的区间提取一次Vpath
clc; clear; close all;
csi_trace = fiel_read('D:\data_5.19\empty1.dat');
% csi_trace = read_bf_file('D:\data_5.13\walk1.dat');
M = 200; %样本数
N = 300; %采样起点   walk1中的2200、3500、4800、4900
f = 2.4e+9; %载波频率
c = 3e+8; %光速
X = []; %信号数据

% for ii = 1 : M
%     csi_entry = get_scaled_csi(csi_trace{ii+N-1});
%     x1 = squeeze(csi_entry(1,1,:)).';
%     abs_x1 = abs(x1);
%     alpha = min(abs_x1(abs_x1~=0));
%     x1 = abs(abs(x1)-alpha).*exp(1i*angle(x1));
%     
%     x2 = squeeze(csi_entry(1,2,:)).';
%     abs_x2 = abs(x2);
%     beta = max(abs_x2);
%     x2 = abs(abs(x2)+beta).*exp(1i*angle(x2));
%     
%     x3 = x1 .* conj(x2);
%     X = [X; x3];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = []; X2 = [];
for ii = 1 : M
    csi_entry = get_scaled_csi(csi_trace{ii+N-1});
    x1 = squeeze(csi_entry(1,1,:)).';
    X1 = [X1; x1];
end
for ii1 = 1 : 30
    abs1 = abs(X1(:,ii1));
    alpha = min(abs1(abs1~=0));
    X1(:,ii1) = abs(abs( X1(:,ii1))-alpha).*exp(1i*angle( X1(:,ii1)));
end

for ii = 1 : M
    csi_entry = get_scaled_csi(csi_trace{ii+N-1});
    x2 = squeeze(csi_entry(1,2,:)).';
    X2 = [X2; x2];
end
for ii1 = 1 : 30
    abs2 = abs(X1(:,ii1));
    beta = max(abs2);
    X2(:,ii1) = abs(abs( X2(:,ii1))+beta).*exp(1i*angle( X2(:,ii1)));
end
X = X1 .* conj(X2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%

mX = mean(X,1);
for ii1 = 1 : M
    X(ii1,:) = X(ii1,:) - mX;
end

%pca处理,数据降维并生成新数据矩阵X
% [X,T,meanValue] = pca_row(X,0.95);
%%
%获取各样本与第一个样本的时间间隔的向量t
t = [];

t0 = csi_trace{N}.timestamp_low;
for ij = 1 : M
    tt = csi_trace{ij+N-1}.timestamp_low;
    t(ij) = 0.001*(tt - t0);
end
%%
%music处理 
Rx = X * X' / 30;
[EV,D]=eig(Rx);    % 特征向量 特征值
EVA=diag(D)';
% figure;
% plot(EVA);

En = EV(:,1:M-3);
for jj = 1 : 101
    vel(jj) = (jj - 51)/10;
    a=exp(-1i*2*pi*f*vel(jj)*t/c).';
    SP(jj)=1/(a'*En*En'*a);
end

SP=abs(SP);
SP=10*log10(SP);
[SP_max, jj] = max(SP);
figure;
h=plot(vel,SP);
% axis([-5  5  -20  -17]);
str = ['采样起点为:',num2str(N),', 采样数量为:',num2str(M),', 最高尖峰对应速度为:',num2str(vel(jj)),' m/s'];
title(str);  xlabel('路径变化速度(m/s)');  ylabel('功率');
grid on;