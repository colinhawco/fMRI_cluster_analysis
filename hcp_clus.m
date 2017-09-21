function hcp_clus

mod = {
    'EMOTION'
    'GAMBLING'
    'LANGUAGE'
    'RELATIONAL'
    'SOCIAL'
    'WM'}

basedir='F:\HCP900/data8/';
cd(basedir)
ids=dir('*')
tfile = 'tstat1.dtseries.nii'
inc(1:899) = 1;

tdat = zeros(899, 96854, 6);

for pdx = 3:length(ids)
    n=pdx-2
    ID=ids(pdx).name;
    name{n}=ID;
    for mdx = 1:6
        modality = mod{mdx};
        
        cd([basedir ID '/' modality ]);
        if exist(tfile, 'file')
%             cift = ft_read_cifti(tfile);
%             tdat(n,:, mdx) = cift.dtseries;
         else
%             tdat(n,:,mdx) = 0;
             inc(n) = 0;
        end
    end
end

%corectex only
data=tdat(:,1:64569,:);
% exclude info voxels
data = data(inc==1,~isnan(data(1,:,1)),:);

tdati=tdat(:,~isnan(tdat(1,:)));

Z = linkage(tdati, 'ward');

figure; [h t p] = dendrogram(Z, 0,'ColorThreshold', 2000);

C = cluster(Z,'MaxClust',3);


pdis=pdist(tdati, 'euclidean');
sdis=squareform(pdis);


save([modality 'hcp_tdat.mat'])

Zall(:,:,1)=Ze; 
Zall(:,:,2)=Zg;
Zall(:,:,3)=Zl;
Zall(:,:,4)=Zr;
Zall(:,:,5)=Zs;
Zall(:,:,6)=Zw;
pall = [ pe;   pg ;  pl;   pr;   ps;   pw ];

for pdx = 1:6
    m1 = min(nonzeros(sdis(pall(pdx,:), pall(pdx,:),pdx))); 
    m2 = max(nonzeros(sdis(pall(pdx,:), pall(pdx,:),pdx))); 
    figure; imagesc(sdis(pall(pdx,:), pall(pdx,:),pdx), [m1*1.1 m2*.8])
end



%%
% sort agreement matricies
for mod=1:6 % modality/scan
    for cdx = 2:10
        [mod cdx]
        a=agree(:,:,cdx,mod);
        ad=pdist(a);
        Z = linkage(a, 'average');
        ord(1:822,cdx,mod) = optimalleaforder(Z,ad,'criteria', 'group');
    end
end

for cdx = 3;%2:10
    a=agree(:,:,cdx,mod);
    figure; imagesc(a(ord(:,cdx,mod),ord(:,cdx,mod)))
end

% plotted by order in k = 2
for cdx = 2:5
    a=agree(:,:,cdx,mod);
    figure; imagesc(a(ord(:,2,mod),ord(:,2,mod)))
    endallcog = [

t=randperm(822);
a=agree(t,t,cdx,mod);
ad=pdist(a); 
Z = linkage(a, 'average');
ot=optimalleaforder(Z,ad,'criteria', 'group');


for mod = 1:6
    figure; plot(squeeze(mean(mean(ari2(:,:,2:10,mod)))))
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
