function plot_all_months(T, param)

if strcmp(param,'t2m')
    step = 6;
    x = 0:step:24;
    label = 'Temp. (K)';
else
    step = 3;
    x = 3:step:24;
    if strcmp(param,'tp')
        label = 'Precip. (m)';
    else
        label = 'Temp. (K)';
    end
end

ymin = min(T.data);
ymax = max(T.data);

i = 0;
for m = 1:12
    subplot(3,4,m);
    for d = unique(T.days(T.months==m))'
        ix = find(T.months==m & T.days==d);
        if strcmp(param,'t2m')
            if ix(end)+1<=length(T.data)
                ix = [ix; ix(end)+1];
            else
                x = x(1:end-1);
            end
        end
        y = squeeze(T.data(ix));
        plot(x,y)
        ylim([ymin ymax])
        xlim([0 24])
        if i==0
            hold on;
        end
    end
    title(datestr(strcat(num2str(m),'-1-2014'),'mmm'))
    xlabel('Hour')
    ylabel(label)
    set(gca,'XTick',0:6:24)
    grid on
    grid minor
end