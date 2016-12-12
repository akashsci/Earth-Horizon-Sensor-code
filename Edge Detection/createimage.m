function [image] = edgedetect(IM)
tic
[cols1,rows1]=edgedetectionLR(IM);
[cols2,rows2]=edgedetectionRL(IM);
[cols3,rows3]=edgedetectionUD(IM);
[cols4,rows4]=edgedetectionDU(IM);
image=zeros(size(IM));
image1=zeros(size(IM));
image2=zeros(size(IM));
image3=zeros(size(IM));
image4=zeros(size(IM));
for i = 1:length(cols1)
    image1(cols1(i,1),cols1(i,2),1)=1;
    image(cols1(i,1),cols1(i,2),1)=1;
end
for i = 1:length(cols2)
    image2(cols2(i,1),cols2(i,2),1)=1;
    image(cols2(i,1),cols2(i,2),1)=1;
end
for i = 1:length(cols3)
    image3(cols3(i,1),cols3(i,2),1)=1;
    image(cols3(i,1),cols3(i,2),1)=1;
end
for i = 1:length(cols4)
    image4(cols4(i,1),cols4(i,2),1)=1;
    image(cols4(i,1),cols4(i,2),1)=1;
end
[fi,co] = size(image);
for i = 1:fi
    for j = 1:5
        image(i,j)=0;
        image(i,co-j)=0;
    end
end
for i = 1:co
    for j = 1:5
        image(j,i,1)=0;
        image(fi-j,i,1)=0;
    end
end
toc       
%figure,imshow(image1)   
%figure,imshow(image2)
%figure,imshow(image3)
%figure,imshow(image4) 
%figure,imshow(image)
end

