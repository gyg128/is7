close all;clc;
md = java.security.MessageDigest.getInstance('SHA-256');
img=imread('lena.jpg');
%disp(size(img));
imshow(img);
[h,w]=size(img);
signedImg=int8(img);
byteImg=reshape(signedImg,1,h*w);
md.update(byteImg);
key=double(md.digest);
%disp(key);
%strMD5 = sprintf('%02X',typecast(md.digest,'uint8'));
%disp(strMD5);
beforeParam=zeros(1,7);
beforeParam(1)=0.5673;
beforeParam(2)=0.3791;
beforeParam(3)=0.7438;
beforeParam(4)=3.4586;
beforeParam(5)=6.1289;
beforeParam(6)=0.1357;
beforeParam(7)=-0.4895;
interSumKey=0;
for j=1:32
    interSumKey=interSumKey+key(j)*pow2(8*(j-1))/pow2(256);
end
%disp(interSumKey);
t=zeros(1,7);
for i=1:7
    %disp(beforeParam(i)+((key(3*i-1)+3*i-1)/(key(3*i)+3*i))*interSumKey);
    t(i)=mod(beforeParam(i)+((key(3*i-1)+3*i-1)/(key(3*i)+3*i))*interSumKey,1);
end
%disp(beforeParam);
%disp(t);
afterParam=zeros(1,7);
afterParam(1)=mod(t(1),0.4)+0.5;
afterParam(2)=mod(10*t(2),0.4)+0.5;
afterParam(3)=mod(100*t(3),0.4)+0.5;
afterParam(4)=1+9*t(4);
afterParam(5)=1+9*t(5);
afterParam(6)=-1+2*t(6);
afterParam(7)=-1+2*t(7);
%disp(afterParam);
beforeX=afterParam(2);
beforeY=afterParam(3);
%disp(pi);
for i=1:1001
    beforeX=sin(pi*afterParam(1)*(beforeY+3)*beforeX*(1-beforeX));
    beforeY=sin(pi*afterParam(1)*(beforeX+3)*beforeY*(1-beforeY));
end
maxHW=max(h,4*w);
%disp(maxHW);
X=zeros(h,1);
Y=zeros(1,4*w);
X(1)=beforeX;
Y(1)=beforeY;
%disp(x);
%disp(y);
for i=1:maxHW-1
    X(i+1)=sin(pi*afterParam(1)*(Y(i)+3)*X(i)*(1-X(i)));
    Y(i+1)=sin(pi*afterParam(1)*(X(i+1)+3)*Y(i)*(1-Y(i)));
end
M=X(1:h)*Y(1:4*w);
%disp(size(M));
IT=zeros(h,4*w);
for i=1:h
    for j=1:4*w
        if ((M(i,j)>0)&&(M(i,j)<=0.125))
            IT(i,j)=1;
        elseif ((M(i,j)>0.125)&&(M(i,j)<=0.25))
            IT(i,j)=2;
        elseif ((M(i,j)>0.25)&&(M(i,j)<=0.375))
            IT(i,j)=3;
        elseif ((M(i,j)>0.375)&&(M(i,j)<=0.5))
            IT(i,j)=4;
        elseif ((M(i,j)>0.5)&&(M(i,j)<=0.625))
            IT(i,j)=5;
        elseif ((M(i,j)>0.625)&&(M(i,j)<=0.75))
            IT(i,j)=6;
        elseif ((M(i,j)>0.75)&&(M(i,j)<=0.875))
            IT(i,j)=7;
        else
            IT(i,j)=8;
        end
    end
