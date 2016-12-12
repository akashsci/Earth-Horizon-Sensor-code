function[ edge,thres] = edgedetectionRL(image)
edgeNum=1;
[thres,numrow,numcol] = sethreshold(image);
%thres1=graythresh(image);
for r= 1:(numrow)
    for c = 1:(numcol-4)
        if (image(r,numcol-c) > thres) & (image(r,numcol-c-1) > thres) & (image(r,numcol-c-2) > thres) & (image(r,numcol-c-3) > thres)
            edgex(edgeNum,1) = r;
            edgex(edgeNum,2) = numcol-c;
            edgeNum = edgeNum +1;
            break
        end
    end
end
edge = edgex;
end
