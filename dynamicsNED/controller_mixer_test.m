clear all 
clc 
close all
format compact
format short

syms Pdot_cmd Qdot_cmd Rdot_cmd az_cmd
vcmd = [Pdot_cmd; Qdot_cmd; Rdot_cmd; az_cmd];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M4 = [...
        [ -0.707107,  0.707107,  1.000000,  -1.000000 ]; ...     % rotor1
        [  0.707107,  0.707107, -1.000000,  -1.000000 ]; ...     % rotor2
        [  0.707107, -0.707107,  1.000000,  -1.000000 ]; ...     % rotor3
        [ -0.707107, -0.707107, -1.000000,  -1.000000 ]  ...     % rotor4
];

M8 = [...
        ...% R rate,    P rate,    Y rate,     accel_d
        [ -0.707107,  0.707107,  1.000000,  -1.000000 ]; ...     % rotor1
        [  0.707107,  0.707107, -1.000000,  -1.000000 ]; ...     % rotor2
        [  0.707107, -0.707107,  1.000000,  -1.000000 ]; ...     % rotor3
        [ -0.707107, -0.707107, -1.000000,  -1.000000 ]; ...     % rotor4
        [  0.707107,  0.707107,  1.000000,  -1.000000 ]; ...     % rotor5
        [ -0.707107,  0.707107, -1.000000,  -1.000000 ]; ...     % rotor6
        [ -0.707107, -0.707107,  1.000000,  -1.000000 ]; ...     % rotor7
        [  0.707107, -0.707107, -1.000000,  -1.000000 ]; ...     % rotor8
    ];

delta4 = M4*vcmd
delta8 = M8*vcmd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms d
% d = 1;
r1 = d/sqrt(2)*[+1; +1; +0];    r6 = d/sqrt(2)*[+1; +1; -0];
r2 = d/sqrt(2)*[+1; -1; +0];    r5 = d/sqrt(2)*[+1; -1; -0];
r3 = d/sqrt(2)*[-1; -1; +0];    r8 = d/sqrt(2)*[-1; -1; -0];
r4 = d/sqrt(2)*[-1; +1; +0];    r7 = d/sqrt(2)*[-1; +1; -0];

% kT*w1^2 linearized at w0 => ct = kT*2*w0
syms cT w1 w2 w3 w4 w5 w6 w7 w8
T1 = cT*w1;  T6 = cT*w6;
T2 = cT*w2;  T5 = cT*w5;
T3 = cT*w3;  T8 = cT*w8;
T4 = cT*w4;  T7 = cT*w7;
% syms T1 T2 T3 T4 T5 T6 T7 T8

% kQ*w1^2 linearized at w0 => cQ = kQ*2*w0
syms cQ
Q1 = -cQ*w1;  Q6 = +cQ*w6;
Q2 = +cQ*w2;  Q5 = -cQ*w5;
Q3 = -cQ*w3;  Q8 = +cQ*w8;
Q4 = +cQ*w4;  Q7 = -cQ*w7;
% syms Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fz4     = T1 + T2 + T3 + T4;
Qnet4   = Q1 + Q2 + Q3 + Q4;
Mnet4   = cross(r1, [0;0;-T1]) + cross(r2, [0;0;-T2]) + ...
            cross(r3, [0;0;-T3]) + cross(r4, [0;0;-T4]) + ...
            [0; 0; -Qnet4];
Mnet4   = eval(Mnet4);
v4      = [Mnet4; -Fz4]

% (2^(1/2)*cT*d*w2)/2 - (2^(1/2)*cT*d*w1)/2 + (2^(1/2)*cT*d*w3)/2 - (2^(1/2)*cT*d*w4)/2
% (2^(1/2)*cT*d*w1)/2 + (2^(1/2)*cT*d*w2)/2 - (2^(1/2)*cT*d*w3)/2 - (2^(1/2)*cT*d*w4)/2
%                                                         cQ*w2 - cQ*w1 - cQ*w3 + cQ*w4
%                                                         cT*w1 + cT*w2 + cT*w3 + cT*w4
c0 = 2^(1/2)/2*cT*d;
Mca4 = [...
    c0*[-1, +1, +1, -1] ; ...
    c0*[+1, +1, -1, -1] ; ...
    cQ*[+1, -1, +1, -1] ; ...
    cT*[-1, -1, -1, -1]   ...
];
check = v4 - Mca4*[w1; w2; w3; w4];
if norm(check) > 10^-4
    disp('norm(check) > 10^-4')
    asd = asd
