% Cluster yeast data using Kmeans


% This file is from pmtk3.googlecode.com 
% modified by E. Benetos 2017


load('yeastData310') % 'X', 'genes', 'times');

figure;imagesc(X);

xlabel('time')
set(gca,'xticklabel',times)
ylabel('genes')
title('yeast microarray data')
colorbar

figure; plot(times,X,'o-');
xlabel('time')
set(gca,'xticklabel',times)
set(gca,'xtick',times)
ylabel('genes')
title('yeast microarray data', 'fontsize', 12)
set(gca,'xlim',[0 max(times)])


[ctrs, cidx] = kmeansFit(X, 16);
ctrs = ctrs';
figure;
for c = 1:16
    subplot(4,4,c);
    plot(times,X((cidx == c),:)');
    axis tight
end
suptitle('K-Means Clustering of Profiles');


figure;
for c = 1:16
    subplot(4,4,c);
    plot(times,ctrs(c,:)','-' ,'linewidth', 3);
    axis tight
    axis off    % turn off the axis
end
suptitle('K-Means centroids')