end
P2=zeros(h,4*w);
for i=1:h
    for j=1:w
        if ((bitget(img(i,j),8)==0)&&(bitget(img(i,j),7)==0))
            if (IT(i,4*(j-1)+1)==1)
                P2(i,4*(j-1)+1)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                P2(i,4*(j-1)+1)=1;
            elseif (IT(i,4*(j-1)+1)==3)
                P2(i,4*(j-1)+1)=3;
            elseif (IT(i,4*(j-1)+1)==4)
                P2(i,4*(j-1)+1)=4;                
            elseif (IT(i,4*(j-1)+1)==5)
                P2(i,4*(j-1)+1)=3;               
            elseif (IT(i,4*(j-1)+1)==6)
                P2(i,4*(j-1)+1)=4;                
            elseif (IT(i,4*(j-1)+1)==7)
                P2(i,4*(j-1)+1)=2; 
            else
                P2(i,4*(j-1)+1)=2;
            end
        elseif ((bitget(img(i,j),8)==0)&&(bitget(img(i,j),7)==1))
            if (IT(i,4*(j-1)+1)==1)
                P2(i,4*(j-1)+1)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                P2(i,4*(j-1)+1)=4;
            elseif (IT(i,4*(j-1)+1)==3)
                P2(i,4*(j-1)+1)=1;
            elseif (IT(i,4*(j-1)+1)==4)
                P2(i,4*(j-1)+1)=1;                
            elseif (IT(i,4*(j-1)+1)==5)
                P2(i,4*(j-1)+1)=2;               
            elseif (IT(i,4*(j-1)+1)==6)
                P2(i,4*(j-1)+1)=2;                
            elseif (IT(i,4*(j-1)+1)==7)
                P2(i,4*(j-1)+1)=3; 
            else
                P2(i,4*(j-1)+1)=4;
            end
        elseif ((bitget(img(i,j),8)==1)&&(bitget(img(i,j),7)==0))
            if (IT(i,4*(j-1)+1)==1)
                P2(i,4*(j-1)+1)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                P2(i,4*(j-1)+1)=3;
            elseif (IT(i,4*(j-1)+1)==3)
                P2(i,4*(j-1)+1)=2;
            elseif (IT(i,4*(j-1)+1)==4)
                P2(i,4*(j-1)+1)=2;                
            elseif (IT(i,4*(j-1)+1)==5)
                P2(i,4*(j-1)+1)=1;               
            elseif (IT(i,4*(j-1)+1)==6)
                P2(i,4*(j-1)+1)=1;                
            elseif (IT(i,4*(j-1)+1)==7)
                P2(i,4*(j-1)+1)=4; 
            else
                P2(i,4*(j-1)+1)=3;
            end            
        else
            if (IT(i,4*(j-1)+1)==1)
                P2(i,4*(j-1)+1)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                P2(i,4*(j-1)+1)=2;
            elseif (IT(i,4*(j-1)+1)==3)
                P2(i,4*(j-1)+1)=4;
            elseif (IT(i,4*(j-1)+1)==4)
                P2(i,4*(j-1)+1)=3;                
            elseif (IT(i,4*(j-1)+1)==5)
                P2(i,4*(j-1)+1)=4;               
            elseif (IT(i,4*(j-1)+1)==6)
                P2(i,4*(j-1)+1)=3;                
            elseif (IT(i,4*(j-1)+1)==7)
                P2(i,4*(j-1)+1)=1; 
            else
                P2(i,4*(j-1)+1)=1;
            end
        end
        if ((bitget(img(i,j),6)==0)&&(bitget(img(i,j),5)==0))
            if (IT(i,4*(j-1)+2)==1)
                P2(i,4*(j-1)+2)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                P2(i,4*(j-1)+2)=1;
            elseif (IT(i,4*(j-1)+2)==3)
                P2(i,4*(j-1)+2)=3;
            elseif (IT(i,4*(j-1)+2)==4)
                P2(i,4*(j-1)+2)=4;                
            elseif (IT(i,4*(j-1)+2)==5)
                P2(i,4*(j-1)+2)=3;               
            elseif (IT(i,4*(j-1)+2)==6)
                P2(i,4*(j-1)+2)=4;                
            elseif (IT(i,4*(j-1)+2)==7)
                P2(i,4*(j-1)+2)=2; 
            else
                P2(i,4*(j-1)+2)=2;
            end
        elseif ((bitget(img(i,j),6)==0)&&(bitget(img(i,j),5)==1))
            if (IT(i,4*(j-1)+2)==1)
                P2(i,4*(j-1)+2)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                P2(i,4*(j-1)+2)=4;
            elseif (IT(i,4*(j-1)+2)==3)
                P2(i,4*(j-1)+2)=1;
            elseif (IT(i,4*(j-1)+2)==4)
                P2(i,4*(j-1)+2)=1;                
            elseif (IT(i,4*(j-1)+2)==5)
                P2(i,4*(j-1)+2)=2;               
            elseif (IT(i,4*(j-1)+2)==6)
                P2(i,4*(j-1)+2)=2;                
            elseif (IT(i,4*(j-1)+2)==7)
                P2(i,4*(j-1)+2)=3; 
            else
                P2(i,4*(j-1)+2)=4;
            end
        elseif ((bitget(img(i,j),6)==1)&&(bitget(img(i,j),5)==0))
            if (IT(i,4*(j-1)+2)==1)
                P2(i,4*(j-1)+2)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                P2(i,4*(j-1)+2)=3;
            elseif (IT(i,4*(j-1)+2)==3)
                P2(i,4*(j-1)+2)=2;
            elseif (IT(i,4*(j-1)+2)==4)
                P2(i,4*(j-1)+2)=2;                
            elseif (IT(i,4*(j-1)+2)==5)
                P2(i,4*(j-1)+2)=1;               
            elseif (IT(i,4*(j-1)+2)==6)
                P2(i,4*(j-1)+2)=1;                
            elseif (IT(i,4*(j-1)+2)==7)
                P2(i,4*(j-1)+2)=4; 
            else
                P2(i,4*(j-1)+2)=3;
            end            
        else
            if (IT(i,4*(j-1)+2)==1)
                P2(i,4*(j-1)+2)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                P2(i,4*(j-1)+2)=2;
            elseif (IT(i,4*(j-1)+2)==3)
                P2(i,4*(j-1)+2)=4;
            elseif (IT(i,4*(j-1)+2)==4)
                P2(i,4*(j-1)+2)=3;                
            elseif (IT(i,4*(j-1)+2)==5)
                P2(i,4*(j-1)+2)=4;               
            elseif (IT(i,4*(j-1)+2)==6)
                P2(i,4*(j-1)+2)=3;                
            elseif (IT(i,4*(j-1)+2)==7)
                P2(i,4*(j-1)+2)=1; 
            else
                P2(i,4*(j-1)+2)=1;
            end
        end 
        if ((bitget(img(i,j),4)==0)&&(bitget(img(i,j),3)==0))
            if (IT(i,4*(j-1)+3)==1)
                P2(i,4*(j-1)+3)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                P2(i,4*(j-1)+3)=1;
            elseif (IT(i,4*(j-1)+3)==3)
                P2(i,4*(j-1)+3)=3;
            elseif (IT(i,4*(j-1)+3)==4)
                P2(i,4*(j-1)+3)=4;                
            elseif (IT(i,4*(j-1)+3)==5)
                P2(i,4*(j-1)+3)=3;               
            elseif (IT(i,4*(j-1)+3)==6)
                P2(i,4*(j-1)+3)=4;                
            elseif (IT(i,4*(j-1)+3)==7)
                P2(i,4*(j-1)+3)=2; 
            else
                P2(i,4*(j-1)+3)=2;
            end
        elseif ((bitget(img(i,j),4)==0)&&(bitget(img(i,j),3)==1))
            if (IT(i,4*(j-1)+3)==1)
                P2(i,4*(j-1)+3)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                P2(i,4*(j-1)+3)=4;
            elseif (IT(i,4*(j-1)+3)==3)
                P2(i,4*(j-1)+3)=1;
            elseif (IT(i,4*(j-1)+3)==4)
                P2(i,4*(j-1)+3)=1;                
            elseif (IT(i,4*(j-1)+3)==5)
                P2(i,4*(j-1)+3)=2;               
            elseif (IT(i,4*(j-1)+3)==6)
                P2(i,4*(j-1)+3)=2;                
            elseif (IT(i,4*(j-1)+3)==7)
                P2(i,4*(j-1)+3)=3; 
            else
                P2(i,4*(j-1)+3)=4;
            end
        elseif ((bitget(img(i,j),4)==1)&&(bitget(img(i,j),3)==0))
            if (IT(i,4*(j-1)+3)==1)
                P2(i,4*(j-1)+3)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                P2(i,4*(j-1)+3)=3;
            elseif (IT(i,4*(j-1)+3)==3)
                P2(i,4*(j-1)+3)=2;
            elseif (IT(i,4*(j-1)+3)==4)
                P2(i,4*(j-1)+3)=2;                
            elseif (IT(i,4*(j-1)+3)==5)
                P2(i,4*(j-1)+3)=1;               
            elseif (IT(i,4*(j-1)+3)==6)
                P2(i,4*(j-1)+3)=1;                
            elseif (IT(i,4*(j-1)+3)==7)
                P2(i,4*(j-1)+3)=4; 
            else
                P2(i,4*(j-1)+3)=3;
            end            
        else
            if (IT(i,4*(j-1)+3)==1)
                P2(i,4*(j-1)+3)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                P2(i,4*(j-1)+3)=2;
            elseif (IT(i,4*(j-1)+3)==3)
                P2(i,4*(j-1)+3)=4;
            elseif (IT(i,4*(j-1)+3)==4)
                P2(i,4*(j-1)+3)=3;                
            elseif (IT(i,4*(j-1)+3)==5)
                P2(i,4*(j-1)+3)=4;               
            elseif (IT(i,4*(j-1)+3)==6)
                P2(i,4*(j-1)+3)=3;                
            elseif (IT(i,4*(j-1)+3)==7)
                P2(i,4*(j-1)+3)=1; 
            else
                P2(i,4*(j-1)+3)=1;
            end
        end 
        if ((bitget(img(i,j),2)==0)&&(bitget(img(i,j),1)==0))
            if (IT(i,4*(j-1)+4)==1)
                P2(i,4*(j-1)+4)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                P2(i,4*(j-1)+4)=1;
            elseif (IT(i,4*(j-1)+4)==3)
                P2(i,4*(j-1)+4)=3;
            elseif (IT(i,4*(j-1)+4)==4)
                P2(i,4*(j-1)+4)=4;                
            elseif (IT(i,4*(j-1)+4)==5)
                P2(i,4*(j-1)+4)=3;               
            elseif (IT(i,4*(j-1)+4)==6)
                P2(i,4*(j-1)+4)=4;                
            elseif (IT(i,4*(j-1)+4)==7)
                P2(i,4*(j-1)+4)=2; 
            else
                P2(i,4*(j-1)+4)=2;
            end
        elseif ((bitget(img(i,j),2)==0)&&(bitget(img(i,j),1)==1))
            if (IT(i,4*(j-1)+4)==1)
                P2(i,4*(j-1)+4)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                P2(i,4*(j-1)+4)=4;
            elseif (IT(i,4*(j-1)+4)==3)
                P2(i,4*(j-1)+4)=1;
            elseif (IT(i,4*(j-1)+4)==4)
                P2(i,4*(j-1)+4)=1;                
            elseif (IT(i,4*(j-1)+4)==5)
                P2(i,4*(j-1)+4)=2;               
            elseif (IT(i,4*(j-1)+4)==6)
                P2(i,4*(j-1)+4)=2;                
            elseif (IT(i,4*(j-1)+4)==7)
                P2(i,4*(j-1)+4)=3; 
            else
                P2(i,4*(j-1)+4)=4;
            end
        elseif ((bitget(img(i,j),2)==1)&&(bitget(img(i,j),1)==0))
            if (IT(i,4*(j-1)+4)==1)
                P2(i,4*(j-1)+4)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                P2(i,4*(j-1)+4)=3;
            elseif (IT(i,4*(j-1)+4)==3)
                P2(i,4*(j-1)+4)=2;
            elseif (IT(i,4*(j-1)+4)==4)
                P2(i,4*(j-1)+4)=2;                
            elseif (IT(i,4*(j-1)+4)==5)
                P2(i,4*(j-1)+4)=1;               
            elseif (IT(i,4*(j-1)+4)==6)
                P2(i,4*(j-1)+4)=1;                
            elseif (IT(i,4*(j-1)+4)==7)
                P2(i,4*(j-1)+4)=4; 
            else
                P2(i,4*(j-1)+4)=3;
            end            
        else
            if (IT(i,4*(j-1)+4)==1)
                P2(i,4*(j-1)+4)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                P2(i,4*(j-1)+4)=2;
            elseif (IT(i,4*(j-1)+4)==3)
                P2(i,4*(j-1)+4)=4;
            elseif (IT(i,4*(j-1)+4)==4)
                P2(i,4*(j-1)+4)=3;                
            elseif (IT(i,4*(j-1)+4)==5)
                P2(i,4*(j-1)+4)=4;               
            elseif (IT(i,4*(j-1)+4)==6)
                P2(i,4*(j-1)+4)=3;                
            elseif (IT(i,4*(j-1)+4)==7)
                P2(i,4*(j-1)+4)=1; 
            else
                P2(i,4*(j-1)+4)=1;
            end
        end
    end