end

Fz8     = T1 + T2 + T3 + T4 + T5 + T6 + T7 + T8;
Qnet8   = Q1 + Q2 + Q3 + Q4 + Q5 + Q6 + Q7 + Q8;
Mnet8   = cross(r1, [0;0;-T1]) + cross(r2, [0;0;-T2]) + ...
            cross(r3, [0;0;-T3]) + cross(r4, [0;0;-T4]) + ...
            cross(r5, [0;0;-T5]) + cross(r6, [0;0;-T6]) + ...
            cross(r7, [0;0;-T7]) + cross(r8, [0;0;-T8]) + ...
            [0; 0; -Qnet8];
Mnet8   = eval(Mnet8);
v8      = [Mnet8; -Fz8]

c0 = 2^(1/2)/2*cT*d;
Mca8 = [...
    c0*[-1, +1, +1, -1, +1, -1, -1, +1] ; ...
    c0*[+1, +1, -1, -1, +1, +1, -1, -1] ; ...
    cQ*[+1, -1, +1, -1, +1, -1, +1, -1] ; ...
    cT*[-1, -1, -1, -1, -1, -1, -1, -1]   ...
];
check = v8 - Mca8*[w1; w2; w3; w4;  w5; w6; w7; w8];
if norm(check) > 10^-4
    disp('norm(check) > 10^-4')
    asd = asd
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d  = 1;
c0 = 1;
cQ = 1;
cT = 1;
Mca4 = vpa(subs(Mca4), 5)
Mca8 = vpa(subs(Mca8), 5)

%    Mca4 = 
%    [ -0.7071, 0.7071,  0.7071, -0.7071]
%    [  0.7071, 0.7071, -0.7071, -0.7071]
%    [     1.0,   -1.0,     1.0,    -1.0]
%    [     1.0,    1.0,     1.0,     1.0]

%    Mca8 = 
%    [ -0.7071, 0.7071,  0.7071, -0.7071, 0.7071, -0.7071, -0.7071,  0.7071]
%    [  0.7071, 0.7071, -0.7071, -0.7071, 0.7071,  0.7071, -0.7071, -0.7071]
%    [     1.0,   -1.0,     1.0,    -1.0,    1.0,    -1.0,     1.0,    -1.0]
%    [     1.0,    1.0,     1.0,     1.0,    1.0,     1.0,     1.0,     1.0]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v4 = Mca4*[w1; w2; w3; w4]
% [w1; w2; w3; w4] = Mca4^(-1) * v4
% omega4 = vpa(Mca4^(-1), 4)
% omega4 = transpose(Mca4)

    % From build/nuttx_px4fmu-v4_default/src/lib/mixer/mixer_multirotor_normalized.generated.h
%    const MultirotorMixer::Rotor _config_octa_cox[] = {
%	    { -0.707107,  0.707107,  1.000000,  1.000000 },
%	    {  0.707107,  0.707107, -1.000000,  1.000000 },
%	    {  0.707107, -0.707107,  1.000000,  1.000000 },
%	    { -0.707107, -0.707107, -1.000000,  1.000000 },
%	    {  0.707107,  0.707107,  1.000000,  1.000000 },
%	    { -0.707107,  0.707107, -1.000000,  1.000000 },
%	    { -0.707107, -0.707107,  1.000000,  1.000000 },
%	    {  0.707107, -0.707107, -1.000000,  1.000000 },
%    };

check = M4 - transpose(Mca4);
if norm(check) > 10^-4
    disp('norm(check) > 10^-4')
    asd = asd
end

check = M8 - transpose(Mca8);
if norm(check) > 10^-4
    disp('norm(check) > 10^-4')
    asd = asd
end

M4 = vpa(pinv(Mca4), 5)     % Moore-Penrose Pseudoinverse
M8 = vpa(pinv(Mca8), 5)     % Moore-Penrose Pseudoinverse

