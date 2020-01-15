function S = f1(b,n)
%f1 Find First Set
%   input= number, output [p v]= [position value]
    bn=bitcmp(b,32);
    v=bitand(bn+1,b);
    pa=[0 1 28 2 29 14 24 3 30 22 20 15 25 17 4 8 31 27 13 23 21 19 16 7 26 12 18 6 11 5 10 9];
    p=v*hex2dec('077CB531');
    p=bitand(p,hex2dec('0FFFFFFFF'));
    S=pa(bitshift(p,-27)+1);
    if(b==0) 
        S=n-1;
    end
end

