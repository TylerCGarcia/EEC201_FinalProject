function b=vqlbg(v,k) 
% VQLBG Vector quantization using the Linde-Buzo-Gray algorithm % 
% Inputs: % v contains training data vectors (one per column)
% k is number of centroids required %
% Outputs: c contains the result VQ codebook (k columns, one for each centroids) 
c=mean(v,2); 
figure(8); 
plot(c(:,:),'.'); 
title('initial codebook'); %pause 
e=0.01;
c(:,1)=c(:,1)+c(:,1)*e;
figure(9); 
plot(c(:,:),'.');
title('codebook1'); %pause 
c(:,2)=c(:,1)-c(:,1)*e 
figure(10);
plot(c(:,:),'.'); 
title('codebook2'); %pause % Nearest Neighbour Searching. 
% Given a current codebook 'c', assign each training vector in 'v' with the
% closest codeword. Using the function disteu2, the distances between these 
% vectors (v and c) are computed. 
d=disteu(v,c); 
[m,id]=min(d,[],2); 
[rows,cols]=size(c); % The centroids of the vectors are found using the mean function. 
for j=1:cols 
    c(:,j)=mean(v(:,find(id==j)),2); 
end 
figure(11); 
plot(c(:,:),'.'); 
title('new cluster'); %pause % for each training vector, find the closest codeword using the min % function. 
n=1;n=n*2;
while cols<16 
    for i=1:cols 
        c(:,i)=c(:,i)+c(:,i)*e; 
        c(:,i+n)=c(:,i)-c(:,i)*e; 
        d=disteu(v,c); [m,i]=min(d,[],2); 
        [rows,cols]=size(c); 
    end 
    figure(12); p
    lot(c(:,:),'.'); 
    title('updated'); %pause % The centroids of the vectors are found using the mean function. 
    for j=1:cols 
        if find(i==j)
            ~isempty(c); 
            c(:,j)=mean(v(:,find(i==j)),2); 
        end 
    end 
    n=n*2; 
end