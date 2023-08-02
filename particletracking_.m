%Code for identifying 3d centres
%And eventually determining the flowrate

%on a dataset newer than in particletracking5.m
%new dataset used here is-IMG_2242.MOV [Apr 11,2023 dataset]
% In this movie particles are stationary
clear all;

%functions in use: ipf, chiimg, clip, findpeaks

full=VideoReader('particle_movie.MOV'); %loading movie
fr=full.FrameRate;   %Framerate of the movie
off=500;           
nf=200;            %no of frames studied
l=[280 537 510 468];      %crop rectangle

bb=size(rgb2gray(imcrop(full.read(1),l)));
raw=zeros(bb(1),bb(2),nf); %zero array for the image size

for nn=1:nf
    %raw(:,:,nn)=rgb2gray((full.read(off+nn)));
    raw(:,:,nn)=rgb2gray(imcrop(full.read(off+nn),l));
end
imagesc(raw(:,:,nn/2)); axis image
%%
% User Inputs
tic
Ds=75; %Smallest diameter
Df=110; %Biggest diameter
D=meanabs([Ds,Df]); % Initial Diameter Guess
w=1; % Initial Width Guess
Cutoff=1; % minimum peak intensity
MinSep=.95*D; % minimum separation between peaks
pmax=22; % max number of particles in any frame (to create zero array)

%the hi and lo value is selected by looking at the colorbar of the image
lo=80;   %hi/lo=typical pixel value outside/inside
hi=135;  %hi and lo values come the image histogram

ri=(double(raw-lo))/(hi-lo);  % normalize image
ri=clip(ri,1,0); %set threshold at both ends between value 0 and 1

ss=2*fix(D/2+4*w/2)-1;          % size of ideal particle image
os=(ss-1)/2;                    % (size-1)/2 of ideal particle image
[xx,yy]=ndgrid(-os:os,-os:os);  % ideal particle image grid
r=hypot(xx,yy);                 % radial coordinate

ppx1=zeros(nf,pmax);ppy1=zeros(nf,pmax);
ppx=zeros(nf,pmax);ppy=zeros(nf,pmax);
npf=zeros(1,nf);dimg=zeros(nf,pmax);

[Ny,Nx]=size(raw(:,:,1)); % image size

%for tracking progress
j=10;
k=fix(nf*.1);
fprintf('Total no. of frames: %d\n',nf)

%Loop for tracking particles in all frames
for jj=1:nf
    
    ipt=1./chiimg(ri(:,:,jj),ipf(r,Ds,w));
    Dimgg=Ds+0*ipt;

    for D=Ds+1:Df
        chi2=1./chiimg(ri(:,:,jj),ipf(r,D,w));
        ii=ipt<chi2;
        ipt(ii)=chi2(ii);
        Dimgg(ii)=D;
    end

    [Np ,py, px]=findpeaks(ipt,1,Cutoff,MinSep);
    npf(jj)=Np; ppx1(jj,1:Np)=px;ppy1(jj,1:Np)=py;
 
    for n=1:Np
      dimg(jj,n)=Dimgg(py(n),px(n));
    end
    ii=ppx1(jj,:)-os>0 & ppx1(jj,:)-os<Nx & ppy1(jj,:)-os>0 & ppy1(jj,:)-os<Ny;
    
    for kk=1:size(ppx1(jj,ii),2)
        aa=ppx1(jj,ii); ab=ppy1(jj,ii);
        ppx(jj,kk)=aa(kk); ppy(jj,kk)=ab(kk);
    end
    
    if mod(jj,k)==0
        fprintf('..................%d%%\n',j)
        j=j+10;
    end
end
fprintf('centre tracking compute time = %4.2f min\n',toc/60)
%%
figure(1); set(1,'WindowStyle', 'Docked')
filename = 'particletracking.gif';
savegif=true;
for jj=1:2:nf-15
    ff=jj;
    aa=ppx(ff,ppx(ff,:)-os>0); ab=ppy(ff,ppy(ff,:)-os>0);
    ac=dimg(ff,dimg(ff,:)>0); %removing points outside of the image

    imagesc(raw(:,:,ff)); axis image 
    hold on %making movie
    plot(aa-os,ab-os,'k*','MarkerSize', 6)
    for nn=1:size(aa,2)
        text(aa(nn)-os+5,ab(nn)-os+5,[num2str(ac(nn))],"FontSize",7)
        viscircles([aa(nn)-os ab(nn)-os],ac(nn)/2,'LineWidth', 1.2);
    end
    hold off
    subtitleText=sprintf('Frame %d', jj);
    subtitleFontSize=12;
    subtitlePosition=[0.87, 1.03];
    text(subtitlePosition(1), subtitlePosition(2), subtitleText, 'Units', 'normalized', 'FontSize', subtitleFontSize, 'HorizontalAlignment', 'center');
    drawnow

    %saving the movie as gif
    if savegif
        frame=getframe(1);
        im=frame2im(frame);
        [imind,cm]=rgb2ind(im,256);
        delay=.10; % to make gif play faster
        if jj==1
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        else
             imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',delay);
        end
    end
end