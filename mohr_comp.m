%% Mohr Truss compatibility model
prompt= ["Enter stress in longitudnal direction"; "enter stress in transverse direction"; "Enter Shear stress";"Enter the value of modulus of elasticity of concrete" ];
title = 'stresses in l-t direction';
numlines = [1 120;1 120;1 120;1 120];
definput = {'2.13','-2.13','3.69','24800'};
dimension=inputdlg(prompt,title,numlines,definput);
sigmal=str2double(dimension{1});
sigmat=str2double(dimension{2});
tault=str2double(dimension{3});
Ec=str2double(dimension{4});

prompt= ["Enter yielding stress of reinforcement in l direction";"Enter yielding stress of reinforcement in t direction";"Enter the thickness of concrete element";"Enter the value of modulus of elasticity of steel"];
title = 'stresses in l-t direction';
numlines = [1 120;1 120;1 120;1 120];
definput = {'413','413','305','200000'};
dimension=inputdlg(prompt,title,numlines,definput);
fly=str2double(dimension{1});
fty=str2double(dimension{2});
t=str2double(dimension{3});
Es=str2double(dimension{4});


% solution of problem
alpha1=acotd((sigmal-sigmat)/(2*tault))*0.5;
sigma_1=((sigmal+sigmat)/2)+((sigmal-sigmat)^2+tault^2)^0.5;
sigma_2=((sigmal+sigmat)/2)-((sigmal-sigmat)^2+tault^2)^0.5;
alpha_r=acotd((sigmal-sigmat)/(2*tault))*0.5;
rho_l=(sigmal+tault*tand(alpha_r))/fty;
rho_t=(sigmat+tault*cotd(alpha_r))/fty;
a_ls_req=rho_l*t;
a_ts_req=rho_t*t;

% Smeared stresses calculations
sigma1s=rho_l*fly;
sigma2s=rho_t*fty;
sigmallt=sigmal-sigma1s;
sigma22t=sigmat-sigma2s;
sigmad=2*(-tault)/(sind(2*alpha_r));


%strain calculation
e_d= sigmad/Ec;
e_l=fly/Es;
e_t=fty/Es;


%plotting mohr circle
Radius=(sigma_1-sigma_2)/2;
x=(sigma_1+sigma_2)/2;
center=[x 0];
figure()
sirkl(center,Radius,'Normal stress (Mpa)--->','Shear stress (Mpa)',[0 -2 0],[-2 1 0]);


sigma_r=0;
new_r=-sigmad/2;
new_x=[sigmad/2 0];
figure()
sirkl(new_x,new_r,'<--Normal stress (Mpa)','Shear stress (Mpa)',[-2 4 0],[0 0 0]);

epsilon_l=(sigmal+tault*tand(alpha_r))/(rho_l*Es);                                                        % strain in l and t direction
epsilon_t=(sigmat+tault*tand(alpha_r))/(rho_t*Es);   

Stresses=[table(sigma_1),table(sigma_2),table(sigmad)];
fig_2 = uifigure('Position',[400 450 1150 350]);
uit2 = uitable(fig_2,"Data",Stresses);
uit2.Position = [10 10 1130 320];

Strains=[table(e_d),table(e_l),table(e_t)];
fig_2 = uifigure('Position',[20 60 760 350]);
uit2 = uitable(fig_2,"Data",Strains);
uit2.Position = [10 10 720 320];

function H=sirkl(center,radius,xlabel_,ylabel_,t,tt)
rad=2*radius;
n_coor=center-[radius radius];
H=rectangle ('position', [n_coor, rad, rad], 'curvature', [1, 1]);
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
xlabel(xlabel_)
xlab = get(gca,'xlabel');
pos = get(xlab,'position');
set(xlab,'position',pos + t)
ylabel(ylabel_)
ylab = get(gca,'ylabel');
pos = get(ylab,'position');
set(ylab,'position',pos + tt)
daspect([1 1 1]);
end

