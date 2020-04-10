function signi = firefly_rotor_spin_direction(roti)

    % Spinning and location of rotors (according to px4 naming)
    % up R2 cw  / down R5 ccw            up R1 ccw / down R6 cw
    % up R3 ccw / down R8 cw             up R4 cw  / down R7 ccw
    % even numers => cw  => thrust generated only if omegai is positive wrt frdi
    % odd  numers => ccw => thrust generated only if omegai is negative wrt frdi
    
    % even numbers 2, 4, 6, 8
    if mod(roti, 2) == 0
        % spin direction for thrust generation
        signi = +1.0;
    % odd numbers 1, 3, 5, 7
    else
        % spin direction for thrust generation
        signi = -1.0;
    end
end        

