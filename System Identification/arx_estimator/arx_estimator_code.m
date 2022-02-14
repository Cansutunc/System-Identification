clc; clear; close;

nk_max=10;
na_max=24; 
nb_max=15;
sens1=10^-2;
sens2=10^-2;

%Load validation and estimation data
load data data;

ide_data=data(1:696);
val_data=data(697:end);
ide_data=detrend(ide_data);
val_data=detrend(val_data);
all_data=detrend(data);

[nk]=nk_estimator(nk_max,ide_data,val_data);

sim1=zeros(1,na_max*nb_max);
sim2=zeros(1,na_max*nb_max);
k=0;
s1=1;
for i=1:na_max
    for j=1:nb_max
        k=k+1;
        sys_arx=arx(ide_data,[i,j,nk]);
        [~,sim1(k),~]=compare(sys_arx,ide_data); %Güncel validation fit değeri alındı.(sim)
        [~,sim2(k),~]=compare(sys_arx,val_data); %Güncel validation fit değeri alındı.(sim)
        if k>=2
            val1=abs(sim1(k)-sim1(k-1));
            val2=abs(sim2(k)-sim2(k-1));
            if val1<=sens1 && val2<=sens2
                na=i;
                nb=j;
                s1=0;
                break;
            end
        end
    end
    if s1==0
        break;
    end
end
sys_arx=arx(ide_data,[na,nb,nk]);
compare(sys_arx,val_data);