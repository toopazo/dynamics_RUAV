function qr = math_quatnorm(q)    
    qnorm = sqrt( q(1)^2 + q(2)^2 + q(3)^2 + q(4)^2 );
    qr = qnorm;
end
