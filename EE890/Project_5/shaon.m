clear all ;
close all;
%%
load('SVM_data.mat','x','y') ;
[m, n] = size(x);
figure()
plot(x(1:m/2,1),x(1:m/2,2),'g+');
hold on
plot(x((m/2)+1:m,1),x((m/2)+1:m,2),'b+');
pbaspect([1 1 1])
 
%%
 
a=y*y';
b=x*x';
q=a.*b;
f=-1*ones(40,1);
lb=zeros(40,1);
c=0;
A=y';
 
%%
options = optimoptions('quadprog',...
    'Algorithm','interior-point-convex','Display','off');
[alpha,fval,exitflag,output,lambda] = ...
   quadprog(q,f,[],[],A,c,lb,[],[],options);
%%
for i=1:40
   if alpha(i,1)<0.0001
       alpha(i,1)=0;
   else
       alpha(i,1)=alpha(i,1);
   end
   
end
 
W=(alpha.*y)'*x;
%%
n=length(find(alpha>0));
index=zeros(n,1);
index=find(alpha>0);
 
%%
b=zeros(n,1);
for i=1:n
    cons=1/y(index(i,1),1);
    b(i,1)=cons-W*x(index(i,1),:)';
end
avB=sum(b(:))/length(b(:));