A=[1 2;3 4];
M=zeros(6,6);
k=0
m=0
for i=1:2
    
   
for j=1:2
M(i+m,j+k)=A(i,j);
M(i+m,j+1+k)=A(i,j);
M(i+m,j+2+k)=A(i,j);
M(i+1+m,j+k)=A(i,j);
M(i+1+m,j+1+k)=A(i,j);
M(i+1+m,j+2+k)=A(i,j);
M(i+2+m,j+k)=A(i,j);
M(i+2+m,j+1+k)=A(i,j);
M(i+2+m,j+2+k)=A(i,j);
k=k+2;

end

end

