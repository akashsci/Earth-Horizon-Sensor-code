function[ edge,thres] = edgedetectionUD(image)
edgeNum=1;
[thres,numrow,numcol] = sethreshold(image);
%thres1=graythresh(image);
for c= 1:(numcol)
    for r= 1:(numrow-4)
        if (image(r,c) > thres) & (image(r+1,c) > thres) & (image(r+2,c) > thres) & (image(r+3,c) > thres)
            edgex(edgeNum,1) = r;
            edgex(edgeNum,2) = c;
            edgeNum = edgeNum +1;
            break
        end
    end
end
edge = edgex;
end
