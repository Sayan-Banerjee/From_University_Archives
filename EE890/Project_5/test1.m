clear all ;
clc;
clear;
load('SVM_data_nonlinear.mat','x','y') ;
[m, n] = size(x);
figure()
plot(x(1:m/2,1),x(1:m/2,2),'+');
hold on
plot(x((m/2)+1:m,1),x((m/2)+1:m,2),'rO');
pbaspect([1 1 1])
K_X=zeros(m,10);
for i=1:m
    K_X(i,1)= 1;
    K_X(i,2)= x(i,1);
    K_X(i,3)= x(i,2);
    K_X(i,4)= x(i,1)^2;
    K_X(i,5)= x(i,1)*x(i,2);
    K_X(i,6)= x(i,2)^2;
    K_X(i,7)= x(i,1)^3;
    K_X(i,8)= x(i,1)^2*x(i,2);
    K_X(i,9)= x(i,1)*x(i,2)^2;
    K_X(i,10)= x(i,2)^3;
end
X_T=K_X;
X=K_X';
Q=((y*y').*(X_T*X));
one=-1.*(ones(60,1));
AD=[y';(-1).*y';eye(60,60)];
zero=zeros(62,1);
[alpha,fval] = quadprog(Q,one,-AD,zero,[],[]);
for i=1:60
    if alpha(i,1)<0.00001
        alpha(i,1)=0.0;
    end
end
for i=1:60
    if alpha(i,1)~=0
    plot(x(i,1),x(i,2), '-.k*');
    end
end
W=double(zeros(1,10));
for i= 1:60
   W=W+(y(i,1)*alpha(i,1))*K_X(i,:); 
end
bias=y(6,1)-W*K_X(6,:)';
w1=W(1);
w2=W(2);
w3=W(3);
w4=W(4);
w5=W(5);
w6=W(6);
w7=W(7);
w8=W(8);
w9=W(9);
w10=W(10);
min=-5;
max=3;
random=(max-min).*rand(1000,1)+min;
random_y=zeros(1000,1);
syms y
for i=1:1000
	eqn=w1+w2*random(i)+w3*y+w4*random(i)^2+w5*random(i)*y+w6*y^2+w7*random(i)^3+w8*random(i)^2*y+w9*random(i)*y^2+w10*y^3+bias==0;
	soly=solve(eqn,y);
    soly=double(soly);
    [m,n]=size(soly);
    for j=1:m
        p=real(soly(j,n));
        %q=soly(j,n).real;
        if p>=-5 && p<=4
        random_y(i,1)=p;
        
        end
        break;
    end
end
for i=1:1000
    plot(random(i,1),random_y(i,1), '+');
end
