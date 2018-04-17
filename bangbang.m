function [ vL,vR ] = bangbang( err )

if err<-5
    vL=12;vR=0;
elseif err>5
    vL=0;vR=12;
else
    vL=12;vR=12;
end

end

