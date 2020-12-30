a = dir('*.xyz');
fp = fopen('00000_batch.bat','w');

for i=1:length(a)
    %tic
    name = numstr_convert(i,5) ;
    load([name,'.mat']);
    namexyz = [name,'.xyz'];
    M = readxyzsimple([name,'.xyz']);
    if M.zlen == M.xlen
        M.zpos = M.zpos-min(M.zpos);
        M.zlen = max(M.zpos);
    end
    writexyz([name,'_t.xyz'],M);
    nameinput = [name,'_multislice.txt'];
    outputfilename = [name,'.h5'];
    input = sprintf('prismatic -i %s -2D 50 200 -p 0.05 -f 2 -r %g -wx 0 0.9999 -wy 0 0.9999 -te False -o %s -E %g -df %g -C3 %g -C5 %g -sa %g -d 30',...
        [name,'_t.xyz'],M.xlen/256,outputfilename,params.kev,params.df,params.C3,params.C5,params.amax);
    %inputfile = [name,'.input'];
    fprintf(fp,'%s\n',input);
    
    %[status,cmdout] = dos(input);
    %II = h5read('00001.h5','/4DSTEM_simulation/data/realslices/annular_detector_depth0000/realslice');
    %II = II(1:256,1:256);
    %writeTIFF_float(II,[name '.tif']);
    %toc
    if mod(i,100)==1
        fprintf('%g done\n',i);
    end
end
fclose(fp);