clear all
clc
close all

syms Iz
syms phi theta psi

disp('-----------------')
disp('3-2-1 Rotation Matrix')
R_frdi_frd = math_euler2dcm(phi, theta, psi, 321)

disp('-----------------')
disp('1-2-3 Rotation Matrix')
R_frdi_frd = math_euler2dcm(phi, theta, psi, 123)
   
disp('-----------------')
disp('Hrot = sum{ R_frd_frdi * Jrot * [0; 0; wi] }')

phi_arr = [-phi, +phi, +phi, -phi, +phi, -phi, -phi, +phi]; % inward cannted rotors
syms w1 w2 w3 w4 w5 w6 w7 w8
w_arr = [w1, w2, w3, w4, w5, w6, w7, w8];
nrotors = length(w_arr);
Hrot_frd = [0; 0; 0];
for i = 1:nrotors
    phi_i = phi_arr(i);
    theta_i = theta;
    psi_i = psi;
    wi = w_arr(i);
    
    R_frdi_frd = math_euler2dcm(phi_i, theta_i, psi_i, 123);  
    R_frd_frdi = transpose(R_frdi_frd);
    Hrot_frd = Hrot_frd + R_frd_frdi*[0; 0; Iz*wi];
end
% Hrot_frd = vpa(Hrot_frd, 4)
Hrot_frd = simplify(Hrot_frd)
% Hrot_frd =
%          Iz*sin(theta)*(w1 + w2 + w3 + w4 + w5 + w6 + w7 + w8) => sum{ wi }
% Iz*cos(theta)*sin(phi)*(w1 - w2 - w3 + w4 - w5 + w6 + w7 - w8) => sum{ -sign{phi} * wi }
% Iz*cos(phi)*cos(theta)*(w1 + w2 + w3 + w4 + w5 + w6 + w7 + w8) => sum{ wi }

disp('-----------------')
disp('Specific case: theta = 0; w1 = -1; w2 = +1; w3 = -1; w4 = +1;')
theta = 0; 
w1 = -1; w2 = +1; w3 = -1; w4 = +1; w5 = -1; w6 = +1; w7 = -1; w8 = +1;

% (w1 + w2 + w3 + w4) => +(-1) +(+1) +(-1) +(+1) = 0
% (w1 - w2 - w3 + w4) => +(-1) -(+1) -(-1) +(+1) = 0
% (w1 + w2 + w3 + w4) => +(-1) +(+1) +(-1) +(+1) = 0
Hrot_frd = vpa(subs(Hrot_frd), 4)


return

% test
phi = deg2rad(30);
theta = deg2rad(30);
psi = deg2rad(30);
syms phi theta psi

dcm = math_euler2dcm(phi, theta, psi)  
[r1 r2 r3] = dcm2angle(dcm,'ZYX');
rad2deg([r1 r2 r3])
[r1 r2 r3] = dcm2angle(dcm,'XYZ');
rad2deg([r1 r2 r3])

