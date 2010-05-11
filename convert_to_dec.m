
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [ans]= convert_to_dec(ans)

ans2=not(ans);
bc4 = ans2(4:92);

% Check manu
% i = 1:42 -> 42 bits
for i=1:6
   if bc4(1+7*(i-1):7+7*(i-1)) == [0 0 0 1 1 0 1]
       bc5(i)=0;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 0 1 1 0 0 1];
       bc5(i)=1;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 0 1 0 0 1 1];
       bc5(i)=2;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 1 1 1 1 0 1];
       bc5(i)=3;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 1 0 0 0 1 1];
       bc5(i)=4;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 1 1 0 0 0 1];
       bc5(i)=5;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 1 0 1 1 1 1];        
       bc5(i)=6;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 1 1 1 0 1 1];
       bc5(i)=7;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 1 1 0 1 1 1];        
       bc5(i)=8;
   elseif bc4(1+7*(i-1):7+7*(i-1)) == [0 0 0 1 0 1 1];    
       bc5(i)=9;
   end
end

% Right hand side
%i=48:89 -> 35 bits
for i=7:12
   if bc4(48+7*(i-7):54+7*(i-7)) == [1 1 1 0 0 1 0]
       bc5(i)=0;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 1 0 0 1 1 0];
       bc5(i)=1;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 1 0 1 1 0 0];
       bc5(i)=2;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 0 0 0 0 1 0];
       bc5(i)=3;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 0 1 1 1 0 0];
       bc5(i)=4;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 0 0 1 1 1 0];
       bc5(i)=5;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 0 1 0 0 0 0];        
       bc5(i)=6;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 0 0 0 1 0 0];
       bc5(i)=7;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 0 0 1 0 0 0];        
       bc5(i)=8;
   elseif bc4(48+7*(i-7):54+7*(i-7)) == [1 1 1 0 1 0 0];    
       bc5(i)=9;
   end
end
%Check Sum
%Refer to theory
ODD = 3*(bc5(1) + bc5(3) + bc5(5) + bc5(7) + bc5(9) + bc5(11));
EVEN = bc5(2) + bc5(4) + bc5(6) + bc5(8) + bc5(10);
SUM = ODD + EVEN;
check = 0;
i = 0;
while (check == 0)
    i=i+1;
    if((i*10) > SUM)
       CS = (i*10) - SUM;
       if ( CS == bc5(12))
           check = 1;
       end
   
 end
end

%Output result only when check==1
if check==1
    ans=bc5;
else ans=bc5;
end