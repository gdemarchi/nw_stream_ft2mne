pyversion('/Users/gianpaolo/anaconda3/envs/mne/bin/python')

%%
restoredefaultpath
clear all
addpath('~/git/obob_ownft/');
obob_init_ft

addpath('/Users/gianpaolo/Documents/git/nw_stream_ft2mne/');
nw_stream_ft2mne_init
%%
fileinfo='/Users/gianpaolo/Downloads/TMPWORK/180517/19910612CRKE_block01_2Hz_random.fif';

cfg             = [];
cfg.channel = 'MEG';
cfg.dataset     = fileinfo;
%cfg.continuous  = '~/Documents/MATLAB/nw_stream_ft2mne/jens_L.fif';
cfg.hpfilter='yes';
cfg.hpfreq=1;
data = ft_preprocessing(cfg);

cfg          = [];
cfg.length   = 1; % in seconds;
cfg.overlap  = 0;
data = ft_redefinetrial(cfg, data);

data.trialinfo=ones(length(data.trial),1);
origtrl=data.cfg.trl;

%%
cfg=[];
cfg.inputfile=fileinfo;
data=obob_apply_ssp(cfg,data);

%% downsample to speed up
for ii= 1:length(data.time)
    data.time{ii}=linspace(0,1,1000);
end

cfg=[];
cfg.resamplefs=100;

datads=ft_resampledata(cfg, data);
data.sampleinfo=[origtrl(:,1), origtrl(:,2)];


%% CONVERT PREPROC STRUCTURE TO MNE
mne_epochs=nw_ftpreproc2mne(data);

%%
art_log =py.nw_standardautoreject.runautoreject(mne_epochs,py.str('grad'));


 alllear%% c
 

