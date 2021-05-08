#!/bin/bash

# CMSSW
CMSSW_VERSION=CMSSW_10_6_19
source /cvmfs/cms.cern.ch/cmsset_default.sh
scramv1 project CMSSW ${CMSSW_VERSION}
pushd ${CMSSW_VERSION}/src
eval `scramv1 runtime -sh`
popd

# Delphes
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
wget http://cp3.irmp.ucl.ac.be/downloads/Delphes-3.4.2.tar.gz
tar -zxf Delphes-3.4.2.tar.gz
cd Delphes-3.4.2
cp ../delphes_card_CMS.tcl cards
sed -i '/^CXXFLAGS/ s/c++0x/c++17/' Makefile
make -j 4

# Gridpack
tar czf gridpack_delphes_3.4.2.tgz Delphes-3.4.2