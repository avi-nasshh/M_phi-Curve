clear
prompt = {'Enter width of the section - ',...
    'Enter depth of section - ',...
    'Enter Clear Cover'...
    'Enter fy (Mpa) - ',...
    "Enter fck (Mpa) - ",...
    'Enter Area of tensile steel - '};
dlgtitle = 'Section Properties';
dims = [1,50];
definput = ['350', '500', "50","415", '25', '1500'];
input = inputdlg(prompt, dlgtitle, dims, definput);
b = str2double(input{1});
D = str2double(input{2});
cc=str2double(input{3});
fy = str2double(input{4});
fck = str2double(input{5});
Ast = str2double(input{6});
alp= 100;  %strain softening factor
Es = 2*10^5; % young modulus of steel
d=D-cc; 
i=1;
phi=0;
peak_strain=0;
xu_lim = 0.0035*d/(0.0055+0.87*fy/Es);
x=xu_lim;
while round(peak_strain,4) <0.0035
        x=fminsearch(@(x)opt2(x,phi,fck,b,d,Es,Ast,fy,D,alp),x);
    peak_strain=x*tan(phi);
    strains=round(x-D):0.1:x;
    n=1;
    Moment_concrete=0;
    for ii=1:1:size(strains,2)
        Moment_concrete=Moment_concrete+strains(n)*stress_Concrete(strains(n)*tan(phi),fck)*b*0.1;
        n=n+1;
    end
    n=1;
    Moment_steel=stress_steel((d-x)*tan(phi),Es,fy,alp)*Ast*(d-x);
        Mu = Moment_concrete + Moment_steel;
    M(i)=Mu;
    phi=phi+10^-7;
    i=i+1;
end
Phi=0:10^-7:phi;

plot(Phi(1:size(M,2)),M)
xlabel("Curvature");
ylabel("Moment");
title("Moment Curvature curve");

function opt2= opt2(x,phi,fck,b,d,Es,Ast,fy,D,alp)
    strain=(round(x-D):0.1:x)*tan(phi);
    Compression_force=0;
    n=1;
    for i=1:1:size(strain)
        Compression_force=Compression_force+stress_Concrete(strain(n),fck)*b*0.1;
        n=n+1;
    end
    %total compressive force
    %tension
    Tension_force = stress_steel((d-x)*tan(phi),Es,fy,alp)*Ast*(-1);
    opt2=abs(Compression_force + Tension_force);
end

function stress_Concrete=stress_Concrete(Strain,Fck)
    if  Strain <=0
        stress_Concrete=0;
    elseif Strain < 0.002
        stress_Concrete=-111750*Fck*Strain^2 + 447*Fck*Strain;
    elseif (Strain < 0.0035)
        stress_Concrete=0.447*Fck;
    end
end

function stress_steel=stress_steel(strain,Es,fy,alp)
    if strain <=0
        stress_steel=0;
    elseif (strain <= fy/Es) 
        stress_steel=strain*Es;
    elseif (strain >= fy/Es)
        stress_steel=-alp*strain+alp*0.87*fy/Es +0.87*fy;
    end
end