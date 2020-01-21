% This funcion reduce the order of a continuous system by removing dipoles
% and poles far from imaginary axis
% NOTICE: ReduceOrder before adding damper to model

function PlantC_RO=ReduceOrder(PlantC)
% Output zero-pole-gain model
        
P=pole(PlantC);
[Z,K]=zero(PlantC);

[tempP,Index]=sort(real(P));
P=P(Index);
[tempZ,Index]=sort(real(Z));
Z=Z(Index);
PN=length(P);
ZN=length(Z);

% open-loop gain <- root gain
% K=K*prod(abs(Z))/prod(abs(P));
K=K*exp(sum(log(abs(Z)))-sum(log(abs(P)))); %anti-overflow

% mark dipole
DelFlag=-999;
for i=1:PN
    dis=abs(max(P));    %min distant
    tempIndex=0;
    for j=1:ZN
        if abs(P(i)-Z(j))<min(abs(real(P(i))),abs(real(Z(j))))/10 && abs(P(i)-Z(j))<dis %dipole threshold
            tempIndex=j;
            dis=abs(P(i)-Z(j)); %update min distant
        end
    end
    if tempIndex
        P(i)=DelFlag;           %mark pole
        Z(tempIndex)=DelFlag;   %mark zero
    end
end

% remove dipole & poles/zeros far from imaginary axis
tempP=[];
tempZ=[];
for i=1:PN
    if real(P(i))>-20   %distant form imginary axis threshold
        tempP=[tempP;P(i)];
    end
end
for i=1:ZN
    if real(Z(i))>-20   %distant form imginary axis threshold
        tempZ=[tempZ;Z(i)];
    end
end
P=tempP;
Z=tempZ;

% root gain <- open-loop gain  
K=K/prod(abs(Z))*prod(abs(P));

PlantC_RO=zpk(Z,P,K);