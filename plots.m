clear
Phi=0:0.0001:0.0035;
fck=30;
Compression_force=zeros(1,36);
    for i=1:size(Phi,2)
        Compression_force(i)=stress_Concrete(Phi(i),fck);
    end
fy=415;
alp=500;
Es=2e5;
steel=0:0.0001:0.02
Steel_force=zeros(1,36);
    for i=1:size(steel,2)
        Steel_force(i)=stress_steel(steel(i),Es,fy,alp);
    end
plot(steel,Steel_force);
xlabel("Strain");
ylabel("Stress");
title("Steell Stress strain curve");
figure()
plot(Phi,Compression_force)
xlabel("Strain");
ylabel("Stress");
title("Concrete Stress strain curve");

function stress_Concrete=stress_Concrete(Strain,Fck)
    if  Strain <=0
        stress_Concrete=0;
    elseif Strain < 0.002
        stress_Concrete=-111750*Fck*Strain^2 + 447*Fck*Strain;
    elseif (Strain <= 0.0035)
        stress_Concrete=0.447*Fck;
    end
end

function stress_steel=stress_steel(strain,Es,fy,alp)
    if strain <=0
        stress_steel=0;
    elseif (strain <= fy/Es) 
        stress_steel=strain*Es;
    elseif (strain >= fy/Es)
        stress_steel=-alp*strain+alp*fy/Es +fy
    end
end