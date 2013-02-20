%notes: projected altitude = 229m,

%% Set Constants
g = -9.8; %m/s^2
rho = 1.2041; %kg/m^3
%Rocket Parameters:
rlen = .986; %m
rdia = .046; %m
rmass = .26; %kg
rmoment = rmass*rlen^2/12; %kg*m^2
rareat = pi*rdia^2/4; %m^2
rareaf = rlen*rdia;
Cdf = .05; %unitless (friction)
Cdp = .05; %unitless (pressure)

Cg = .5; %m (dist from Cg to nose)
Cp = .1; %m (dist from Cp to Cg)
D12Curve = [0 0.049 0.116 00.184 00.237 00.282 00.297 00.311 00.322 00.348 00.386 00.442 0.546 0.718 0.879 1.066 1.257 1.436 1.590 1.612 1.650;
            0 2.569 9.369 17.275 24.258 29.730 27.010 22.589 17.990 14.126 12.099 10.808 9.876 9.306 9.105 8.901 8.698 8.310 8.294 4.613 0.000];
%N

%% Prepare Sim
axes = [-10 10 0 230];

ts = 0:.01:50;
start_theta = .05; %rad; 0 = up, pi/2 = left, -pi/2 = right
start_pos = [0 0]; %m
start_omega = 0; %rad/s
start_vel = [0 0]; %m/s

%% Run Sim
theta = start_theta;
pos = start_pos;
omega = start_omega;
vel = start_vel;

pt = 0;

Fgravity = [0 g*rmass];
angles = [];
for t = ts
    sint = sin(theta); cost = cos(theta);
    Fthrust = interpolate(D12Curve, t)*[sint, cost];
    Fdrag = -.5*rho*Cdp*dot([cost sint], [rareat rareaf])*norm(vel)*vel;
    Tdrag = Cp*dot([-cost sint], Fdrag)
    myTorque = Cp * norm(Fdrag) * (theta - atan(vel(1)/vel(2))) 
    
    Tlift = 0; %%%
    Tdisturb = 0; %%%
    
    Fnet = Fthrust + Fdrag + Fgravity;
    Tnet = Tdrag + Tlift + Tdisturb;
    
    dt = t - pt;
    vel = vel + Fnet/rmass*dt;
    pos = pos + vel*dt;
    omega = omega + Tnet/rmoment*dt;
    theta = theta + omega*dt;
    
    angles = [angles; [theta atan(vel(1)/vel(2))]]; %test
    
    %plot real-time
    
    plot([0 -rlen*sin(theta)]+pos(1), [0 -rlen*cos(theta)]+pos(2));
    axis(axes)
    drawnow
    
    pt = t;
end

%% Plot Results






