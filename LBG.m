
function [codebook, clusterID, D] = LBG(X, K, distortion_eps)
% X = input matrix of size M*N where N is number of features and M is number of frames
% codebook is numberOfCluster*Features
% initionlization 
codebook = mean(X,1); %1*N vector
% Compute distortion
D = sum((X-codebook(1,:)).^2,'all');       
D = D./size(X,1);% average of all words
D_not = D;
clusterID = ones(size(X,1), 1); %trace which node belong to which cluster
    while size(codebook,1) < K
        eps = 0.01;
        % split codebook
        codebook = [codebook.*(1-eps);codebook.*(1+eps)];
        
        while(1) % converange 
            %clusterID = zeros(size(X,1), 1);  
            distance = zeros(size(X, 1), size(codebook,1));
            % find nearest nodes
            for i=1:size(codebook,1)
                distance(:,i) = sum(((X-codebook(i,:)).^2),2); % total distance at each dimentison
            end
            [~,clusterID] = min(distance, [], 2); % find min of each node to the closest codebok
            %find New
            codebook = zeros(size(codebook,1), size(X, 2)); %empty the codebook
            for i=1:size(codebook,1)
                codebook(i,:) = mean(X(clusterID==i,:)); %caculate the center of nodes with same ClusterID
            end
            % see new distance is in range yet?
            Ds=zeros(size(codebook,1),1);    
            for i=1:size(codebook,1)
                Ds(i) = sum((X(clusterID==i,:)-codebook(i,:)).^2,'all');       
            end
            D = sum(Ds)./size(X,1);
            
            if(abs(D_not-D)/D < distortion_eps)
                break
            end
            D_not = D;
        end
    end
end

