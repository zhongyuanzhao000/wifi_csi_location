clc; clear; close all;
%%%%%%%%%%%%%%%%%% MUSIC %%%%%%%%%%%%%%%%%%
derad = pi/180;
N = 8;               % 阵元个数        
M = 3;               % 信源数目
theta = [-20 10 50];  % 待估计角度
snr = 10;            % 信噪比
K = 1024;            % 快拍数 10/1024

dd = 0.5;            % 阵元间距 d=lamda/2      
d=0:dd:(N-1)*dd;
A=exp(-1i*2*pi*d.'*sin(theta*derad));
S=randn(M,K); X=A*S;
X1=awgn(X,snr,'measured');


Rxx=X1*X1'/K;
%InvS=inv(Rxx); 
[EV,D]=eig(Rxx);    % 特征向量 特征值
EVA=diag(D)';
[EVA,I]=sort(EVA);  % 从小到大排列 返回索引
%EVA=fliplr(EVA);   % 反转元素
EV=fliplr(EV(:,I)); % 按列反转特征向量

for iang = 1:361    % 遍历
        angle(iang)=(iang-181)/2;
        phim=derad*angle(iang);
        a=exp(-1i*2*pi*d*sin(phim)).';
        L=M;    
        En=EV(:,L+1:N);
        %SP(iang)=(a'*a)/(a'*En*En'*a);
        SP(iang)=1/(a'*En*En'*a);
end
SP=abs(SP);
%SPmax=max(SP);
%SP=10*log10(SP/SPmax);  % 归一化
SP=10*log10(SP);
h=plot(angle,SP);
set(h,'Linewidth',0.5);
xlabel('入射角/(degree)');
ylabel('空间谱/(dB)');
%axis([-100 100 -40 60]);
set(gca, 'XTick',[-100:20:100]);
grid on;  