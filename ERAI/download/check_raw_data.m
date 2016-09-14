diary('output_check_raw.txt');
clc;
files = dir('*.nc');

for fInfo = files'
    f = deblank(fInfo.name);
    ncid = netcdf.open(f);
    disp(f)
    %time = netcdf.getVar(ncid, 2);
    %res = any(time(:)==0);
    %disp(['Time missing: ' num2str(res)])
    for varid = 3:5
        raw = netcdf.getVar(ncid, varid);
        [varname,] = netcdf.inqVar(ncid, varid);
        data = ncread(f, varname);
        mv = netcdf.getAtt(ncid, varid, 'missing_value');
        res = sum(raw(:)==mv);
        disp(['Var ' num2str(varid) ' # missing (raw): ' num2str(res)])
        zv = -32766;
        res = sum(raw(:)==zv);
        disp(['Var ' num2str(varid) ' # zeros (raw): ' num2str(res)])
        tv = 0.;
        res = sum(data(:)<tv);
        disp(['Var ' num2str(varid) ' < zero (trans): ' num2str(res)])
        res = sum(data(:)==tv);
        disp(['Var ' num2str(varid) ' # zero (trans): ' num2str(res)])
        res = min(data(:));
        disp(['Var ' num2str(varid) ' min (trans): ' num2str(res)])
    end
    netcdf.close(ncid);
    disp('')
end

diary('off');