end
%disp(P2);
%disp(size(P2));
%disp(size(X));
%disp(size(Y));
XP=zeros(size(X));
YP=zeros(size(Y));
%disp(size(XP));
%disp(size(YP));
for i=1:maxHW
    XP(i)=mod(floor(X(i)*10^14),4*w);
    YP(i)=mod(floor(Y(i)*10^14),h);
end
%disp(XP);
%disp(YP);
P4=P2;
for i=1:h
    if (mod(i,2)~=0)
        P4(i,:)=circshift(P2(i,:),[0,-XP(i)]);
    else
        P4(i,:)=circshift(P2(i,:),[0,XP(i)]);
    end
end
for j=1:4*w
    if (mod(j,2)~=0)
        P4(:,j)=circshift(P2(:,j),[-YP(j),0]);
    else
        P4(:,j)=circshift(P2(:,j),[YP(j),0]);
    end
end
%disp(P4);
beforeZ1=afterParam(6);
beforeZ2=afterParam(7);
for i=1:1001
    beforeZ1=2*atan(cot(afterParam(4)*beforeZ1))/pi;
    beforeZ2=2*atan(cot(afterParam(5)*beforeZ2))/pi;
end
%disp(beforeZ1);
%disp(beforeZ2);
Z1=zeros(1,4*h*w);
Z2=zeros(1,4*h*w);
U=zeros(1,4*h*w);
Z1(1)=beforeZ1;
Z2(1)=beforeZ2;
for i=1:4*h*w-1
    Z1(i+1)=2*atan(cot(afterParam(4)*Z1(i)))/pi;
    Z2(i+1)=2*atan(cot(afterParam(5)*Z2(i)))/pi;
