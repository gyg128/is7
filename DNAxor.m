function [ out ] = DNAxor( in1,in2 )
if (in1==1)
    if (in2==1)
        out=1;
    elseif (in2==2)
        out=2;
    elseif (in2==3)
        out=3;
    else
        out=4;
    end
elseif (in1==2)
    if (in2==1)
        out=2;
    elseif (in2==2)
        out=1;
    elseif (in2==3)
        out=4;
    else
        out=3;
    end
elseif (in1==3)
    if (in2==1)
        out=3;
    elseif (in2==2)
        out=4;
    elseif (in2==3)
        out=1;
    else
        out=2;
    end
else
    if (in2==1)
        out=4;
    elseif (in2==2)
        out=3;
    elseif (in2==3)
        out=2;
    else
        out=1;
    end
end

