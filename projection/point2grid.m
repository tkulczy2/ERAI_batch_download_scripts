function [P] = point2grid(x,y,Xs,Ys)

%
%
%SOLOMON HSIANG, JAN 2009
%smh2137@columbia.edu
%-------------------------------
%
%POINT2GRID(x, y, Xs, Ys) is a function that projects the point at 'x, y'
%into a grid defined by the two vectors 'Xs, Ys'. x and y are locations in
%the space defined by the grid described in Xs and Ys.  Xs and Ys are Mx1
%and Nx1 (or transpose, it doesn't matter) and describe the positions of
%grid-cell centers in a grid they define (they are the axes). POINT2GRID
%finds the cell into which (x,y) fits the best and returns a 2x2 matrix.
%The first two entries (the top row) are the grid-cell numbers of the cell
%into which (x,y) falls {i.e. the index of Xs and Ys to which that cell 
%coresponds}. The second two entries (the bottom row) are the coordinates
%of that grid cell in the space defined by Xs and Ys {i.e. the entries of
%Xs and Ys that correspond to the returned indices}.
%
%Note that POINT2GRID only returns the values for a single grid cell. If a
%point falls on the boundary of two cells, it is placed in the cell with
%the lower index.


minx = abs(Xs - x);
miny = abs(Ys - y);

newx = find(minx == min(minx),1);
newy = find(miny == min(miny),1);

P = [newx, newy; Xs(newx), Ys(newy)];
