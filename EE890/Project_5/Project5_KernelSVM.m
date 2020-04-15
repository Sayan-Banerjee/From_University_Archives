clear all ; 
load('SVM_data_nonlinear.mat','x','y') ;
[m, n] = size(x);
figure()
plot(x(1:m/2,1),x(1:m/2,2),'+');
hold on
plot(x((m/2)+1:m,1),x((m/2)+1:m,2),'rO');
pbaspect([1 1 1])
X_T=x;
X=x';
K=(X_T*X);
K=1+K;
K=K.^3;
Q=((y*y').*K);
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
SV=X(:,6);
bias=0.0;
for i=1:60
    if alpha(i,1)~=0
        
        K_b=(X_T(i,:)*SV);
        K_b=1+K_b;
        K_b=K_b^3;
        bias=bias+(alpha(i,1)*y(i,1)*K_b);
    end
end
length=1;
boundary=zeros(100,2);
while length<101
    random_x1=(3-(-5)).*rand(1,1)+(-5);
    random_x2=(2-(-3)).*rand(1,1)+(-3);
    p=[random_x1;random_x2];
    g=0.0;
    for i=1:60
        
        if alpha(i,1)~=0
        
        K_p=(X_T(i,:)*p);
        K_p=1+K_p;
        K_p=K_p.^3;
        g=g+(alpha(i,1)*y(i,1)*K_p);
        
        end
        
    end
        g=g+bias;
        if abs(g)<0.00001
            boundary(length,1)=random_x1;
            boundary(length,2)=random_x2;
            length=length+1;
        end
            
            
end