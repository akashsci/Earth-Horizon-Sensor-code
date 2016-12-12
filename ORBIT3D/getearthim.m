      function getearthim(zoom,roll,pitch,FOV)
            erad    = 6371.0087714; % equatorial radius (km)
            prad    = 6371.0087714; % polar radius (km)
            npanels = 90; % Number of globe panels around the equator deg/panel = 360/npanels
            alpha = 1;% globe transparency level, 1 = opaque, through 0 = invisible
%        
            earth_axes = 1e4;
            fig=figure('Color', 'Black',...
                       'units','normalized',...
                       'outerposition',[0 0 1 1],...
                       'Renderer','OpenGL',...
                       'visible','on');

            %Axes object handle       
            axs = axes('Parent',fig,...
                            'NextPlot','add',...
                            'Visible','on');
            daspect(axs,[1 1 1])
                        
            %Load animation data
            load_xsat = load('xsat_ECI.mat');
            xsat_eci = load_xsat.xsat_eci/1000;
            load_gst = load('gst.mat');
            gst = load_gst.gst;
           
           
            
            %PLOT EARTH
            % Earth texture image
            % Anything imread() will handle, but needs to be a 2:1 unprojected globe
            % image.
            opengl hardware
            % Load Earth image for textre map (done by GPU)
            [x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);
            %Generate globe handle
            globe = surf(x, y, -z,...
                              'FaceColor', 'red',...
                              'EdgeColor', 0.5*[1 1 1]);
             
            hgx = hgtransform;
            set(hgx,'Matrix', makehgtform('zrotate',gst(1)));
            set(globe,'Parent',hgx,...
                           'FaceColor', 'texturemap',...
                           'CData', imread('EarthRenderData(3600x1800).png'),...
                           'FaceAlpha', alpha,...
                           'EdgeColor', 'none');      
         
            axis vis3d off
            R=6371;
            H=500;
            ro=asin(R/(H+R));
            D=sqrt((R+H)^2-R^2);
            z=sin(ro+pitch*pi/180)*D;
            x=cos(ro+pitch*pi/180)*D;
            xf=R+H-x;
            %zp=tan(ro+(pitch*pi/180))*x-z;%provar
            FOVg=(FOV*70/(ro*180*2/pi));%*(pitch*(-7/120)+1.23);
            camtar=[xf,0,z];
            %camtar=[0,0,0];
            campos([R+H,0,0]);
           % camtar=[0,0,0];
%             ct=[camtar(1)-xsat_eci(1,1),camtar(2)-xsat_eci(2,1),camtar(3)-xsat_eci(3,1)];
%             rct=cnt*(ct/norm(ct));
            %camtarget([xsat_eci(1,1), xsat_eci(2,1), xsat_eci(3,1)]+rct);
            camtarget(camtar);
            camroll(roll);
            set(axs,'CameraViewAngle',FOVg)         
    end