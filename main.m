%% Videoray Pro 4 ROV Main run-file
% Created by Bent Oddvar Arnesen @NTNU

clear all; munlock all;

%Initialize mex-files and Videoray object
mex videoray_class_interface_mex.cpp  src/Packetizer.cpp src/serialib.cpp src/VideoRayComm.cpp -Ilib;
vr = videoray_class_interface();

%Initialize mex-files and Joystick object
%mex joystick_class_interface_mex.cpp -Ilib;
%js = joystick_class_interface();

types;

%1) Initialize headset and test if it works
%2) Run a script to take headset/user inputs
%3) Convert these inputs to apropriate control values for the ROV

%Initialize variables and turn off lights. 
u  = zeros(4,1);    %Control inputs from joystick
currentLight = 0;   %Current light strength
vr.setLights(10, 10); %Set light values
hs = [0 0 0];       %Headset command vector
hsStatus = 0;       %Headset status: 0 = offline, else on

%Headset can be used if hsStatus > 0
%initializeHeadset;
if (hsStatus == 0) 
    disp('Headset cannot be used. hsStatus: OFFLINE');
end

fprintf('Videoray is ready to play. The following modes are supported:\n\n');
fprintf('R1/R2 - Enter/Exit mind control mode.\n');
fprintf('SQUARE - Enter Depth Control mode - NOT CURRENTLY SUPPORTED! \n');
fprintf('START  - Terminate Videoray.\n\n');

while(1)
    
%Read joystick signals, allocate to thrusters and set values
    %js.read_joystick_data();    
    %PS3 = [js.getAxisValue(1); js.getAxisValue(2); js.getAxisValue(4); js.getAxisValue(3)]; 
    %u = thrustAllocation(PS3);
    %vr.setThruster(u); 
    vr.setThruster([20 20 0 0]);
      
%Headset control when R1 is pressed. Only 
%     if (js.getButtonValue(R1) == 1 && hsStatus > 0)
%         fprintf('\nHeadset control activated. Press start or R2 to exit. \n\n');
%         while(1)
%             hsGetCommand;
%             if (hs(1) > 0 || hs(2) > 0 || hs(3))
%                 %Simulink - posisjonering: Roter 90 grader venstre, høyre
%                 %eller fremover (smile)
%                 
%                 %bruk read IMU data f eks. 
%                 h = thrustAllocation(headset);
%                 vr.setThruster(h);
%             end
%             
%             if (js.getButtonValue(START) == 1 || js.getButtonValue(R2) == 1)
%                 break;
%             end
%        end
%     end

%Change light.
% for i = 1:1
%     if(getSomeValue(5) == 1)
%         currentLight = changeLights(currentLight, 1);
%     elseif(getSomeValue(6) == 1)
%         currentLight = changeLights(currentLight, 1);
%     end
% end
% 
% %Exit program whenever START-button is pressed.
% for i = 1:1
%     if (js.getButtonValue(START) == 1)
%         u  = zeros(4,1); 
%         vr.setLights(0, 0);
%         break;
%     end
    
%Receive IMU Data    
    [roll, pitch, heading, acc_surge, acc_sway, acc_heave, ...
     acc_roll, acc_pitch , acc_heading, mag_x, mag_y, mag_z, depth] = vr.read_IMU_data();
end

%end

%Delete objects
js.delete();
vr.delete(); 
clear vr; 
clear js;

