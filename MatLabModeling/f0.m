function Z = f0(b,n)
%f0 Find First Zero
%   input= number, output z= position
    bn=bitcmp(b,32);
    v=bitand(b+1,bn);
    pa=[0 1 28 2 29 14 24 3 30 22 20 15 25 17 4 8 31 27 13 23 21 19 16 7 26 12 18 6 11 5 10 9];
    p=v*hex2dec('077CB531');
    p=bitand(p,hex2dec('0FFFFFFFF'));
    Z=pa(bitshift(p,-27)+1);
    if(b==2^n-1) 
        Z=n-1;
    end
end

