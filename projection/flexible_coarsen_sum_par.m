function [Q] = flexible_coarsen_sum_par(FIELD, old_x, old_y, new_x, new_y)

%
% S. Hsiang
% 10.09
% -----------------------
%
% FLEXIBLE_COARSEN_SUM_PAR(FIELD, OLD_X, OLD_Y, NEW_X, NEW_Y) coarsens the
% resolution of FIELD from the space defined by vectors OLD_X and OLD_Y
% (with have relatively long length) and projects them into a coarser field
% described by NEW_X and NEW_Y. Coarsening is achieved by simple summing
% of pixels that have centers in side the newly defined pixels. OLD_X and
% OLD_y must have the same number of elements as the horizontal and
% vertical edges of FIELD, respectively.
%
% Note that old pixels are uniquely assigned to new pixels. This means that
% old pixels are never "split" even if they fall across the boundary of two
% new pixels.  However, the integrated value over a field will be
% preserved.
%
% Warning: if the edges of the new field is a strict subspace of the old
% field, pixels in the periphery of the the old field will be assigned to
% the edge pixels of the new field (they are the closest in euclidian
% distance). Cropping of the old field may be necessary to prevent large
% errors in some cases.
%
% NEW_X and NEW_Y may have any arbitrary (monotonic values), but note that
% old pixels are assigned to pixels in the new space according to their
% euclidian distance from the new pixel centers.  So if the inteneded edges
% of pixels are not the midpoint of two adjacent pixel centers, this
% approximation may produce some errors.
%
% Warning: no adjustments for averaging NaNs is taken.
%
% This approximates the reverse function of REGRID() and is a more flexible
% version of COARSEN()
%
% FLEXIBLE_COARSEN_SUM_PAR differs from FLEXIBLE_COARSEN_PAR because it
% sums the values in the original field, rather than averaging them. This
% is probably preferable when the field describes conserved variables.
%
% FLEXIBLE_COARSEN calls POINT2GRID
%
% -------------------------------------
% NOTE: THIS CODE HAS BEEN PARELLELIZED
% -------------------------------------
%
% (it is ~3x faster with 4 cores, ~6x faster with 8)
%
% see also flexible_coarsen, flexible_coarsen_par, flexible_coarsen_sum


%check if running in parellel
check_matlabpool;



s = size(FIELD);

if s(2) ~= length(old_x) || s(1) ~= length(old_y)
    disp('SOL: OLD_X and OLD_Y must explain the horizontal and vertical node structure of FIELD')
    disp('(check that they are the same lengths)')
    Q = false;
    return
end

coord_x = nan(1,length(old_x)); %stores the new X position for each pixel
coord_y = nan(length(old_y),1); %new y

%finding the index of old positions in the new space

for i = 1:length(old_x)
    coord_temp = point2grid(old_x(i), old_y(1), new_x, new_y);
    coord_x(i) = coord_temp(1,1);
end

for i = 1:length(old_y)
    coord_temp = point2grid(old_x(1), old_y(i), new_x, new_y);
    coord_y(i) = coord_temp(1,2);
end


new_FIELD = nan(length(new_y), length(new_x));

block = new_FIELD(1,:); % just a row vector to duplicate

%----------------------------
% PARALLELIZED SECTION BEGINS

parfor i = 1:length(new_y)
    
    temp_row_vector = block;
    
    for j = 1:length(new_x)
        
        temp_row_vector(j) = nansum(nansum(FIELD((coord_y==i),(coord_x==j)),1),2);
        %THE ABOVE COMMAND IS ABOUT 20% FASTER THAN THE OLD COMMAND BELOW:
        %temp_row_vector(j) =
        %mean(mean(FIELD(find(coord_y==i,1,'first'):find(coord_y==i,1,'last'),find(coord_x==j,1,'first'):find(coord_x==j,1,'last')),1),2);
        
    end
    
    new_FIELD(i,:) = temp_row_vector;
    
end

% PARALLELIZED SECTION ENDS
%----------------------------

Q = new_FIELD;

return