% 2014 Feb I.Zliobaite
% generates aurora data for training
% features: cluster center (color), number of pixels, stability of cluster
% color, manual label (aurora or not)

files = dir(strcat(pwd,'/images/*.jpg'));
aurora_data = [];
for file = files'
    
%he = imread('20140221193040.jpg');
he = imread(strcat(strcat(pwd,'/images/'),file.name));
%20140221193040
%20140223030010
%20140223030640
%20140203232942

p_nclusters = 4;
p_clust_rounds = 5;

%Convert Image from RGB Color Space to L*a*b* Color Space 
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);

ab = double(lab_he(:,:,2:3));
%ab = double(lab_he);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);


% repeat the clustering 5 times to avoid local minima
[cluster_idx cluster_center] = kmeans(ab,p_nclusters,'distance','sqEuclidean','Replicates',p_clust_rounds,'EmptyAction','Drop');
                                  
                                  
% labeling image for plotting
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure; imshow(pixel_labels,[]), title('image labeled by cluster index');

%for plotting clusters
segmented_images = cell(1,p_nclusters);
rgb_label = repmat(pixel_labels,[1 1 3]);

    for sk = 1:p_nclusters
        color = he;
        color(rgb_label ~= sk) = 0;
        figure(1);
        %subaxis(1,p_nclusters,sk, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
        imshow(color);
        ans = input('is it aurora? (0/1) : ');
        aurora_data = [aurora_data ; cluster_center(sk,:) sum(cluster_idx==sk) std(ab(cluster_idx==sk,:)) ans];
    end;

end

save aurora_data aurora_data;