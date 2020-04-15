clear all;
load('SVM_data.mat','x','y') ;
[m, n] = size(x);
figure()
plot(x(1:m/2,1),x(1:m/2,2),'+');
hold on
plot(x((m/2)+1:m,1),x((m/2)+1:m,2),'rO');
pbaspect([1 1 1])
target=y;
X_T=x;
X=x';
Q=((y*y').*(X_T*X));
one=-1.*(ones(40,1));
AD=[y';(-1).*y';eye(40,40)];
zero=zeros(42,1);
[alpha,fval] = quadprog(Q,one,-AD,zero,[],[]);
for i=1:40
    if alpha(i,1)<0.00001
        alpha(i,1)=0.0;
    end
end
W=double(zeros(1,2));
for i= 1:40
   W=W+(y(i,1)*alpha(i,1))*x(i,:); 
end
b=y(3,1)-W*x(3,:)';
plot(x(3,1),x(3,2), '-.k*');
plot(x(26,1),x(26,2), '-.k*');
plot(x(27,1),x(27,2), '-.k*');
x = linspace(-4,4);
w1=W(1,1);
w2=W(1,2);
y=(-b-w1*x)/w2;
line(x,y)
y=(1-b-w1*x)/w2;
line(x,y,'Color','red','LineStyle','--')
y=(-1-b-w1*x)/w2;
line(x,y,'Color','red','LineStyle','--')

