#!/bin/bash

# CMSSW
CMSSW_VERSION=CMSSW_10_6_19
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ ! -d $CMSSW_VERSION ]; then
	scramv1 project CMSSW ${CMSSW_VERSION}
fi
pushd ${CMSSW_VERSION}/src
eval `scramv1 runtime -sh`
popd

# Delphes
DELPHES_VERSION=Delphes-3.4.2
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
if [ ! -d $DELPHES_VERSION ]; then
	git clone https://github.com/kpedro88/delphes -b 3.4.2_svj $DELPHES_VERSION
fi
pushd $DELPHES_VERSION
cp ../delphes_card_CMS.tcl cards
sed -i '/^CXXFLAGS/ s/c++0x/c++17/' Makefile
make -j 4
popd

# Gridpack
tar --exclude-vcs -czf gridpack_delphes_3.4.2.tgz $DELPHES_VERSION
