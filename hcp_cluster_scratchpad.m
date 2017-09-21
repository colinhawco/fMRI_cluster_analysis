% this is a scratchpad script which contains many of the calls and commands
% used to clsuter the HCP data


%%
% Basic clustering variables and parameters
Ze= linkage(data(:,:,1), 'ward');
Zg= linkage(data(:,:,2), 'ward');
Zl= linkage(data(:,:,3), 'ward');
Zr= linkage(data(:,:,4), 'ward');
Zs= linkage(data(:,:,3), 'ward');
Zw= linkage(data(:,:,6), 'ward');

figure; [h t pe] = dendrogram(Ze, 0,'ColorThreshold', 2000);
figure; [h t pg] = dendrogram(Zg, 0,'ColorThreshold', 2000);
figure; [h t pl] = dendrogram(Zl, 0,'ColorThreshold', 2000);
figure; [h t pr] = dendrogram(Zr, 0,'ColorThreshold', 2000);
figure; [h t ps] = dendrogram(Zs, 0,'ColorThreshold', 2000);
figure; [h t pw] = dendrogram(Zw, 0,'ColorThreshold', 2000);

%very provisonal number of clsuters based on visiual examination of the data
Ce = cluster(Ze,'MaxClust',6);
Cg = cluster(Zg,'MaxClust',5);
Cl = cluster(Zl,'MaxClust',2);
Cr = cluster(Zr,'MaxClust',3);
Cs = cluster(Zs,'MaxClust',3);
Cw = cluster(Zw,'MaxClust',5);

Zall(:,:,1)=Ze; 
Zall(:,:,2)=Zg;
Zall(:,:,3)=Zl;
Zall(:,:,4)=Zr;
Zall(:,:,5)=Zs;
Zall(:,:,6)=Zw;

pall = [ pe;   pg ;  pl;   pr;   ps;   pw ];

for mdx = 1:6
    mdx
    pdis = pdist(data(:,:,mdx), 'euclidean');
    sdis(:,:,mdx) = squareform(pdis); 
end


for mdx = 1:6
    m1 = min(nonzeros(sdis(pall(mdx,:), pall(mdx,:),mdx))); 
    m2 = max(nonzeros(sdis(pall(mdx,:), pall(mdx,:),mdx))); 
    figure; imagesc(sdis(pall(mdx,:), pall(mdx,:),mdx), [m1*1.2 m2*.7])
end

%%
% bootstrap clsuters





%%
% sort agreement matricies
for mdx=1:6 % modality/scan
    for cdx = 2:10
        [modal cdx]
        a=agree(:,:,cdx,mdx);
        ad=pdist(a);
        Z = linkage(a, 'average');
        ord(1:822,cdx,mdx) = optimalleaforder(Z,ad,'criteria', 'group');
    end
end

for cdx = 3;%2:10
    a=agree(:,:,cdx,mdx);
    figure; imagesc(a(ord(:,cdx,mdx),ord(:,cdx,mdx)))
end

% plotted by order in k = 2
for cdx = 2:5
    a=agree(:,:,cdx,mdx);
    figure; imagesc(a(ord(:,2,mdx),ord(:,2,mdx)))
    endallcog = [

t=randperm(822);
a=agree(t,t,cdx,mdx);
ad=pdist(a); 
Z = linkage(a, 'average');
ot=optimalleaforder(Z,ad,'criteria', 'group');


for mdx = 1:6
    figure; plot(squeeze(mean(mean(ari2(:,:,2:10,mdx)))))
end


%% 
% cognitive data
n=1; 
for pdx = 1:899
    if inc(pdx) ==1
        cog_822(n,:) = cog_all(cogid == str2num(name{pdx}), :);
        n=n+1
    end
end
