function [x] = Filter3DInitialization(row, col, depth)
epsilon=sqrt(9)/(sqrt(row+col+depth));
x=rand(row,col,depth)*(3*epsilon)-epsilon;
end
