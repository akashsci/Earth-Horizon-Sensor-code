classdef Orbit3D < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        %Graphic objects
        
        fig;%Class' figure handle
        axs;%Class' axes handle
%         satellite;%Class' satellite object handle
        globe;%Class' Earth object handle
%         satHandle;
%         satBody;
%         satRod1;
%         satRod2;
%         satRod3;
%         satRod4;
%         satBar1;
%         satBar2;
%         satBar3;
%         satBar4;
%         satBar5;
%         satBar6;
%         satBar7;
%         satBar8;
%         satAA1;
%         satAA2;
%         satAA3;
%         satAA4;
%         satAA5;
%         satAA6;
%         satAntenna;
%         satLens;
        BodyAxes;
        EcefAxes;
        sunVectB;
        hgx;
        animation;%Class' timer object
        
        %Simulation Data
        quaternion;
        xsat_eci;
        gst;
        mag_eci;
        sun_eci;
        Time;
                               
        %Animation parameters
        framerate = 30;
        animspeed = 1;
        zoom = 1;
        %cameraPos = [0 30];%canviar camera pos per la pos del satelite
        SF = 1;
        xsat_now;
        rct;
        i = 2;
        vidObj;
    end
    
    properties (Constant,Access = protected)
        
        %Constants
        erad    = 6371.0087714; % equatorial radius (km)
        prad    = 6371.0087714; % polar radius (km)
        npanels = 90; % Number of globe panels around the equator deg/panel = 360/npanels
        alpha = 1;% globe transparency level, 1 = opaque, through 0 = invisible
%         sat_axes = 1e3;
        earth_axes = 1e4;
%         sun_axes = 1e3;
        %Internal variables
%         NV;
%         DCM;
%         i;
%         spaceColor = 'k';
    end
    
    properties %(Dependent)
        TimeAnimation;
        TimeReal;
        Nframes;
    end
    
    %Declaring class method
    methods
        %Declaring constructor
        function this = Orbit3D(zoom,SF,fps,speed)%I removed the input camera pos
            
            %Figure object handle
            this.fig=figure('DeleteFcn',@(src,event)closefigurefcn(this),...
                       'Color', 'Black',...
                       'units','normalized',...
                       'outerposition',[0 0 1 1],...
                       'Renderer','OpenGL',...
                       'visible','on');

            %Axes object handle       
            this.axs = axes('Parent',this.fig,...
                            'NextPlot','add',...
                            'Visible','on');       
                        
            %Load animation data
            load_quat = load('quaternion.mat');
            this.quaternion = load_quat.q;
            load_xsat = load('xsat_ECI.mat');
            this.xsat_eci = load_xsat.xsat_eci/1000;
            load_gst = load('gst.mat');
            this.gst = load_gst.gst;
            load_sun_eci = load('Sun_ECI.mat');
            this.sun_eci = load_sun_eci.Sun_ECI;
%             load_mag_eci = load('Mag_ECI.mat');
%             this.mag_eci = load_mag_eci.Mag_ECI;
            this.Time = load('Time.mat');
                    
%             %Load Satellite components
%             this.satellite(1) = load('CubeCat2_Body.mat');
%             this.satellite(2) = load('CubeCat2_Rod1.mat');
%             this.satellite(3) = load('CubeCat2_Rod2.mat');
%             this.satellite(4) = load('CubeCat2_Rod3.mat');
%             this.satellite(5) = load('CubeCat2_Rod4.mat');
%             this.satellite(6) = load('CubeCat2_Bar1.mat');
%             this.satellite(7) = load('CubeCat2_Bar2.mat');
%             this.satellite(8) = load('CubeCat2_Bar3.mat');
%             this.satellite(9) = load('CubeCat2_Bar4.mat');
%             this.satellite(10) = load('CubeCat2_Bar5.mat');
%             this.satellite(11) = load('CubeCat2_Bar6.mat');
%             this.satellite(12) = load('CubeCat2_Bar7.mat');
%             this.satellite(13) = load('CubeCat2_Bar8.mat');
%             this.satellite(14) = load('CubeCat2_AntennaArray1.mat');
%             this.satellite(15) = load('CubeCat2_AntennaArray2.mat');
%             this.satellite(16) = load('CubeCat2_AntennaArray3.mat');
%             this.satellite(17) = load('CubeCat2_AntennaArray4.mat');
%             this.satellite(18) = load('CubeCat2_AntennaArray5.mat');
%             this.satellite(19) = load('CubeCat2_AntennaArray6.mat');
%             this.satellite(20) = load('CubeCat2_Antenna.mat');
%             this.satellite(21) = load('CubeCat2_Lens.mat');

            %Load Satellite components
