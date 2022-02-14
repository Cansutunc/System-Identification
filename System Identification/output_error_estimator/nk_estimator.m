function [nk]=nk_estimator(nk_max,ide_data,val_data)
    i=0; %Counter
    sim1=zeros(1,nk_max); %Size of data holder adjusted
    sim2=zeros(1,nk_max); %Size of data holder adjusted
     
    for nk=1:nk_max %System Identification done for all nk values.
        i=i+1;
        sys_arx=oe(ide_data,[2,2,nk]);
        [~,sim1(i),~]=compare(sys_arx,ide_data); %Fit for identification data calculated and hold on sim1 variable.
        [~,sim2(i),~]=compare(sys_arx,val_data); %Fit for validation data calculated and hold on sim2 variable.
    end
    
    [~,b]=max(sim1); %Max. Fit Point Found for identification data
    [~,d]=max(sim2); %Max. Fit Point Found for validation data
    if sim1(b)-sim1(b+1)>=0 && sim2(b)-sim2(b+1)>=0 && sim1(d)-sim1(d+1)>=0 && sim2(d)-sim2(d+1)>=0
        %If both validation and identification fits are decreasing after found two max. points, to avoid
        %complexty, the small value from b or d is selected.
        if b-d<=0
            nk=b;
        elseif d-b<0
            nk=d;
        end
    elseif sim1(d)-sim1(d+1)>=0 && sim2(d)-sim2(d+1)>=0
        %If validation and identification fits are decreasing after found max. point d, nk selected as d.
        nk=d;
    elseif sim1(b)-sim1(b+1)>=0 && sim2(b)-sim2(b+1)>=0 
        %If validation and identification fits are decreasing after found max. point b, nk selected as b.
        nk=b;
    end
end