end
for i=1:4*h*w
    U(i)=(Z1(i)+Z2(i))/(1+Z1(i)*Z2(i));
end
%disp(U);
%disp(max(U)); 
%disp(min(U));
Q=zeros(1,4*h*w);
for i=1:4*h*w
    if ((U(i)>=-1)&&(U(i)<=-0.5))
        %A1,T2,C3,G4
        Q(i)=1;
    elseif ((U(i)>-0.5)&&(U(i)<=0))
        Q(i)=2;
    elseif ((U(i)>0)&&(U(i)<=0.5))
        Q(i)=3;
    else
        Q(i)=4;
    end
end
%disp(Q);
KK=reshape(Q,h,4*w);
%disp(KK);
%disp(DNAxor(4,3));
C=zeros(h,4*w);
for i=1:h
    for j=1:4*w
        if ((i==1)&&(j==1))
            C(i,j)=DNAxor(P4(i,j),KK(i,j));
        elseif ((i~=1)&&(j==1))
            C(i,j)=DNAxor(DNAxor(P4(i,j),KK(i,j)),C(i-1,4*w));
        else
            C(i,j)=DNAxor(DNAxor(P4(i,j),KK(i,j)),C(i,j-1));
        end
    end
end
%disp(C);
img2=img;
%disp(size(img2));
for i=1:h
    for j=1:4*w
        if (C(i,j)==1)
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            else
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            end
        elseif (C(i,j)==2)
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            else
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            end            
        elseif (C(i,j)==3)
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            else
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            end            
        else
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,1);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,0);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,1);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,0);
                end
            else
                if (mod(j,4)==1)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),8,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),6,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),4,0);
                    img2(i,floor(j/4)+1)=bitset(img2(i,floor(j/4)+1),3,1);
                else
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),2,0);
                    img2(i,floor(j/4))=bitset(img2(i,floor(j/4)),1,1);
                end
            end            
        end
    end
