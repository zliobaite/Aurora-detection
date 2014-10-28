% 2014 Feb I.Zliobaite
% detect auroras using clustering

files = dir(strcat(pwd,'/images/*.jpg'));
for file = files'
    
he = imread(strcat(strcat(pwd,'/images/'),file.name));
%he = imadjust(he,stretchlim(he));

p_nclusters = 4;
p_clust_rounds = 5;

%Convert Image from RGB Color Space to L*a*b* Color Space 
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);


%clustering

ab = double(lab_he(:,:,2:3));
%ab = double(lab_he);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
%ab(:,1) = abs(ab(:,1) - 20);


% repeat the clustering 5 times to avoid local minima
[cluster_idx cluster_center] = kmeans(ab,p_nclusters,'distance','sqEuclidean','Replicates',p_clust_rounds,'EmptyAction','Drop');
                                  
                                  
% labeling image for plotting
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure; imshow(pixel_labels,[]), title('image labeled by cluster index');

%for plotting clusters
segmented_images = cell(1,p_nclusters);
rgb_label = repmat(pixel_labels,[1 1 3]);

figure(1);
for sk = 1:p_nclusters
    color = he;
    color(rgb_label ~= sk) = 0;
    subaxis(1,p_nclusters,sk, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
    hold on; imshow(color), title(['objects in cluster ',num2str(sk)]); hold off;
end;
disp('press any key to continue');
pause;

etalon = [100 163]-20;

mean_cluster_value = abs(cluster_center(:,1) - etalon(1,1));
%mean_cluster_value
cluster_center
[tmp, idx] = sort(mean_cluster_value);

ii = find(tmp<20);
if length(ii)>0
    color = he*0;
    for ski = 1:length(ii)
        idx_take = rgb_label == idx(ski);
        color(idx_take) = he(idx_take);
    end
else
    color = ones(size(he))*200;
end;

figure (1); 
subaxis(1,2,1, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
hold on; imshow(he); title(file.name); hold off;
subaxis(1,2,2, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
hold on; imshow(color); title('DETECTION (white = no aurora)'); hold off;
disp('press any key to continue');
pause;

%a = input('s: ')
end