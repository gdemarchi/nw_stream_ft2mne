pyversion('/Users/b1019548/anaconda3/bin/python')

%%
restoredefaultpath
clear all
addpath('~/Documents/MATLAB/obob_ownft/');
obob_init_ft

addpath('~/Documents/MATLAB/nw_stream_ft2mne/');
nw_stream_ft2mne_init
%%
fileinfo='/Users/b1019548/Desktop/Data_Sternberg/jens_L.fif';

cfg             = [];
cfg.channel = 'MEG';
cfg.dataset     = fileinfo;
cfg.continuous  = 'yes';
% cfg.hpfilter='yes';
% cfg.hpfreq=1;
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
cfg.resamplefs=128;

data=ft_resampledata(cfg, data);
data.sampleinfo=[origtrl(:,1), origtrl(:,2)];


%% CONVERT PREPROC STRUCTURE TO MNE
mne_epochs=nw_ftpreproc2mne(data);

%%
art_log =py.nw_standardautoreject.runautoreject(mne_epochs,py.str(fileinfo),py.str('grad'));

%%
bad_epoch_ind=nparray2mat(art_log.bad_epochs);

%% Make artefact definition

cfg             = [];
cfg.channel = 'MEG';
cfg.dataset     = fileinfo;
cfg.continuous  = 'yes';
% cfg.hpfilter='yes';
% cfg.hpfreq=1;
data = ft_preprocessing(cfg);

cfg=[];
cfg.inputfile=fileinfo;
data=obob_apply_ssp(cfg,data);

%%
cfg=[];
cfg.artfctdef.autoreject.artifact=origtrl(find(bad_epoch_ind==1),1:2);
ft_databrowser(cfg, data);

%%