end
figure;
imshow(img2);
figure;
imhist(img);
figure;
imhist(img2);


reC=zeros(h,4*w);
for i=1:h
    for j=1:w
        if ((bitget(img2(i,j),8)==0)&&(bitget(img2(i,j),7)==0))
            if (IT(i,4*(j-1)+1)==1)
                reC(i,4*(j-1)+1)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                reC(i,4*(j-1)+1)=1;
            elseif (IT(i,4*(j-1)+1)==3)
                reC(i,4*(j-1)+1)=3;
            elseif (IT(i,4*(j-1)+1)==4)
                reC(i,4*(j-1)+1)=4;                
            elseif (IT(i,4*(j-1)+1)==5)
                reC(i,4*(j-1)+1)=3;               
            elseif (IT(i,4*(j-1)+1)==6)
                reC(i,4*(j-1)+1)=4;                
            elseif (IT(i,4*(j-1)+1)==7)
                reC(i,4*(j-1)+1)=2; 
            else
                reC(i,4*(j-1)+1)=2;
            end
        elseif ((bitget(img2(i,j),8)==0)&&(bitget(img2(i,j),7)==1))
            if (IT(i,4*(j-1)+1)==1)
                reC(i,4*(j-1)+1)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                reC(i,4*(j-1)+1)=4;
            elseif (IT(i,4*(j-1)+1)==3)
                reC(i,4*(j-1)+1)=1;
            elseif (IT(i,4*(j-1)+1)==4)
                reC(i,4*(j-1)+1)=1;                
            elseif (IT(i,4*(j-1)+1)==5)
                reC(i,4*(j-1)+1)=2;               
            elseif (IT(i,4*(j-1)+1)==6)
                reC(i,4*(j-1)+1)=2;                
            elseif (IT(i,4*(j-1)+1)==7)
                reC(i,4*(j-1)+1)=3; 
            else
                reC(i,4*(j-1)+1)=4;
            end
        elseif ((bitget(img2(i,j),8)==1)&&(bitget(img2(i,j),7)==0))
            if (IT(i,4*(j-1)+1)==1)
                reC(i,4*(j-1)+1)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                reC(i,4*(j-1)+1)=3;
            elseif (IT(i,4*(j-1)+1)==3)
                reC(i,4*(j-1)+1)=2;
            elseif (IT(i,4*(j-1)+1)==4)
                reC(i,4*(j-1)+1)=2;                
            elseif (IT(i,4*(j-1)+1)==5)
                reC(i,4*(j-1)+1)=1;               
            elseif (IT(i,4*(j-1)+1)==6)
                reC(i,4*(j-1)+1)=1;                
            elseif (IT(i,4*(j-1)+1)==7)
                reC(i,4*(j-1)+1)=4; 
            else
                reC(i,4*(j-1)+1)=3;
            end            
        else
            if (IT(i,4*(j-1)+1)==1)
                reC(i,4*(j-1)+1)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+1)==2)
                reC(i,4*(j-1)+1)=2;
            elseif (IT(i,4*(j-1)+1)==3)
                reC(i,4*(j-1)+1)=4;
            elseif (IT(i,4*(j-1)+1)==4)
                reC(i,4*(j-1)+1)=3;                
            elseif (IT(i,4*(j-1)+1)==5)
                reC(i,4*(j-1)+1)=4;               
            elseif (IT(i,4*(j-1)+1)==6)
                reC(i,4*(j-1)+1)=3;                
            elseif (IT(i,4*(j-1)+1)==7)
                reC(i,4*(j-1)+1)=1; 
            else
                reC(i,4*(j-1)+1)=1;
            end
        end
        if ((bitget(img2(i,j),6)==0)&&(bitget(img2(i,j),5)==0))
            if (IT(i,4*(j-1)+2)==1)
                reC(i,4*(j-1)+2)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                reC(i,4*(j-1)+2)=1;
            elseif (IT(i,4*(j-1)+2)==3)
                reC(i,4*(j-1)+2)=3;
            elseif (IT(i,4*(j-1)+2)==4)
                reC(i,4*(j-1)+2)=4;                
            elseif (IT(i,4*(j-1)+2)==5)
                reC(i,4*(j-1)+2)=3;               
            elseif (IT(i,4*(j-1)+2)==6)
                reC(i,4*(j-1)+2)=4;                
            elseif (IT(i,4*(j-1)+2)==7)
                reC(i,4*(j-1)+2)=2; 
            else
                reC(i,4*(j-1)+2)=2;
            end
        elseif ((bitget(img2(i,j),6)==0)&&(bitget(img2(i,j),5)==1))
            if (IT(i,4*(j-1)+2)==1)
                reC(i,4*(j-1)+2)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                reC(i,4*(j-1)+2)=4;
            elseif (IT(i,4*(j-1)+2)==3)
                reC(i,4*(j-1)+2)=1;
            elseif (IT(i,4*(j-1)+2)==4)
                reC(i,4*(j-1)+2)=1;                
            elseif (IT(i,4*(j-1)+2)==5)
                reC(i,4*(j-1)+2)=2;               
            elseif (IT(i,4*(j-1)+2)==6)
                reC(i,4*(j-1)+2)=2;                
            elseif (IT(i,4*(j-1)+2)==7)
                reC(i,4*(j-1)+2)=3; 
            else
                reC(i,4*(j-1)+2)=4;
            end
        elseif ((bitget(img2(i,j),6)==1)&&(bitget(img2(i,j),5)==0))
            if (IT(i,4*(j-1)+2)==1)
                reC(i,4*(j-1)+2)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                reC(i,4*(j-1)+2)=3;
            elseif (IT(i,4*(j-1)+2)==3)
                reC(i,4*(j-1)+2)=2;
            elseif (IT(i,4*(j-1)+2)==4)
                reC(i,4*(j-1)+2)=2;                
            elseif (IT(i,4*(j-1)+2)==5)
                reC(i,4*(j-1)+2)=1;               
            elseif (IT(i,4*(j-1)+2)==6)
                reC(i,4*(j-1)+2)=1;                
            elseif (IT(i,4*(j-1)+2)==7)
                reC(i,4*(j-1)+2)=4; 
            else
                reC(i,4*(j-1)+2)=3;
            end            
        else
            if (IT(i,4*(j-1)+2)==1)
                reC(i,4*(j-1)+2)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+2)==2)
                reC(i,4*(j-1)+2)=2;
            elseif (IT(i,4*(j-1)+2)==3)
                reC(i,4*(j-1)+2)=4;
            elseif (IT(i,4*(j-1)+2)==4)
                reC(i,4*(j-1)+2)=3;                
            elseif (IT(i,4*(j-1)+2)==5)
                reC(i,4*(j-1)+2)=4;               
            elseif (IT(i,4*(j-1)+2)==6)
                reC(i,4*(j-1)+2)=3;                
            elseif (IT(i,4*(j-1)+2)==7)
                reC(i,4*(j-1)+2)=1; 
            else
                reC(i,4*(j-1)+2)=1;
            end
        end 
        if ((bitget(img2(i,j),4)==0)&&(bitget(img2(i,j),3)==0))
            if (IT(i,4*(j-1)+3)==1)
                reC(i,4*(j-1)+3)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                reC(i,4*(j-1)+3)=1;
            elseif (IT(i,4*(j-1)+3)==3)
                reC(i,4*(j-1)+3)=3;
            elseif (IT(i,4*(j-1)+3)==4)
                reC(i,4*(j-1)+3)=4;                
            elseif (IT(i,4*(j-1)+3)==5)
                reC(i,4*(j-1)+3)=3;               
            elseif (IT(i,4*(j-1)+3)==6)
                reC(i,4*(j-1)+3)=4;                
            elseif (IT(i,4*(j-1)+3)==7)
                reC(i,4*(j-1)+3)=2; 
            else
                reC(i,4*(j-1)+3)=2;
            end
        elseif ((bitget(img2(i,j),4)==0)&&(bitget(img2(i,j),3)==1))
            if (IT(i,4*(j-1)+3)==1)
                reC(i,4*(j-1)+3)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                reC(i,4*(j-1)+3)=4;
            elseif (IT(i,4*(j-1)+3)==3)
                reC(i,4*(j-1)+3)=1;
            elseif (IT(i,4*(j-1)+3)==4)
                reC(i,4*(j-1)+3)=1;                
            elseif (IT(i,4*(j-1)+3)==5)
                reC(i,4*(j-1)+3)=2;               
            elseif (IT(i,4*(j-1)+3)==6)
                reC(i,4*(j-1)+3)=2;                
            elseif (IT(i,4*(j-1)+3)==7)
                reC(i,4*(j-1)+3)=3; 
            else
                reC(i,4*(j-1)+3)=4;
            end
        elseif ((bitget(img2(i,j),4)==1)&&(bitget(img2(i,j),3)==0))
            if (IT(i,4*(j-1)+3)==1)
                reC(i,4*(j-1)+3)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                reC(i,4*(j-1)+3)=3;
            elseif (IT(i,4*(j-1)+3)==3)
                reC(i,4*(j-1)+3)=2;
            elseif (IT(i,4*(j-1)+3)==4)
                reC(i,4*(j-1)+3)=2;                
            elseif (IT(i,4*(j-1)+3)==5)
                reC(i,4*(j-1)+3)=1;               
            elseif (IT(i,4*(j-1)+3)==6)
                reC(i,4*(j-1)+3)=1;                
            elseif (IT(i,4*(j-1)+3)==7)
                reC(i,4*(j-1)+3)=4; 
            else
                reC(i,4*(j-1)+3)=3;
            end            
        else
            if (IT(i,4*(j-1)+3)==1)
                reC(i,4*(j-1)+3)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+3)==2)
                reC(i,4*(j-1)+3)=2;
            elseif (IT(i,4*(j-1)+3)==3)
                reC(i,4*(j-1)+3)=4;
            elseif (IT(i,4*(j-1)+3)==4)
                reC(i,4*(j-1)+3)=3;                
            elseif (IT(i,4*(j-1)+3)==5)
                reC(i,4*(j-1)+3)=4;               
            elseif (IT(i,4*(j-1)+3)==6)
                reC(i,4*(j-1)+3)=3;                
            elseif (IT(i,4*(j-1)+3)==7)
                reC(i,4*(j-1)+3)=1; 
            else
                reC(i,4*(j-1)+3)=1;
            end
        end 
        if ((bitget(img2(i,j),2)==0)&&(bitget(img2(i,j),1)==0))
            if (IT(i,4*(j-1)+4)==1)
                reC(i,4*(j-1)+4)=1;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                reC(i,4*(j-1)+4)=1;
            elseif (IT(i,4*(j-1)+4)==3)
                reC(i,4*(j-1)+4)=3;
            elseif (IT(i,4*(j-1)+4)==4)
                reC(i,4*(j-1)+4)=4;                
            elseif (IT(i,4*(j-1)+4)==5)
                reC(i,4*(j-1)+4)=3;               
            elseif (IT(i,4*(j-1)+4)==6)
                reC(i,4*(j-1)+4)=4;                
            elseif (IT(i,4*(j-1)+4)==7)
                reC(i,4*(j-1)+4)=2; 
            else
                reC(i,4*(j-1)+4)=2;
            end
        elseif ((bitget(img2(i,j),2)==0)&&(bitget(img2(i,j),1)==1))
            if (IT(i,4*(j-1)+4)==1)
                reC(i,4*(j-1)+4)=3;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                reC(i,4*(j-1)+4)=4;
            elseif (IT(i,4*(j-1)+4)==3)
                reC(i,4*(j-1)+4)=1;
            elseif (IT(i,4*(j-1)+4)==4)
                reC(i,4*(j-1)+4)=1;                
            elseif (IT(i,4*(j-1)+4)==5)
                reC(i,4*(j-1)+4)=2;               
            elseif (IT(i,4*(j-1)+4)==6)
                reC(i,4*(j-1)+4)=2;                
            elseif (IT(i,4*(j-1)+4)==7)
                reC(i,4*(j-1)+4)=3; 
            else
                reC(i,4*(j-1)+4)=4;
            end
        elseif ((bitget(img2(i,j),2)==1)&&(bitget(img2(i,j),1)==0))
            if (IT(i,4*(j-1)+4)==1)
                reC(i,4*(j-1)+4)=4;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                reC(i,4*(j-1)+4)=3;
            elseif (IT(i,4*(j-1)+4)==3)
                reC(i,4*(j-1)+4)=2;
            elseif (IT(i,4*(j-1)+4)==4)
                reC(i,4*(j-1)+4)=2;                
            elseif (IT(i,4*(j-1)+4)==5)
                reC(i,4*(j-1)+4)=1;               
            elseif (IT(i,4*(j-1)+4)==6)
                reC(i,4*(j-1)+4)=1;                
            elseif (IT(i,4*(j-1)+4)==7)
                reC(i,4*(j-1)+4)=4; 
            else
                reC(i,4*(j-1)+4)=3;
            end            
        else
            if (IT(i,4*(j-1)+4)==1)
                reC(i,4*(j-1)+4)=2;
                %A1,T2,C3,G4
            elseif (IT(i,4*(j-1)+4)==2)
                reC(i,4*(j-1)+4)=2;
            elseif (IT(i,4*(j-1)+4)==3)
                reC(i,4*(j-1)+4)=4;
            elseif (IT(i,4*(j-1)+4)==4)
                reC(i,4*(j-1)+4)=3;                
            elseif (IT(i,4*(j-1)+4)==5)
                reC(i,4*(j-1)+4)=4;               
            elseif (IT(i,4*(j-1)+4)==6)
                reC(i,4*(j-1)+4)=3;                
            elseif (IT(i,4*(j-1)+4)==7)
                reC(i,4*(j-1)+4)=1; 
            else
                reC(i,4*(j-1)+4)=1;
            end
        end
    end
