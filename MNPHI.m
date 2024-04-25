clc
clearvars
prompt= [" Enter the width of the section in mm"," Enter the depth of the section in mm","Enter the grade of concrete in Mpa","Enter the effective cover in mm"];
title = 'Cross sectional properties';
numlines = [1 75;1 75;1 75;1 75];
definput = {'300','300','30','40'};
dimension=inputdlg(prompt,title,numlines,definput);
b=str2double(dimension{1});
D=str2double(dimension{2});
fck=str2double(dimension{3});
d_dash=str2double(dimension{4});
prompt= [" Enter the grade of steel in Mpa"," Enter the diameter of bars in mm"," Enter the number of bars"," Enter the modulus of elasticity of steel  in Mpa"];
title = 'Reinforcement details';
numlines = [1 75;1 75;1 75;1 75];
definput = {'415','20','4','200000'};
dimension=inputdlg(prompt,title,numlines,definput);
fy=str2double(dimension{1});
dai=str2double(dimension{2});
nb=str2double(dimension{3});
Es=str2double(dimension{4});
Ec=5000*sqrt(fck);
Ast=nb*(pi/4)*(dai^2);
n=2;
p_i=Ast*100/(2*b*D);
k_dash=(0.0035*(D-d_dash))/(0.0035+(0.87*fy/Es));
set(1,6)=0;
set(1,5)=0.45+(0.00004*Es*p_i/fck);
set(1,7)=0;
for k=4:-0.05:1
    set(n,1)= k;
    g= 0.446*fck*((4/((7*k)-3))^2);
    set(n,2)= 0.446*fck*D*(1-((4/21)*(4/(7*k-3))^2));
    set(n,3)= 0.446*fck*((D)^2)/2-((8/49)*g*(D^2));
    set(n,4)=set(n,3)/set(n,2);
    xu=k*D;
    e_sc1=0.002*(xu-d_dash)/(xu-(3*D/7));
    fsc1=e_sc1*Es;
    fc1= 0.446*fck;
    e_sc2=0.002*(xu-D+d_dash)/(xu-(3*D/7));
    fsc2=e_sc2*Es;
    fc2=(-49*g/(16*(D^2)))*(d_dash^2)+(7*g/(2*D))*d_dash+(0.45*fck-g);
    set(n,5)=(set(n,2)/(fck*D))+(p_i/(100*fck))*(fsc1-fc1)+(p_i/(100*fck))*(fsc2-fc2);
    set(n,6)=(set(n,2)/(fck*D))*(0.5-(set(n,4)/D))+(p_i/(fck*100))*(fsc1-fc1)*(((D/2)-d_dash)/D)-(p_i/(fck*100))*(fsc2-fc2)*(((D/2)-d_dash)/D);
    set(n,7)=0.002/(xu-(3*D/7));
    n=n+1;
end
for k =0.95:-0.05:0
    xu=k*D;
    if xu>(D-d_dash)
        e_sc1=0.0035*(xu-d_dash)/(xu);
        fsc1=e_sc1*Es;
        fc1= e_sc1*Ec;
        e_sc2=0.0035*(xu-D+d_dash)/(xu);
        fsc2=e_sc2*Es;
        fc2=0;
        set(n,5)=(0.36*k)+(p_i/(100*fck))*(fsc1-fc1+fsc2);
        set(n,6)=(0.36*k*(0.5-(0.416*k)))+(p_i/(100*fck))*(fsc1-fc1)*(((D/2)-d_dash)/D)+(p_i/(100*fck))*(fsc2-fc2)*((D/2)-d_dash)/D;
        set(n,7)=0.0035/xu;
    elseif xu<=(D-d_dash)&&xu>k_dash
            e_sc1=0.0035*(xu-d_dash)/(xu);
            fsc1=e_sc1*Es;
            fc1= e_sc1*Ec;
            e_sc2=0.0035*(-xu+D-d_dash)/(xu);
            fsc2=e_sc2*Es;
            fc2=0;
            set(n,5)=(0.36*k)+(p_i/(100*fck))*(fsc1-fc1)+(p_i/(100*fck))*(-fsc2-fc2);
            set(n,6)=(0.36*k*(0.5-(0.416*k)))+(p_i/(100*fck))*(fsc1-fc1)*(((D/2)-d_dash)/D)+(p_i/(100*fck))*(-fsc2-fc2)*(((D/2)-d_dash)/D);
            set(n,7)=0.0035/xu;
    else
        break;
    end
   
    n=n+1;
end
plot(set(:,6),set(:,5))
xlabel('Mu/fckbd^2')
ylabel('Pu/fckbd')
figure()
plot3(set(:,5),set(:,7),set(:,6))
xlabel('Pu/fckbd')
ylabel('curvature(Phi)')
zlabel('Mu/fckbd^2')


