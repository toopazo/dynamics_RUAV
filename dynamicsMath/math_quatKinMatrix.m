function quatKinMatrix = math_quatKinMatrix(w_frd_bcm_ned)
    P = w_frd_bcm_ned(1);
    Q = w_frd_bcm_ned(2);
    R = w_frd_bcm_ned(3);
    quatKinMatrix = [...
        [ 0, -P, -Q, -R]   ; ...
        [ P,  0,  R, -Q]   ; ...
        [ Q, -R,  0,  P]   ; ...
        [ R,  Q, -P,  0]     ...
        ];
end