function [x] = Filter1Initialization(row, col)
epsilon=sqrt(6)/(sqrt(row+col));
x=rand(row,col)*(2*epsilon)-epsilon;
end