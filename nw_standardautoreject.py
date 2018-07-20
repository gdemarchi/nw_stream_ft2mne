
import numpy as np
import mne  # noqa
from mne.utils import check_random_state  # noqa

from autoreject import (AutoReject, set_matplotlib_defaults)  # noqa


<<<<<<< HEAD
def runautoreject(epochs, fiffile, senstype, n_interpolates = np.array([1, 4, 32]), consensus_percs = np.linspace(0, 1, 11)):

    check_random_state(42)  
    
    raw = mne.io.read_raw_fif(fiffile, preload=True)
    raw.pick_types(meg=True)
    raw.info['projs'] = list()
    epochs.info=raw.info #required since no channel infos
    del raw
      
    
    picks = mne.pick_types(epochs.info, meg=senstype, eeg=False, stim=False, eog=False, include=[], exclude=[])
=======
def runautoreject(epochs, fiffile, senstype, bads=[], resamplefs=128, n_interpolates = np.array([1, 4, 32]), consensus_percs = np.linspace(0, 1, 11)):

    check_random_state(42)  
    
    info = mne.io.read_info(fiffile)
    info['bads'] = list()
    info['projs'] = list()
    info['sfreq']=epochs.info['sfreq']
    
    info=mne.pick_info(info, epochs.picks)
    epochs.info=info #required since no channel infos
    epochs.pick_types(meg=True)
    
    del info
      
    
    picks = mne.pick_types(epochs.info, meg=senstype, eeg=False, stim=False, eog=False, include=[], exclude=bads)
>>>>>>> a4d67a273b6077e8b8f3930a0e3c8f62b551b4a5
    
    epochs.verbose=False
    epochs.baseline=(None, 0)
    epochs.preload=True
<<<<<<< HEAD
    epochs.detrend=0;
    
    
    ar = AutoReject(n_interpolates, consensus_percs, picks=picks, thresh_method='bayesian_optimization', random_state=42, verbose=False)
=======
    epochs.detrend=0
    
    epochs.resample(resamplefs)
    
    
    
    #ar = AutoReject(n_interpolates, consensus_percs, picks=picks, thresh_method='bayesian_optimization', random_state=42, verbose=False)
    ar = AutoReject(n_interpolates, consensus_percs, picks=picks, thresh_method='random_search', random_state=42, verbose=False)
>>>>>>> a4d67a273b6077e8b8f3930a0e3c8f62b551b4a5
  
    epochs, reject_log = ar.fit_transform(epochs, return_log=True)
    return reject_log


#test=runautoreject(epochs, fiffile, 'grad')


