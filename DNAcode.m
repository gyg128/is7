function [ encode ] = DNAcode( left, right, method )

if (method == 1)
    if ((left==0)&&(right==0))
        encode = 0;
    elseif ((left==0)&&(right==1))
        encode = 2;
    elseif ((left==1)&&(right==0))
        encode = 1;
    else
        encode = 3;
    end
elseif (method == 2)
    if ((left==0)&&(right==0))
        encode = 0;
    elseif ((left==0)&&(right==1))
        encode = 1;
    elseif ((left==1)&&(right==0))
        encode = 2;
    else
        encode = 3;
    end
elseif (method == 3)
    if ((left==0)&&(right==0))
        encode = 2;
    elseif ((left==0)&&(right==1))
        encode = 0;
    elseif ((left==1)&&(right==0))
        encode = 3;
    else
        encode = 1;
    end
elseif (method == 4)
    if ((left==0)&&(right==0))
        encode = 1;
    elseif ((left==0)&&(right==1))
        encode = 0;
    elseif ((left==1)&&(right==0))
        encode = 3;
    else
        encode = 2;
    end
elseif (method == 5)
    if ((left==0)&&(right==0))
        encode = 2;
    elseif ((left==0)&&(right==1))
        encode = 3;
    elseif ((left==1)&&(right==0))
        encode = 0;
    else
        encode = 1;
    end
elseif (method == 6)
    if ((left==0)&&(right==0))
        encode = 1;
    elseif ((left==0)&&(right==1))
        encode = 3;
    elseif ((left==1)&&(right==0))
        encode = 0;
    else
        encode = 2;
    end
elseif (method == 7)
    if ((left==0)&&(right==0))
        encode = 3;
    elseif ((left==0)&&(right==1))
        encode = 2;
    elseif ((left==1)&&(right==0))
        encode = 1;
    else
        encode = 0;
    end
else
    if ((left==0)&&(right==0))
        encode = 3;
    elseif ((left==0)&&(right==1))
        encode = 1;
    elseif ((left==1)&&(right==0))
        encode = 2;
    else
        encode = 0;
    end
end
end
