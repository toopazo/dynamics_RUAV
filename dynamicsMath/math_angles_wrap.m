function err = math_angles_wrap(sp, val)
    dif1_0 = sp(1) - val(1);
    dif2_0 = sp(2) - val(2);
    dif3_0 = sp(3) - val(3);

    dif1_p = +2*pi + sp(1) - val(1);
    dif2_p = +2*pi + sp(2) - val(2);
    dif3_p = +2*pi + sp(3) - val(3);
    
    dif1_n = -2*pi + sp(1) - val(1);
    dif2_n = -2*pi + sp(2) - val(2);
    dif3_n = -2*pi + sp(3) - val(3);
    
    arr1 = [dif1_n dif1_0 dif1_p];
    arr2 = [dif2_n dif2_0 dif2_p];
    arr3 = [dif3_n dif3_0 dif3_p];
    
    [val, ind] = min( abs(arr1) );
    err1 = arr1(ind);
    [val, ind] = min( abs(arr2) );
    err2 = arr2(ind);
    [val, ind] = min( abs(arr3) );
    err3 = arr3(ind);
   
    err = [err1; err2; err3];
    %err = sp - val;
end
