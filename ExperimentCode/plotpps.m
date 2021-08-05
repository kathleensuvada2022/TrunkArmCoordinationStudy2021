function plotpps

            
            t_pps_length = length(find(pps.time_out));
            t = zeros(1,length(obj.data(2,:)));
            t_pps = zeros(1,t_pps_length);
         
            %Image_plot = zeros(25, 17);
            Image_plot = zeros(27, 21); %<= updated for new pressure mat 3/2/18
            
            for i = 1:length(obj.data(2,:))
                t(i) = sum(obj.data(2,1:i));
            end
            
            
            for j = 2:length(t)
                t(j) = t(j) - t(1);
            end
            
            t(1) = 0;
            
            
            for j = 1:t_pps_length
                t_pps(1,j) = pps.time_out(j,1) - pps.time_out(1,1);
                t_pps(1,j) = t_pps(1,j)/1000;
            end
            
            PPSdata = pps.data_out;