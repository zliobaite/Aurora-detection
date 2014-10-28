% 2014 Feb I.Zliobaite
% detect auroras without clustering, using simple color filter

files = dir(strcat(pwd,'/images/*.jpg'));
for file = files'
    
he = imread(strcat(strcat(pwd,'/images/'),file.name));

%Convert Image from RGB Color Space to L*a*b* Color Space 
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);



% %adjust contrast 
% max_luminosity = 100;
% L = lab_he(:,:,1)/max_luminosity;
% 
% % replace the luminosity layer with the processed data and then convert
% % the image back to the RGB colorspace
% shadow_imadjust = lab_he;
% shadow_imadjust(:,:,1) = imadjust(L)*max_luminosity;
% shadow_imadjust = applycform(shadow_imadjust, makecform('lab2srgb'));
% 
% shadow_histeq = lab_he;
% shadow_histeq(:,:,1) = histeq(L)*max_luminosity;
% shadow_histeq = applycform(shadow_histeq, makecform('lab2srgb'));
% 
% shadow_adapthisteq = lab_he;
% shadow_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity;
% shadow_adapthisteq = applycform(shadow_adapthisteq, makecform('lab2srgb'));
% 
% 
% figure(1); 
% subaxis(1,4,1, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
% hold on; imshow(he), title('original'); hold off;
% subaxis(1,4,2, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
% hold on; imshow(shadow_imadjust), title('imadjust'); hold off;
% subaxis(1,4,3, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
% hold on; imshow(shadow_histeq), title('histeq'); hold off;
% subaxis(1,4,4, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
% hold on; imshow(shadow_adapthisteq), title('adapthisteq'); hold off;
% pause;
% 
% 
% 
% 

%clustering

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

%take the ones that b is high and a is either low or high (no middle)

cluster_idx = ones(nrows*ncols,1);
id1 = find(ab(:,2)>128);
id2 = find(ab(:,1)<120);
id3 = find(ab(:,1)>150);
id2 = intersect(id1,id2);
id3 = intersect(id1,id3);
cluster_idx(id2) = 2;
cluster_idx(id3) = 3;
                                  
% labeling image for plotting
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure; imshow(pixel_labels,[]), title('image labeled by cluster index');

%for plotting clusters
rgb_label = repmat(pixel_labels,[1 1 3]);

figure(1);
for sk = 1:3
    color = he;
    color(rgb_label ~= sk) = 0;
    subaxis(1,3,sk, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
    hold on; imshow(color), title(['objects in group ',num2str(sk)]); hold off;
end;
pause;

if (length(id2)>0) || (length(id2)>0)
    color = he*0;
    idx_take = rgb_label == 2;
    color(idx_take) = he(idx_take);    
    idx_take = rgb_label == 2;
    color(idx_take) = he(idx_take);    
else
    color = ones(size(he))*200;
end;

figure (1); 
subaxis(1,2,1, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
hold on; imshow(he); title(file.name); hold off;
subaxis(1,2,2, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
hold on; imshow(color); title('DETECTION (white = no aurora)'); hold off;

pause;

%a = input('s: ')
end