end 
%disp(reC(66,66));
%disp(C(66,66));
reP4=zeros(h,4*w);
for i=1:h
    for j=1:4*w
        if ((i==1)&&(j==1))
            reP4(i,j)=DNAxor(reC(i,j),KK(i,j));
        elseif ((i~=1)&&(j==1))
            reP4(i,j)=DNAxor(DNAxor(reC(i,j),KK(i,j)),reC(i-1,4*w));
        else
            reP4(i,j)=DNAxor(DNAxor(reC(i,j),KK(i,j)),reC(i,j-1));
        end
    end
end
%disp(reP4(6,6));
%disp(P4(6,6));
reP2=reP4;
for i=1:h
    if (mod(i,2)~=0)
        reP2(i,:)=circshift(reP4(i,:),[0,XP(i)]);
    else
        reP2(i,:)=circshift(reP4(i,:),[0,-XP(i)]);
    end
end
for j=1:4*w
    if (mod(j,2)~=0)
        reP2(:,j)=circshift(reP4(:,j),[YP(j),0]);
    else
        reP2(:,j)=circshift(reP4(:,j),[-YP(j),0]);
    end
end
%disp(reP2(233,33));
%disp(P2(233,33));
img3=img2;
%disp(size(img3));
for i=1:h
    for j=1:4*w
        if (reP2(i,j)==1)
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            else
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            end
        elseif (reP2(i,j)==2)
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            else
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            end            
        elseif (reP2(i,j)==3)
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            else
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            end            
        else
            if (IT(i,j)==1)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==2)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==3)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==4)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==5)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            elseif (IT(i,j)==6)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            elseif (IT(i,j)==7)
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,0);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,0);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,1);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,0);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,1);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,0);
                end
            else
                if (mod(j,4)==1)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),8,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),7,1);
                elseif (mod(j,4)==2)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),6,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),5,1);
                elseif (mod(j,4)==3)
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),4,0);
                    img3(i,floor(j/4)+1)=bitset(img3(i,floor(j/4)+1),3,1);
                else
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),2,0);
                    img3(i,floor(j/4))=bitset(img3(i,floor(j/4)),1,1);
                end
            end            
        end
    end
end
figure;
imshow(img3);
figure;
imhist(img3);