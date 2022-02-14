clc; clear; close;
%-----Variables-----% (Can be adjust by user)
nk_max=10; %Max. Dealy Value for Delay Calculation
na_max=15; %Max. na Value for Parameter Calculation
nb_max=15; %Max. nb Value for Parameter Calculation
nc_max=15; %Max. nc Value for Parameter Calculation
nd_max=15; %Max. nd Value for Parameter Calculation
sens1=10^-2; %Sensitivity for Identification Data
sens2=10^-2; %Sensitivity for Validation Data
%-----Variables-----% (Can be adjust by user)
 
%-----Load validation and estimation data-----%
load data data;
ide_data=data(1:696); %Identification Data
val_data=data(697:end); %Validation Data
ide_data=detrend(ide_data);
val_data=detrend(val_data);
all_data=detrend(data); %All Data
%-----Load validation and estimation data-----%

[nk]=nk_estimator(nk_max,ide_data,val_data); %Delay Value Calculation

sim1=zeros(1,na_max*nb_max); %Size of data holder adjusted
sim2=zeros(1,na_max*nb_max); %Size of data holder adjusted

x=0;  %Counter
s1=1; %Variable to stop for loop.
s2=1; %Variable to stop for loop.
s3=1; %Variable to stop for loop.
%--System Identification done for all na,nb and nc values--%
for i=1:na_max 
    for j=1:nb_max
        for k=1:nc_max
            for z=1:nd_max
                x=x+1;
                sys_bj=bj(ide_data,[i,j,k,z,nk]);
                [~,sim1(x),~]=compare(sys_bj,ide_data); %Fit for identification data calculated and hold on sim1 variable.
                [~,sim2(x),~]=compare(sys_bj,val_data); %Fit for validation data calculated and hold on sim2 variable.
                if x>=2
                    val1=abs(sim1(x)-sim1(x-1)); %Difference between last identification fit and previous one calculated. 
                    val2=abs(sim2(x)-sim2(x-1)); %Difference between last validation fit and previous one calculated.
                    if val1<=sens1 && val2<=sens2 
                        %If both differance are decreasing at the same time, smaller than adjusted
                        %sensitivity value, cod stops.
                        na=i; %na
                        nb=j; %nb
                        nc=k; %nc
                        nd=z; %nd
                        s1=0; 
                        break;
                    end
                end
            end
            if s1==0
                s2=0;
                break;
            end
        end
        if s2==0
            s3=0;
            break;
        end
    end
    if s3==0
        break;
    end
end
sys_bj=bj(ide_data,[na,nb,nc,nd,nk]); %System Identified According The Adjusted Parameters

%-----Plotting-----%
fprintf('na=%d nb=%d nc=%d nd=%d nk=%d\n',na,nb,nc,nd,nk);
subplot(2,2,1)
compare(sys_bj,ide_data);
subplot(2,2,2)
compare(sys_bj,val_data);
subplot(2,2,[3,4])
compare(sys_bj,all_data);
%-----Plotting-----%