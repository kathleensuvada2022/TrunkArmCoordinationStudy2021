function [markerIDs, images] = ParseHTS_nmhRev(filename)
  images = [];
  markerIDs = [];
  lines = load(filename);
  nLines = size(lines, 1);
  nMarkersPerLine = (size(lines, 2) - 2)/14;
  
  if nMarkersPerLine > 1
      for jLine = 1:nLines
          line = lines(jLine, :);
          jImage = line(1) + 1;
          
          if size(images) < jImage
              images(jImage).imageNumber = line(1);
              images(jImage).time = line(2);
              images(jImage).time2 = images(jImage).time - images(1).time;
              %images(jImage).markers = [];
          end
          
          for jMarker = 1:nMarkersPerLine
              cells = line([1:14] + 2+14*(jMarker-1));
              marker.markerId = cells(1);
              markerIDs(jMarker,1) = cells(1);
              marker.status = cells(2);
              hts = cells(3:14);
              
              marker.HTS = [hts(1) hts(2)  hts(3)  hts(4)
                  hts(5) hts(6)  hts(7)  hts(8)
                  hts(9) hts(10) hts(11) hts(12)
                  0      0       0       1];
              
              %images(jImage).markers(end+1) = marker; % Todd's code
              %images(jImage).(char(['marker',num2str(marker.markerId)])) = marker;
              images(jImage).markers.(char(['marker',num2str(marker.markerId)])) = marker;
          end
      end
      
  else
      numMarkers = find(lines(:,1)>0,1) - 1;
      
      for jLine = 1:numMarkers:nLines
          line = lines(jLine:jLine+numMarkers - 1, :);
          jImage = line(1) + 1;
          
          if size(images) < jImage
              images(jImage).imageNumber = line(1,1);
              images(jImage).time = line(1,2);
              images(jImage).time2 = images(jImage).time - images(1).time;
              %images(jImage).markers = [];
          end
          
          for jMarker = 1:numMarkers
              %cells = line([1:14] + 2+14*(jMarker-1));
              cells = line(jMarker,[1:14] + 2);
              marker.markerId = cells(1);
              markerIDs(jMarker,1) = cells(1);
              marker.status = cells(2);
              hts = cells(3:14);
              
              marker.HTS = [hts(1) hts(2)  hts(3)  hts(4)
                  hts(5) hts(6)  hts(7)  hts(8)
                  hts(9) hts(10) hts(11) hts(12)
                  0      0       0       1];
              
              %images(jImage).markers(end+1) = marker; % Todd's code
              %images(jImage).(char(['marker',num2str(marker.markerId)])) = marker;
              images(jImage).markers.(char(['marker',num2str(marker.markerId)])) = marker;
          end
      end
  end
  
end
