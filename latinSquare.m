function out = latinSquare(numCond)

%This function returns a latin square (n x n array).
%This function is called with the syntax latinSquare(n).

global out;
out = zeros(numCond);

firstCol = 0;
firstRow = 0;

for row = 1:numCond
   offset = row-1;
   for col = 1:numCond
      if row == 1
         if col == 1
            element = 1;
         else
            element = shiftUp(out(row,col-1),shiftOffset(col,numCond),numCond);
         end
      else
         element = upOne(row-1,col,numCond);
      end
      out(row, col) = element;
   end
end


function shift = shiftOffset(col,numCond)
n = col-1;
if mod(col,2) == 1
   shift = n;
else
   shift = numCond - n;
end


function upOut = upOne(r,c,numCond)
global out;
val = out(r,c);
if val >= numCond
   upOut = 1;
else
   upOut = val + 1;
end


function shiftedUp = shiftUp(start, shiftMag, numCond)
for i = 1:shiftMag
   if start + 1 > numCond
      start = 1;
   else
      start = start + 1;
   end
end
shiftedUp = start;