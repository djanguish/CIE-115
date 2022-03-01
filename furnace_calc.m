function Q=furnace_calc(T_day,T_night)

%Daniel Anguish 2/24/2022

footprint = 12*sum('Daniel Anguish');%assigns fixed value that is unique
surface_area = sqrt(footprint)*10*4+footprint; %calculates surface area exposed for a cube resting on a solid plane
R_val = 20; %r-value insulation constant
time_increm = 1;% fixed time increment
temp_indoor(1)= T_night; %initializes temp indoor as a vector with initial value T_night from input
C_tm = 0.35; % given constant
m_t = 30000; %thermal mass Given
t=[0:time_increm:48]; %generates time as a vector counting by the time increment % increments by 30 minute steps
Q_heating = zeros(1,length(t)); %preallocates Q_heating as a vector of Length(t) in length for the purpose of predefining the variable before line 67

%processes data

for i = 1+time_increm:time_increm:48 %

    %generates temperature change from heat loss

    %generates heat loss
    Temp_out(i) = 5-9*cos((t(i)*pi)/12);    %calculates outdoor temperature works
    Q(i) = time_increm*(surface_area*(temp_indoor(i-1)-Temp_out(i))/R_val); %calculates temperature gradient
    %Q(i) =
    temp_loss(i) = (Q(i)/C_tm.*m_t) ;%calculates change in temp

    %calculates temperature before furnace
   temp_indoor(i) = temp_indoor(i-1) + temp_loss(i);%calculates new indoor temperature and logs it in temp_indoor
    
   %controls variable thermo's state( 1 meaning on 0 meaning off)
   if 12<t(i)&&t(i)<=20 % compares the value of t(i) between 12 and 20 including 20
        if temp_indoor(i)>=T_day
            thermo(i) = 0; %flags thermo as 0 if temperature is at or above the requirement repeated on lines 43 and 53
        end

        if temp_indoor(i)<T_day
            thermo(i) = 1;%flags thermo as 1 if temperature is below the requirement repeated on lines 47 and 57
        end
    end

    if 32<t(i)&&t(i)<=45
        if temp_indoor(i)>=T_day
            thermo(i) = 0;
        end

        if temp_indoor(i)<T_day
            thermo(i) = 1;
        end
    end

    if 0<=t(i)&&t(i)<=12|20<t(i)&&t(i)<=32|45<t(i)&&t(i)<=48 %compares whether t(i) is between either 0 AND 12, OR 20 AND 32, OR 45 AND 48
        if temp_indoor(i)>T_night
            thermo(i) = 0;
        end
    
        if temp_indoor(i)<T_night
            thermo(i) = 1;
        end
    end

    %converts thermo into heating the house by 27000 BTUS
    if thermo(i)==1
        Q_heating(i)=27000;
    end

    %updates temp_indoor by adding Q_heating
    temp_indoor(i) = temp_indoor(i)+Q_heating(i);

end

%output field
figure(1)
plot(t(1:length(t)-1),temp_indoor) %generates plot of t_indoor temperature over time (generates odd graph)
end
