classdef Judp < handle
    %UDP Summary of this class goes here
    %   This is a java implementation of UDP communication.  This is 
    %   written to bypass using the instrument control toolbox, of which 
    %   Northwestern only has 1 license seat. (rest of detailed explanation goes here)
    %   modified from the judp.m file at: http://www.mathworks.com/matlabcentral/fileexchange/24525-a-simple-udp-communications
    
    properties
        host = '127.0.0.1';
        port = 27010;
        id;
        socketSend; % socket used for sending. Initialized using a port
        socketReceive; % socket used for receiving. Initialized without a port.
    end
    
    methods
        function obj = Judp( obj )
        end
        
        function delete(obj)
            obj.Disconnect;
        end
        
        function obj = Connect( obj )
            import java.io.*
            import java.net.DatagramSocket
            
            % create a socket for sending
            try
                obj.socketSend = DatagramSocket;
                obj.socketSend.setReuseAddress(1);
                
            catch connectError
                disp('error opening socket');
                try
                    obj.socketSend.close;
                    disp('socket closed');
                catch
                    disp('error closing socket');
                end
                
                error('--Failed to connect to UDP socket.\nJava error message follows:\n%s\n',connectError.message);
                
            end
            
            % create a socket for receiving
            %{
            try
                obj.socketReceive = DatagramSocket(obj.port);
                obj.socketReceive.setReuseAddress(1);
                
            catch connectError
                disp('error opening socket');
                try
                    obj.socketReceive.close;
                    disp('socket closed');
                catch
                    disp('error closing socket');
                end
                
                error('--Failed to connect to UDP socket.\nJava error message follows:\n%s\n',connectError.message);
                
            end
            %}
            %obj.id = pnet( 'udpsocket', obj.port );             % create and bind socket
            %pnet( obj.id, 'udpconnect', obj.host, obj.port );   % connect socket
        end
        
        
        function obj = Write( obj, data )
            import java.io.*
            import java.net.InetAddress
            import java.net.DatagramPacket
            import java.net.DatagramSocket
                        
            data = int8(data);
            try
                address = InetAddress.getByName(obj.host);
                packet = DatagramPacket(data, length(data), address, obj.port);
                obj.socketSend.send(packet);
                
            catch sendPacketError
                fprintf('--Failed to send UDP packet.\nJava error message follows:\n%s\n',sendPacketError.message);
            end
            %pnet(obj.id,'write',data);                      % write to write buffer
            %pnet(obj.id,'writepacket',obj.host,obj.port);   % send buffer as UDP packet
        end
        
        
        function [ data, obj ] = Read( obj )
            import java.net.DatagramPacket
            import java.net.DatagramSocket
            
            try
                %obj.socket.setSoTimeout(timeout); % needed?
                
                packetLength = 100;
                packet = DatagramPacket(zeros(1,packetLength,'int8'),packetLength);
                obj.socketReceive.receive(packet);
                data = packet.getData;
                data = data(1:packet.getLength);
                data = char(data');
                
                %{
                % needed?
                if strcmp(data,'close')
                    disp('close socket');
                    try
                        obj.socket.close;
                        disp('socket closed');
                    catch closePacketError
                        disp('cant close socket');
                    end
                end
                %}
                
            catch receiveError
                fprintf('--Failed to receive UDP packet.\nJava error message follows:\n%s\n',receiveError.message);
            end
        end
        
        
        function obj = Disconnect( obj )
            import java.net.DatagramSocket
            
            % close both the sending and receiving sockets if there are any
            if ~isempty(obj.socketSend)
                try
                    obj.socketSend.close;
                catch closePacketError
                    fprintf('--Failed to disconnect from UDP socket.\nJava error message follows:\n%s\n',closePacketError.message);
                end
            end
            %{
            try
                obj.socketReceive.close;
            catch closePacketError
                fprintf('--Failed to disconnect from UDP socket.\nJava error message follows:\n%s\n',closePacketError.message);
            end
            %}
            %pnet(obj.id,'close');
        end
    end
    
end

