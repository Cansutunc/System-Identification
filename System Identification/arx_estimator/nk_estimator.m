function [nk]=nk_estimator(nk_max,ide_data,val_data)
    i=0;
    sim1=zeros(1,nk_max);
    sim2=zeros(1,nk_max); 
    for nk=1:nk_max
        i=i+1;
        sys_arx=arx(ide_data,[2,2,nk]);
        [~,sim1(i),~]=compare(sys_arx,ide_data); %Güncel validation fit değeri alındı.(sim)
        [~,sim2(i),~]=compare(sys_arx,val_data); %Güncel validation fit değeri alındı.(sim)
    end
    [~,b]=max(sim1);
    [~,d]=max(sim2);
    if sim1(b)-sim1(b+1)>=0 && sim2(b)-sim2(b+1)>=0 
        nk=b;
    elseif sim1(d)-sim1(d+1)>=0 && sim2(d)-sim2(d+1)>=0
        nk=d;
    elseif sim1(b)-sim1(b+1)>=0 && sim2(b)-sim2(b+1)>=0 && sim1(d)-sim1(d+1)>=0 && sim2(d)-sim2(d+1)>=0
        if b-d<=0
            nk=b;
        elseif d-b<0
            nk=d;
        end
    end
end