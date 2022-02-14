clc; clear; close;
%-----Variables-----% (Can be adjust by user)
nk_max=10; %Max. Dealy Value for Delay Calculation
na_max=30; %Max. na Value for Parameter Calculation
nb_max=30; %Max. nb Value for Parameter Calculation
sens1=10^-2; %Sensitivity for Identification Data
sens2=10^-2; %Sensitivity for Validation Data
%-----Variables-----% (Can be adjust by user)
 
%-----Load validation and estimation data-----%
load data data;
ide_data=data(1:696);
val_data=data(697:end);
ide_data=detrend(ide_data);
val_data=detrend(val_data);
all_data=detrend(data);
%-----Load validation and estimation data-----%

[nk]=nk_estimator(nk_max,ide_data,val_data); %Delay Value Calculation

sim1=zeros(1,na_max*nb_max); %Size of data holder adjusted
sim2=zeros(1,na_max*nb_max); %Size of data holder adjusted

k=0; %Counter
s1=1; %Variable to stop for loop.
%--System Identification done for all na and nb values--%
for i=1:na_max
    for j=1:nb_max
        k=k+1;
        sys_oe=oe(ide_data,[i,j,nk]);
        [~,sim1(k),~]=compare(sys_oe,ide_data); %Fit for identification data calculated and hold on sim1 variable.
        [~,sim2(k),~]=compare(sys_oe,val_data); %Fit for validation data calculated and hold on sim2 variable.
        if k>=2
            val1=abs(sim1(k)-sim1(k-1)); %Difference between last identification fit and previous one calculated.
            val2=abs(sim2(k)-sim2(k-1)); %Difference between last validation fit and previous one calculated.
            if val1<=sens1 && val2<=sens2
                %If both differance are decreasing at the same time, smaller than adjusted
                %sensitivity value, cod stops.
                na=i; %na
                nb=j; %nb
                s1=0;
                break;
            end
        end
    end
    if s1==0
        break;
    end
end
sys_oe=oe(ide_data,[na,nb,nk]); %System Identified According The Adjusted Parameters

%-----Plotting-----%
fprintf('na=%d nb=%d nk=%d\n',na,nb,nk);
subplot(2,2,1)
compare(sys_oe,ide_data);
subplot(2,2,2)
compare(sys_oe,val_data);
subplot(2,2,[3,4])
compare(sys_oe,all_data);
%-----Plotting-----%