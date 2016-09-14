function [Q] = monthify_stack(LAT, LON, TIME, STACK, START_YEAR)

%
%SOLOMON HSIANG, MAR 2009
%smh2137@columbia.edu
%-------------------------------
%
%MONTHIFY_STACK(LAT, LON, TIME, STACK, START_YEAR)
%
%MONTHIFY_STACK takes a stack of spatial fields observed daily and
%averages them annually and monthly, taking into account the number of days
%in each month and year.  It generates new stacks of averaged field
%variables
%
%TIME is a vector recording the day of each observation (layer in STACK)
%
%STACK is a 3D array, with dimensions LAT, LON and TIME.  The orientation
%of lat and lon do not matter (see STACKFIELD to generate such a stack).
%Each layer of STACK is a seperate observation of the field associated with
%a new day (indexed by TIME).
%
%START_YEAR is the first year recorded in STACK. MONTHIFY_STACK assumes
%that the first layer in STACK is the observation on *JANUARY 1* of
%START_YEAR.  MONTHIFY_STACK does not assume that STACK ends on a specific
%day, but it will truncate it to the last complete year and will not record
%any averages for partial years at the end of the record.
%
%LAT and LON are vectors describing the spatial extent of a single layer in
%STACK.  They are not used in computation, but are stored with the stack to
%keep track of which field is where in space.
%
%MONTHIFY_STACK calculates which observation was in which month and year by
%counting daily and keeping track of leap years in the Gregorian calander.
%Leap years are caluclated  using the algorithm in
%
%http://en.wikipedia.org/wiki/Leap_year#Algorithm
%
%See also monthify_stack_sum




disp('SOL: I`M ASSUMING THAT YOUR STACK BEGINS ON JAN 1 OF')
disp(START_YEAR)

total_years = floor(length(TIME)/365);%only average for whole years, skip last year if it is incomplete
S = size(STACK);
new_stack = nan(S(1),S(2),total_years,12);
annual_stack = nan(S(1),S(2),total_years);

years = [START_YEAR:START_YEAR + total_years - 1]';
leap = zeros(size(years)); %a vector that is 0 for nonleap years and 1 for leap years
for t = 1:length(leap);
    if mod(years(t),4) == 0;
        leap(t) = 1;
    end
    if mod(years(t),100)==0;
        leap(t) = 0;
    end
    if mod(years(t),400)==0;
        leap(t) = 1;
    end
end




%days_in_month =[31    28    31    30    31    30    31    31    30    31    30    31];


month = [   1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     1     1
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     2     2
     3     2
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     3     3
     4     3
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     4     4
     5     4
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     5     5
     6     5
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     6     6
     7     6
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     7     7
     8     7
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     8     8
     9     8
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
     9     9
    10     9
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    10    10
    11    10
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    11    11
    12    11
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
    12    12
   NaN    12];

t = 0;%index of TIME, most recent layer that has already been counted

for y = 1:length(years);
    
    if leap(y) == 0;
        cut = 365;
    else
        cut = 366;
    end
        
    if S(3) >=t+cut %only average for whole years, skip last year if it is incomplete
        
        annual_stack(:,:,y) = mean(STACK(:,:,t+1:t+cut),3);
        
        for m = 1:12;
            new_stack(:,:,y,m) = mean(STACK(:,:,t+find(month(:,leap(y)+1)==m)),3);
        end
        
        t = t+cut;
    end    
end

disp('SOL: final year that was included in new averaged stack was')
disp(floor(t/365)-1+START_YEAR)



Q = struct('monthly_field',new_stack,'annual_field',annual_stack,'lat', LAT,'lon', LON,'year', years,'month', [1:12]');
return


