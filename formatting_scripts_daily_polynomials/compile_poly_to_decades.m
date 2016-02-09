cd '/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_1deg_x_1deg_polynomials';
mkdir decadal
mkdir decadal/PRECIP
mkdir decadal/TAVG
mkdir decadal/TMAX
mkdir decadal/TMIN

%var = 'precip';
for v = {'precip', 'tavg', 'tmax', 'tmin'}
var = char(v);
VAR = upper(var);

for base_y = 1980:10:2010
if base_y == 1980
start_y = 1979;
else
start_y = base_y;
end
command = ['load annual/' VAR '/' var '_' num2str(start_y) '_raw_polynomials.mat'];
eval(command)
%filename = strcat('annual/',VAR,'/',var,'_',num2str(base_y-1),'_raw_polynomials.mat');
%load(filename);
for k = 1:8
command = [var '_' num2str(base_y) '_poly_' num2str(k) ' = ' var '_poly_' num2str(k) ';'];
eval(command)
end
for y = base_y:base_y+9
command = ['load annual/' VAR '/' var '_' num2str(y) '_raw_polynomials.mat'];
eval(command)
%filename = strcat('annual/',VAR,'/',var,'_',num2str(y),'_raw_polynomials.mat');
%load(filename);
for k = 1:8
command = [var '_' num2str(base_y) '_poly_' num2str(k) '.' var '_actual_poly = cat(3, ' var '_' num2str(base_y) '_poly_' num2str(k) '.' var '_actual_poly, ' var '_poly_' num2str(k) '.' var '_actual_poly);'];
eval(command)
command = [var '_' num2str(base_y) '_poly_' num2str(k) '.day_of_month = cat(1, ' var '_' num2str(base_y) '_poly_' num2str(k) '.day_of_month, ' var '_poly_' num2str(k) '.day_of_month);'];
eval(command)
command = [var '_' num2str(base_y) '_poly_' num2str(k) '.month = cat(1, ' var '_' num2str(base_y) '_poly_' num2str(k) '.month, ' var '_poly_' num2str(k) '.month);'];
eval(command)
command = [var '_' num2str(base_y) '_poly_' num2str(k) '.year = cat(1, ' var '_' num2str(base_y) '_poly_' num2str(k) '.year, ' var '_poly_' num2str(k) '.year);'];
eval(command)
command = [var '_' num2str(base_y) '_poly_' num2str(k) '.day_of_year = cat(1, ' var '_' num2str(base_y) '_poly_' num2str(k) '.day_of_year, ' var '_poly_' num2str(k) '.day_of_year);'];
eval(command)
end
disp(strcat('Done with year ',num2str(y)))
end
command = ['clear ' var '_poly* ' var ' day_of_month months years day_of_year lat lon filename command;'];
eval(command)
command = ['save decadal/' VAR '/' var '_' num2str(base_y) '_raw_polynomials.mat;'];
eval(command)

command = ['clear ' var '_' num2str(base_y) '_poly*'];
eval(command)
disp('')
disp(strcat('Done with year ',num2str(base_y)))
disp('')
end
