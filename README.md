# CMSSW + Delphes + Condor

This is a simple setup to run Delphes over existing CMS data sets using the htcondor system at lxbatch.

## Usage

Usage is very simple. In a first step, we set up CMSSW, download and compile Delphes and wrap the compiled Delphes installation into a gridpack. You only have to do this once:

```bash
./initial_setup.sh
```

In a second step, you write all the data sets you want to run over into a list

```bash
$ head -2 datasets.txt
# /ADDMonoJet_MD_10_d_2_TuneCUETP8M1_13TeV_pythia8/RunIIFall17NanoAODv7-PU2017_12Apr2018_Nano02Apr2020_102X_mc2017_realistic_v8-v1/NANOAODSIM
# /ADDMonoJet_MD_10_d_3_TuneCUETP8M1_13TeV_pythia8/RunIIFall17NanoAODv7-PU2017_12Apr2018_Nano02Apr2020_102X_mc2017_realistic_v8-v1/NANOAODSIM
```

If you put NanoAOD samples into the list, the submission script will figure out the miniaod parent data set and submit jobs to run over that parent data set.



Finally, we submit the condor jobs to run over this list of data sets. The submission is handled by ```run_delphes.sh```, which has a few configurable parameters, notably an identifier for this round of running, and an output directory:

```bash
$ head -5 run_delphes.sh
# TAG='16Mar21'
# OUTDIR="/eos/user/a/aalbert/mc/delphes"
```

Make sure to change these parameters according to your preferences.
