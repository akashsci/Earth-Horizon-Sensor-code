function [w,g,w1,w2,y1,y2]=conicplaneintersec(a,b,d)

hAx = []; hPlane = []; hCont = [];
[cx cy] = meshgrid(linspace(-5, 5, 100)); %Generate x and y data for interpolation
zcone = sqrt(cx.^2 + cy.^2); %Generate cone defined at same x and y as plane
AxisBigPos = [0.25 0.05 0.7 0.9];
AxisSmallPos = [0.02 0.75 0.2 0.2];

offset = -1/2; %Set default plane offset
normal = [a; b; d]; %Set default plane normal

% Create figures
figure,


% Initialize axes
        
 
        hAx(1) = axes('Xticklabel',[],...
            'Yticklabel',[],'Zticklabel',[]);
        view(3)
        hold on
        shading interp
        axis([-5 5 -5 5 -5 5])
        grid on
        [x, y, z] = cylinder(linspace(0, 5), 50); %Generate cylinder
        surf(x,y,z*5,'linestyle','none'); % Plot upper cone
        surf(x,y,-z*5,'linestyle','none'); % Plot lower cone
        hPlane = patch(1,1,1,1,'FaceColor','interp');
   
figure,
        hAx(2) = axes('Xtick',[],'Ytick',[]);
        grid on, hold on
        axis([-7 7 -7 7])
       % axis equal   
        % Plots the 3-D intersection of the plane with the unit cones
        % by finding the 0-contour of the difference between the z data for the cone
        % and the z data for the plane defined at the same x and y values, then
        % interpolating to find the z value of the intersection.

        %Ensure normal(3) ~= 0
        if normal(3)>=0 && normal(3)<1e-4
            normal(3) = 1e-4;
        elseif normal(3)<0 && normal(3)>1e-4
            normal(3) = -1e-4;
        end

        % Determine corners of plane
        xx = [-5 5 5 -5]; yy = [-5 -5 5 5]; %Define 4 corners
        zz = -1/normal(3)*(normal(1)*xx + normal(2)*yy + offset); %Generate plane
        c = zz; c(c>1) = 1; c(c<-1) = -1; %Define colorscale
        set(hPlane,'Xdata',xx,'Ydata',yy,'Zdata',zz,'Cdata',c);

        % Generate intersection
        zplane = -1/normal(3)*(normal(1)*cx + normal(2)*cy + offset); %Generate plane z-data
        dz = zplane - zcone; %Compute difference between surfaces

        %%%Determine rotation matrices%%%
        [tht phi] = cart2sph(normal(1), normal(2), normal(3)); %Determine cartesian coords of normal
        R1 = [cos(tht) sin(tht) 0; -sin(tht) cos(tht) 0; 0 0 1]; %Determine first rot matrix
        R2 = [sin(phi) 0 -cos(phi); 0 1 0; cos(phi) 0 sin(phi)]; %Determine second rot matrix
        M = -offset/sqrt(dot(normal(1:3),normal(1:3))); %Determine scaling factor

        %%%First time through is for positive cone, second for negative%%%%
        delete(hCont); hCont = [];
        for k = 1:2
            Z = []; %Initialize Z
            try
                C = contours(cx, cy, dz, [0 0]); %Compute 0 contour
            catch
                C = [];
            end
            if ~isempty(C)
                [X Y v] = contoursconvert(C); %Convert to usable form
                %%%Interpolate to find z values of intersection
                for j = 1:length(v) %For each line
                    tv = 1:v(j); %Create indexing vector
                    Z(tv, j) = interp2(cx, cy, zplane, X(tv, j), Y(tv, j));
                end
               % X(X>1|X<-1) = NaN; Y(Y>1|Y<-1) = NaN; Z(Z>1|Z<-1) = NaN; %Restrict display of line
                th = plot3(hAx(1),X, Y, Z, 'k', 'linewidth', 2); % Plot intersection
                hCont = [hCont; th]; % Append handles
                % Create 2-D conic section
                XYZ = [X(:) Y(:) Z(:)].'; %Create [x; y; z] matrix
                xyz = R2*R1*XYZ; %Perform rotation
                if k==1 xyz1=xyz;
                elseif k==2 xyz2=xyz;
                end
                %X = reshape(xyz(1, :), size(X)); %%
                %Y = reshape(xyz(2, :), size(X)); %%Convert back to mesh
                %Z = reshape(xyz(3, :), size(X)); %%       
                             
            end
            dz = zplane + zcone; %Now set to compute for negative cone
        end
          
          %plot(xyz1(1,:),xyz1(2,:),'y');
          %figure,
          %plot(xyz2(1,:),xyz2(2,:),'g');
          w1=xyz1(1,:);
          w2=xyz2(1,:);
          y1=xyz1(2,:);
          y2=xyz2(2,:);
          w=[xyz1(1,:),xyz2(1,:)];
          g=[xyz1(2,:),xyz2(2,:)];
          plot(w,g,'g');% Plot intersection
          set(gca, 'YTick', [-10:10])
          set(gca,'XTick',[-10:10])
          
        



end