%             this.satBody = load('CubeCat2_Body.mat');
%             this.satRod1 = load('CubeCat2_Rod1.mat');
%             this.satRod2 = load('CubeCat2_Rod2.mat');
%             this.satRod3 = load('CubeCat2_Rod3.mat');
%             this.satRod4 = load('CubeCat2_Rod4.mat');
%             this.satBar1 = load('CubeCat2_Bar1.mat');
%             this.satBar2 = load('CubeCat2_Bar2.mat');
%             this.satBar3 = load('CubeCat2_Bar3.mat');
%             this.satBar4 = load('CubeCat2_Bar4.mat');
%             this.satBar5 = load('CubeCat2_Bar5.mat');
%             this.satBar6 = load('CubeCat2_Bar6.mat');
%             this.satBar7 = load('CubeCat2_Bar7.mat');
%             this.satBar8 = load('CubeCat2_Bar8.mat');
%             this.satAA1 = load('CubeCat2_AntennaArray1.mat');
%             this.satAA2 = load('CubeCat2_AntennaArray2.mat');
%             this.satAA3 = load('CubeCat2_AntennaArray3.mat');
%             this.satAA4 = load('CubeCat2_AntennaArray4.mat');
%             this.satAA5 = load('CubeCat2_AntennaArray5.mat');
%             this.satAA6 = load('CubeCat2_AntennaArray6.mat');
%             this.satAntenna = load('CubeCat2_Antenna.mat');
%             this.satLens = load('CubeCat2_Lens.mat');
%             
            
            %Declaring animation time settings
            this.framerate = 1/fps;
            this.animspeed = speed;
            this.TimeAnimation = 0:this.framerate*this.animspeed:this.Time.simulationTime;
            this.TimeReal = 0:this.Time.dt:this.Time.simulationTime;
            this.Nframes = length(this.TimeAnimation);
            
            %Create video
            this.vidObj = VideoWriter('Orbit3D_SS','MPEG-4');
            this.vidObj.Quality = 100;
            this.vidObj.FrameRate = 30;
            open(this.vidObj);
            
            %PLOT EARTH

            % Earth texture image
            % Anything imread() will handle, but needs to be a 2:1 unprojected globe
            % image.
            opengl hardware
            % Load Earth image for textre map (done by GPU)
            [x, y, z] = ellipsoid(0, 0, 0, Orbit3D.erad, Orbit3D.erad, Orbit3D.prad, Orbit3D.npanels);
            %Generate globe handle
            this.globe = surf(x, y, -z,...
                              'FaceColor', 'none',...
                              'EdgeColor', 0.5*[1 1 1]);
             
            this.hgx = hgtransform;
            set(this.hgx,'Matrix', makehgtform('zrotate',this.gst(1)));
            set(this.globe,'Parent',this.hgx,...
                           'FaceColor', 'texturemap',...
                           'CData', imread('EarthRenderData(3600x1800).png'),...
                           'FaceAlpha', this.alpha,...
                           'EdgeColor', 'none');
            
            %Generate ECI and ECEF axes handle
            hold on;

            %Eci axes
            quiver3(zeros(3,1),zeros(3,1),zeros(3,1),...
                  [Orbit3D.earth_axes;0;0],[0;Orbit3D.earth_axes;0],[0;0;Orbit3D.earth_axes],...
                  'ShowArrowHead','On',...
                  'Color','Red',...
                  'Parent',this.axs);
            %Ecef axes
            this.EcefAxes = quiver3(zeros(3,1),zeros(3,1),zeros(3,1),...
                  [Orbit3D.earth_axes;0;0],[0;Orbit3D.earth_axes;0],[0;0;Orbit3D.earth_axes],...
                  'ShowArrowHead','On',...
                  'Color','Green',...
                  'Parent',this.axs);
              
            %              cos(gst)  sin(gst) 0
            %ECI2ECEF =   -sin(gst)  cos(gst) 0
            %               0        0        1
            GST = [cos(this.gst(1)),sin(this.gst(1)),0; -sin(this.gst(1)), cos(this.gst(1)), 0; 0, 0, 1];
            NextEcefAxes = GST*eye(3);
            set(this.EcefAxes,'UData',Orbit3D.earth_axes*NextEcefAxes(:,1));
            set(this.EcefAxes,'VData',Orbit3D.earth_axes*NextEcefAxes(:,2));
            set(this.EcefAxes,'WData',Orbit3D.earth_axes*NextEcefAxes(:,3));

            hold off;
            
            %PLOT ORBIT
             hold on;
             orbitalpath = plot3(this.xsat_eci(1,:)',this.xsat_eci(2,:)',this.xsat_eci(3,:)','Parent',this.axs);
             set(orbitalpath,'Linewidth',1,...
                             'Color', 'White');
            hold off;
            %PLOT SATELLITE

            % %Satellite object handle
%             this.satHandle(1) = patch('faces', this.satBody.faces,'vertices' ,this.satBody.vertices,'EdgeColor','none','FaceColor', 1/255*[96,96,96],'Parent',this.axs);
%             this.satHandle(2) = patch('faces', this.satRod1.faces,'vertices' ,this.satRod1.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(3) = patch('faces', this.satRod2.faces,'vertices' ,this.satRod2.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(4) = patch('faces', this.satRod3.faces,'vertices' ,this.satRod3.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(5) = patch('faces', this.satRod4.faces,'vertices' ,this.satRod4.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(6) = patch('faces', this.satBar1.faces,'vertices' ,this.satBar1.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(7) = patch('faces', this.satBar2.faces,'vertices' ,this.satBar2.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(8) = patch('faces', this.satBar3.faces,'vertices' ,this.satBar3.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(9) = patch('faces', this.satBar4.faces,'vertices' ,this.satBar4.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(10) = patch('faces', this.satBar5.faces,'vertices' ,this.satBar5.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(11) = patch('faces', this.satBar6.faces,'vertices' ,this.satBar6.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(12) = patch('faces', this.satBar7.faces,'vertices' ,this.satBar7.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(13) = patch('faces', this.satBar8.faces,'vertices' ,this.satBar8.vertices,'EdgeColor','none','FaceColor', 1/255*[30,30,30],'Parent',this.axs);
%             this.satHandle(14) = patch('faces', this.satAA1.faces,'vertices' ,this.satAA1.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);
%             this.satHandle(15) = patch('faces', this.satAA2.faces,'vertices' ,this.satAA2.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);
%             this.satHandle(16) = patch('faces', this.satAA3.faces,'vertices' ,this.satAA3.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);
%             this.satHandle(17) = patch('faces', this.satAA4.faces,'vertices' ,this.satAA4.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);
%             this.satHandle(18) = patch('faces', this.satAA5.faces,'vertices' ,this.satAA5.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);
%             this.satHandle(19) = patch('faces', this.satAA6.faces,'vertices' ,this.satAA6.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);
%             this.satHandle(20) = patch('faces', this.satAntenna.faces,'vertices' ,this.satAntenna.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);
%             this.satHandle(21) = patch('faces', this.satLens.faces,'vertices' ,this.satLens.vertices,'EdgeColor','none','FaceColor', 1/255*[230,230,230],'Parent',this.axs);      
            this.SF = SF;
            
            %Initial satellite attitude
%             DCM = quaternion2dcm(this,this.quaternion(1,:));
            
%             NV = DCM'*this.satBody.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBody.vertices,1));
%             set(this.satHandle(1),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod1.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satRod1.vertices,1));
%             set(this.satHandle(2),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod2.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satRod2.vertices,1));
%             set(this.satHandle(3),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod3.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satRod3.vertices,1));
%             set(this.satHandle(4),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod4.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satRod4.vertices,1));
%             set(this.satHandle(5),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar1.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar1.vertices,1));
%             set(this.satHandle(6),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar2.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar2.vertices,1));
%             set(this.satHandle(7),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar3.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar3.vertices,1));
%             set(this.satHandle(8),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar4.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar4.vertices,1));
%             set(this.satHandle(9),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar5.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar5.vertices,1));
%             set(this.satHandle(10),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar6.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar6.vertices,1));
%             set(this.satHandle(11),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar7.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar7.vertices,1));
%             set(this.satHandle(12),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar8.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satBar8.vertices,1));
%             set(this.satHandle(13),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA1.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satAA1.vertices,1));
%             set(this.satHandle(14),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA2.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satAA2.vertices,1));
%             set(this.satHandle(15),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA3.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satAA3.vertices,1));
%             set(this.satHandle(16),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA4.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satAA4.vertices,1));
%             set(this.satHandle(17),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA5.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satAA5.vertices,1));
%             set(this.satHandle(18),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA6.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satAA6.vertices,1));
%             set(this.satHandle(19),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAntenna.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satAntenna.vertices,1));
%             set(this.satHandle(20),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satLens.vertices';
%             NV = this.SF*NV + repmat(this.xsat_eci(:,1),1,size(this.satLens.vertices,1));
%             set(this.satHandle(21),'Vertices',NV(1:3,:)');
    
    
    
            %Body axes handle
%             hold on;
%             this.BodyAxes = quiver3(this.xsat_eci(1,1)*ones(3,1),this.xsat_eci(2,1)*ones(3,1),this.xsat_eci(3,1)*ones(3,1),...
%                               [Orbit3D.sat_axes;0;0],[0;Orbit3D.sat_axes;0],[0;0;Orbit3D.sat_axes],...
%                               'ShowArrowHead','On',...
%                               'Color','Magenta',...
%                               'LineWidth',1,...
%                               'Parent',this.axs);
%             hold off;
% 
%             %Initial attitude
%             
%             NewAxes = DCM*eye(3);
%             set(this.BodyAxes,'XData',this.xsat_eci(1,1)*ones(3,1));
%             set(this.BodyAxes,'YData',this.xsat_eci(2,1)*ones(3,1));
%             set(this.BodyAxes,'ZData',this.xsat_eci(3,1)*ones(3,1));
%             set(this.BodyAxes,'UData',Orbit3D.sat_axes*NewAxes(:,1));
%             set(this.BodyAxes,'VData',Orbit3D.sat_axes*NewAxes(:,2));
%             set(this.BodyAxes,'WData',Orbit3D.sat_axes*NewAxes(:,3));
% 
%             %PLOT SUN & SUN VECTOR
%             % AU = 149597870.700/1000;
%             % Rsun = 6.995*1e5/1000;
%             % Snpanels = 90;
%             
%             % [xsun, ysun, zsun] = ellipsoid(AU*sun_eci(1,1), AU*sun_eci(1,2), AU*sun_eci(1,3), Rsun, Rsun, Rsun, Snpanels);
% 
%             %Generate sun handle
%             hold on
% 
%      
%             this.sunVectB =  quiver3(this.xsat_eci(1,1),this.xsat_eci(2,1),this.xsat_eci(3,1),...
%                             Orbit3D.sun_axes*this.sun_eci(1,1),Orbit3D.sun_axes*this.sun_eci(1,2),Orbit3D.sun_axes*this.sun_eci(1,3),...
%                             'ShowArrowHead','On',...
%                             'Color','Yellow',...
%                             'Parent',this.axs);

% LSun = 2.5*erad;
% lSun = 8*sun_axes;
% poSun = LSun*sun_eci;

% sunVect =  quiver3(poSun(1,1),poSun(2,1),poSun(3,1),...
%                    -lSun*sun_eci(1,1),-lSun*sun_eci(1,2),-lSun*sun_eci(1,3),...
%                    'ShowArrowHead','On',...
%                    'Color','Yellow',...
%                    'LineWidth',1,...
%                    'Parent',axs);               
% %Initial sun position
% set(sun,'XData',xsun);
% set(sun,'YData',ysun);
% set(sun,'ZData',zsun);

            %Initial sun vector
%             set(this.sunVectB,'XData',this.xsat_eci(1,1));
%             set(this.sunVectB,'YData',this.xsat_eci(2,1));
%             set(this.sunVectB,'ZData',this.xsat_eci(3,1));
%             set(this.sunVectB,'UData',Orbit3D.sun_axes*this.sun_eci(1,1));
%             set(this.sunVectB,'VData',Orbit3D.sun_axes*this.sun_eci(1,2));
%             set(this.sunVectB,'WData',Orbit3D.sun_axes*this.sun_eci(1,3));

% %Initial sun vector
% set(sunVect,'XData',poSun(1,1));
% set(sunVect,'YData',poSun(1,2));
% set(sunVect,'ZData',poSun(1,3));
% set(sunVect,'UData',-lSun*sun_eci(1,1));
% set(sunVect,'VData',-lSun*sun_eci(1,2));
% set(sunVect,'WData',-lSun*sun_eci(1,3));
%             hold off;

% %PLOT MAGNETIC FIELD VECTOR
% mag_axes=1;
% 
% hold on;
% magVect =  quiver3([sat_eci(1,1);0;0],[0;sat_eci(1,2);0],[0;0;sat_eci(1,3)],...
%                    mag_eci(1,1),mag_eci(1,2),mag_eci(1,3),...
%                    'ShowArrowHead','On',...
%                    'Color','Magenta',...
%                    'AutoScale','on',...
%                    'AutoScaleFactor',mag_axes,...
%                    'Parent',axs);
% %Initial sun vector
% set(magVect,'UData',mag_eci(1,1));
% set(magVect,'VData',mag_eci(1,2));
% set(magVect,'WData',mag_eci(1,3));               
% hold off;

%             axis(this.axs,'auto');
            %campos('manual');
            axis vis3d off
            cnt=1000;
            campos([this.xsat_eci(1,1500), this.xsat_eci(2,1500), this.xsat_eci(3,1500)]);
            camtar=[-0.6*6000,0.85*6000,-0.2*6000];
            ct=[camtar(1)-this.xsat_eci(1,1500),camtar(2)-this.xsat_eci(2,1500),camtar(3)-this.xsat_eci(3,1500)];
            this.rct=cnt*(ct/norm(ct));
            camtarget([this.xsat_eci(1,1500), this.xsat_eci(2,1500), this.xsat_eci(3,1500)]+this.rct);
            camroll(0)
            set(this.axs,'CameraViewAngle',60)
            
%             this.cameraType = cameraType;
            this.zoom = zoom;                   
            camzoom(this.zoom);
            axis(this.axs,'equal');


            pause;

            %TIMER
            %Creating timer object
            this.animation=timer('TimerFcn',@(src,event)runanimationfunc(this,src,event),...
                                 'ExecutionMode','fixedRate',...
                                 'Period',this.framerate,...
                                 'TasksToExecute',this.Nframes-2);
            
            %Starting animation
            start(this.animation);
            
        end
               
             
        %Declaring function to start animation
        function play(this)
            start(this.animation);
        end
        
        %Declaring function to pause animation
        function stop(this)
            stop(this.animation);
        end
        
        %Declaring function to reset animation
        function reset(this)
            stop(this.animation)
            this.i = 1;
            runanimationfunc(this,[],[]);
        end
        
        %Declaring destructor
        function delete(this)
            delete(this.animation);
            clear all
            clear classes
        end
        
        function goTo(this, percentage)
            
            stop(this.animation)
            this.i = floor(percentage/100*this.Nframes);
            runanimationfunc(this,[],[]);
        end
        
        %Declaring function to change camera settings
                
        function cameraZoom(this,camZoom)
            this.zoom = camZoom;
            camzoom(this.zoom)
        end
                      
        %Declaring function to change animation speed
        function speedAnim(this, speed)
            
            this.animspeed = speed;
            this.TimeAnimation = 0:this.framerate*this.animspeed:this.Time.simulationTime;
            this.TimeReal = 0:this.Time.dt:this.Time.simulationTime;
            this.Nframes = length(this.TimeAnimation);
        end
        
        function scaleFactor(this, scaleFactor)
            
            this.SF = scaleFactor;
            
        end
        
        %Declaring callback function to end animation
        function closefigurefcn(this)
            stop(this.animation);
%             close(this.vidObj);
            delete(this.animation);
            pause(1);
        end
        
        %Declaring callback function to run the animation
        function runanimationfunc(this,src,event)
            
        %Interpolate quaternion (SLERP)
        index = floor(this.TimeAnimation(this.i)/this.Time.dt)+1;
        lambda = (this.TimeAnimation(this.i)-this.TimeReal(index))/this.Time.dt;
%         qnow = SLERP(this,this.quaternion(index,:),this.quaternion(index+1,:),lambda);
        this.xsat_now = LERP(this,this.xsat_eci(:,index),this.xsat_eci(:,index+1),lambda);
        gst_now = LERP(this,this.gst(index),this.gst(index+1),lambda);
%         sun_now = LERP(this,this.sun_eci(index,:),this.sun_eci(index+1,:),lambda);
%         DCM = quaternion2dcm(this,qnow);
             
        %Satellite attitude
%             NV = DCM'*this.satBody.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBody.vertices,1));
%             set(this.satHandle(1),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod1.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satRod1.vertices,1));
%             set(this.satHandle(2),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod2.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satRod2.vertices,1));
%             set(this.satHandle(3),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod3.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satRod3.vertices,1));
%             set(this.satHandle(4),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satRod4.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satRod4.vertices,1));
%             set(this.satHandle(5),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar1.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar1.vertices,1));
%             set(this.satHandle(6),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar2.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar2.vertices,1));
%             set(this.satHandle(7),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar3.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar3.vertices,1));
%             set(this.satHandle(8),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar4.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar4.vertices,1));
%             set(this.satHandle(9),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar5.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar5.vertices,1));
%             set(this.satHandle(10),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar6.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar6.vertices,1));
%             set(this.satHandle(11),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar7.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar7.vertices,1));
%             set(this.satHandle(12),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satBar8.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satBar8.vertices,1));
%             set(this.satHandle(13),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA1.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satAA1.vertices,1));
%             set(this.satHandle(14),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA2.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satAA2.vertices,1));
%             set(this.satHandle(15),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA3.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satAA3.vertices,1));
%             set(this.satHandle(16),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA4.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satAA4.vertices,1));
%             set(this.satHandle(17),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA5.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satAA5.vertices,1));
%             set(this.satHandle(18),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAA6.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satAA6.vertices,1));
%             set(this.satHandle(19),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satAntenna.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satAntenna.vertices,1));
%             set(this.satHandle(20),'Vertices',NV(1:3,:)');
% 
%             NV = DCM'*this.satLens.vertices';
%             NV = this.SF*NV + repmat(this.xsat_now,1,size(this.satLens.vertices,1));
%             set(this.satHandle(21),'Vertices',NV(1:3,:)');
        
        %Body axes
%         NewAxes = DCM*eye(3);
        
%         set(this.BodyAxes,'XData',this.xsat_now(1)*ones(3,1));
%         set(this.BodyAxes,'YData',this.xsat_now(2)*ones(3,1));
%         set(this.BodyAxes,'ZData',this.xsat_now(3)*ones(3,1));
%         set(this.BodyAxes,'UData',Orbit3D.sat_axes*NewAxes(:,1));
%         set(this.BodyAxes,'VData',Orbit3D.sat_axes*NewAxes(:,2));
%         set(this.BodyAxes,'WData',Orbit3D.sat_axes*NewAxes(:,3));
        
        %Ecef axes
        GST = [cos(gst_now),sin(gst_now),0; -sin(gst_now), cos(gst_now), 0; 0, 0, 1];
        NextEcefAxes = GST*eye(3);
        set(this.EcefAxes,'UData',Orbit3D.earth_axes*NextEcefAxes(:,1));
        set(this.EcefAxes,'VData',Orbit3D.earth_axes*NextEcefAxes(:,2));
        set(this.EcefAxes,'WData',Orbit3D.earth_axes*NextEcefAxes(:,3));
        
        %Earth's rotation
        set(this.hgx,'Matrix', makehgtform('zrotate',gst_now));
        set(this.globe,'Parent',this.hgx);
        
        %Sun vector
%         set(this.sunVectB,'XData',this.xsat_now(1));
%         set(this.sunVectB,'YData',this.xsat_now(2));
%         set(this.sunVectB,'ZData',this.xsat_now(3));
%         set(this.sunVectB,'UData',Orbit3D.sun_axes*sun_now(1));
%         set(this.sunVectB,'VData',Orbit3D.sun_axes*sun_now(2));
%         set(this.sunVectB,'WData',Orbit3D.sun_axes*sun_now(3));
%         

%         campos(1.2*[xsat_now(1) xsat_now(2) xsat_now(3)]);

%         poSun = LSun*sun_now;
%         set(sunVect,'XData',poSun(1));
%         set(sunVect,'YData',poSun(2));
%         set(sunVect,'ZData',poSun(3));
%         set(sunVect,'UData',-lSun*sun_now(1));
%         set(sunVect,'VData',-lSun*sun_now(2));
%         set(sunVect,'WData',-lSun*sun_now(3));
        
%         %Magnetic field vector
%         set(magVect,'XData',xsat_now(1));
%         set(magVect,'YData',xsat_now(2));
%         set(magVect,'ZData',xsat_now(3));
%         set(magVect,'UData',mag_eci(i,1));
%         set(magVect,'VData',mag_eci(i,2));
%         set(magVect,'WData',mag_eci(i,3));
          
%           if mod(i,fps)==0
%           set(TimeTxt,'String',['Time: ',num2str(TimeAnimation(i))]);
%           end

            campos(this.axs,[this.xsat_now(1) this.xsat_now(2) this.xsat_now(3)]);
%             camtarget([this.xsat_now(1), this.xsat_now(2), this.xsat_now(3)]+this.rct);
            camtarget([this.xsat_eci(1,1), this.xsat_eci(2,1), this.xsat_eci(3,1)]+this.rct);

%             axis(this.axs,'equal');

%         writeVideo(this.vidObj, getframe(gca));
%         task = get(this.animation,'TasksExecuted');
%         this.i=this.i+1;
%         if task == this.Nframes-2
%             display('Closing Video File');
%             close(this.vidObj);
%         end
        
        this.i = this.i+1;           
        end
        
    end
    
    methods(Access = protected)
        
        function [DCM] = quaternion2dcm(this,quat)

            quat=quat/norm(quat);
    
            qw=quat(4);
            qx=quat(1);
            qy=quat(2);
            qz=quat(3);

            DCM=[qx^2-qy^2-qz^2+qw^2, 2*qx*qy+2*qz*qw, 2*qx*qz-2*qy*qw;...
                2*qx*qy-2*qz*qw, -qx^2+qy^2-qz^2+qw^2, 2*qy*qz+2*qx*qw;...
                2*qx*qz+2*qy*qw, 2*qy*qz-2*qx*qw, -qx^2-qy^2+qz^2+qw^2];
        end

        function [qout] = SLERP(this,q0,q1,t)

            dotprod = q0(1)*q1(1) + q0(2)*q1(2) + q0(3)*q1(3) + q0(4)*q1(4);
            theta = acos(dotprod);
            if theta<0
            theta = -theta;
            end

            qout = sin((1-t)*theta)/sin(theta)*q0 + sin(t*theta)/sin(theta)*q1;

            qout=qout/norm(qout);

        end

        function [vout] = LERP(this,v0,v1,t)

            vout = (1-t)*v0 + t*v1;
   
        end
        
    end
    
end

