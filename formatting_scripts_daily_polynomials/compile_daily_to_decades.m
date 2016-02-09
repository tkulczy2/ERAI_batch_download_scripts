cd '/mnt/norgay/Datasets/Climate/ERA_Interim/Matlab_1deg_x_1deg';
mkdir decadal
mkdir decadal/PRECIP
mkdir decadal/TAVG
mkdir decadal/TMAX
mkdir decadal/TMIN

for v = {'precip', 'tavg', 'tmax', 'tmin'}
var = char(v);
VAR = upper(var);

for base_y = 1980:10:2010
if base_y == 1980
start_y = 1979;
else
start_y = base_y;
end
if base_y == 2010
end_y = 2015;
else
end_y = base_y + 9;
end
command = ['load annual/' VAR '/ERAI_DAILY_' VAR '_' num2str(start_y) '.mat'];
eval(command)
command = [var '_' num2str(base_y) ' = ' var ';'];
eval(command)
command = [var '_' num2str(base_y) '.year = year(' var '.T);'];
eval(command)
command = [var '_' num2str(base_y) '.month = month(' var '.T);'];
eval(command)
command = [var '_' num2str(base_y) '.day_of_month = day(' var '.T);'];
eval(command)
command = [var '_' num2str(base_y) '.day_of_year = datenum(' var '.T) - datenum(year(' var '.T),1,1) + 1;'];
eval(command)
for y = base_y:end_y
command = ['load annual/' VAR '/ERAI_DAILY_' VAR '_' num2str(y) '.mat'];
eval(command)
command = [var '_' num2str(base_y) '.' var ' = cat(3, ' var '_' num2str(base_y) '.' var ', ' var '.' var ');'];
eval(command)
command = [var '_' num2str(base_y) '.year = cat(1, ' var '_' num2str(base_y) '.year, year(' var '.T));'];
eval(command)
command = [var '_' num2str(base_y) '.month = cat(1, ' var '_' num2str(base_y) '.month, month(' var '.T));'];
eval(command)
command = [var '_' num2str(base_y) '.day_of_month = cat(1, ' var '_' num2str(base_y) '.day_of_month, day(' var '.T));'];
eval(command)
command = [var '_' num2str(base_y) '.day_of_year = cat(1, ' var '_' num2str(base_y) '.day_of_year, datenum(' var '.T) - datenum(year(' var '.T),1,1) + 1);'];
eval(command)
disp(strcat('Done with year ',num2str(y)))
end
command = ['clear ' var ' command;'];
eval(command)
command = ['save decadal/' VAR '/ERAI_DAILY_' VAR '_' num2str(base_y) '.mat;'];
eval(command)

command = ['clear ' var '_' num2str(base_y)];
eval(command)
disp('')
disp(strcat('Done with decade ',num2str(base_y)))
disp('')
end

disp('')
disp(strcat('Done with variable ',var))
disp('')
end
