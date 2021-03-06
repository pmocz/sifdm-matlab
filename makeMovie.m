close all
clear all
clc
% Philip Mocz (2020), Princeton University
% Make projected desntiy images from simulation snapshots

% Internal units:
% [L] = kpc
% [M] = Msun
% [E] = Msun (km/s)^2


%stop

%% simulation ID
m22      = 1;                            % (m/ 10^-22 eV)
Lbox     = 20;                           % kpc
N        = 64; 256;400;                           % resolution
Tfinal   = 4;                            % kpc/(km/s) ~ 978 Myr
Nout     = 40;400;                            % number of output
f15      = 1;                             % (f/10^15 GeV)

snapdir   = [ 'output/f' num2str(f15) 'L' num2str(Lbox) 'T' num2str(Tfinal) 'n' num2str(Nout) 'r' num2str(N) '/'];

clim = [5 9];


addpath('helpers/')

% constants
hbar = 1.71818131e-87;
G = 4.3022682e-6;


%% Plot Radial Profiles
snaps = 0:Nout;
cc = 1;
%fh = figure;
%set(fh,'position',[0 0 600 600],'PaperPosition',[0 0 6 6]);

for snapnum = snaps
    
    [ t, m22, Lbox, N, psi ] = readsnap( snapdir, snapnum );
    m = m22 * 8.96215327e-89;
    

    
    %% Quick Save
    savname = ['frames/f' num2str(f15) 'L' num2str(Lbox) 'T' num2str(Tfinal) 'n' num2str(Nout) 'r' num2str(N) 's' num2str(snapnum) '.png'];
    A = log10(mean(abs(psi).^2,3));
    A = circshift(A, [N/2-round(108*N/256)+1, N/2-round(12*N/256)+1]); % recenter on a specific pixel
    Amax = clim(2);
    Amin = clim(1);
    A = (A - Amin)/(Amax-Amin);
    A(A<0) = 0;
    A(A>1) = 1;
    Ncolor = 256;
    A = uint8(A*Ncolor);
    mymap = inferno(Ncolor);
    imwrite(A, mymap, savname,'png');
    
    
%%
%     colormap(inferno);
%     %colormap(1-copper(256));
%     %colormap(redblue(256));
%     %colormap(jet);
%
%     imagesc([0 Lbox],[0 Lbox],log10(mean(abs(psi).^2,3)))
%     caxis(clim)
%     axis off
%     axis square
%     set(gca,'ydir','normal')
%     
%     set(gca, 'unit', 'normalize')
%     set(gca, 'position', [0 0 1 1]);
%     
%     
%     %% Save Plot
%     fh.PaperPositionMode = 'manual';
%     fig_pos = fh.PaperPosition;
%     fh.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fh,['framesSI/si' num2str(siSwitch) 'f' num2str(f15) 'L' num2str(Lbox) 'T' num2str(Tfinal) 'n' num2str(Nout) 'r' num2str(N) 's' num2str(snapnum) '.png'],'-dpng')
%     

end


