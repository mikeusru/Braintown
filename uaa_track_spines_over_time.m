function uaa_track_spines_over_time(frames)

global uaa

if nargin < 1
    frames = 848 : 902;
end

images = uaa.T.Image(frames);
spine_coords = uaa.T.SpineCoordinates(frames);
spine_correlation_index = {1:size(spine_coords{1},1)};

max_spines = max(cellfun(@(x) size(x,1) ,spine_coords));
spine_coordinate_matrix = nan(max_spines,2,length(frames));
spine_coordinate_matrix(1:size(spine_coords{1},1),1:size(spine_coords{1},2),1) = spine_coords{1};

for i = 1:(length(frames)-1)
    coords_current = spine_coordinate_matrix(:,:,i);
    len = size(coords_current,1);
    coords_next = spine_coords{i+1};
    [D,I] = pdist2(coords_current, coords_next, 'euclidean', 'smallest', len);
    best_match_index = I(1,:);
    % check for non-unique pairups
    [~,idxu,idxc] = unique(best_match_index);
    [count, ~, idxcount] = histcounts(idxc,numel(idxu));
    non_unique_index = count(idxcount)>1;
    if sum(non_unique_index) > 0
        non_unique_matches = best_match_index(non_unique_index);
        for j = unique(non_unique_matches)
            %min distance from non unique matches
            potential_bad_match_ind = find(best_match_index == j);
            [~,better_match_ind] = min(D(1,potential_bad_match_ind));
            potential_bad_match_ind(better_match_ind) = [];
            best_match_index(potential_bad_match_ind) = nan;
        end
    end
    missing_indices = setdiff(1:length(best_match_index),best_match_index);
    best_match_index(isnan(best_match_index)) = missing_indices; 
    spine_correlation_index{i+1} = best_match_index;
    spine_coordinate_matrix(best_match_index,:,i+1) = coords_next;
end

%% Graph timeline of spines in 3D, where depth is time and color is spine identification
X1 = squeeze(spine_coordinate_matrix(:,1,:));
Y1 = squeeze(spine_coordinate_matrix(:,2,:));
Z1 = repmat(1:size(spine_coordinate_matrix,3),5,1);
Z1(isnan(X1)) = nan;

% separate lines by nan
X = {[]};
Y = {[]};
Z = {[]};

line_count = 1;
for i = 1:size(X1,1)
    for j = 1 : size(X1,2)
        if ~isnan(X1(i,j))
            X{line_count} = [X{line_count}, X1(i,j)];
            Y{line_count} = [Y{line_count}, Y1(i,j)];
            Z{line_count} = [Z{line_count}, Z1(i,j)];
            
        elseif ~isempty(X{line_count})
            line_count = line_count + 1;
            X{line_count} = [];
            Y{line_count} = [];
            Z{line_count} = [];                      
        end
    end
    if ~isempty(X{line_count})
        line_count = line_count + 1;
        X{line_count} = [];
        Y{line_count} = [];
        Z{line_count} = [];
    end
end


f = figure;
ax = axes(f);
hold(ax,'on')
for i = 1:length(X)
    plot3(ax,Z{i},Y{i},X{i},'linewidth',4);
    xlabel('Time (min)');
    ylabel('Y (px)');
    zlabel('X (px)');
end
for i = 1:20:length(frames)
    img = images{i};
	img = double(img)/double(max(img(:)));
    img = repmat(img,1,1,3);
    [Ximg,Yimg] = meshgrid(1:size(img,1),1:size(img,2));
    surf(ax,ones(size(images{i}))*i, Ximg', Yimg', double(img)/double(max(img(:))),'EdgeColor','none','facealpha',.3)
end
hold(ax,'off');