#!/bin/bash
GRIDPACK=${1}
DATASET=${2}
OUTDIR=${3}
PROXY=${4}
set -x
export X509_USER_PROXY="${PROXY}"

# Try to create output directory
# at the start so that we fail early
# in case of access problems
mkdir -p "${OUTDIR}" || exit $?



# CMSSW setup from CVMFS
CMSSW_RELEASE_BASE="/cvmfs/cms.cern.ch/slc7_amd64_gcc820/cms/cmssw/CMSSW_10_6_19"
source "/cvmfs/cms.cern.ch/cmsset_default.sh"
pushd "${CMSSW_RELEASE_BASE}/src";
eval `scramv1 runtime -sh`
popd


tar xf "${GRIDPACK}"
DELPHDIR=$(readlink -e ./Delphes*/)
FILELIST=$(readlink -e "./files.txt")
SHORT="$(echo ${DATASET} | sed 's|/Run.*||g;s|/||g')"

# Run and move output to target directory
pushd "${DELPHDIR}"
time ./DelphesCMSFWLite cards/delphes_card_CMS.tcl \
                        delphes_${SHORT}.root \
                        $(cat $FILELIST | sed 's|^|root://cms-xrd-global.cern.ch//|' | xargs)
mv delphes_${SHORT}.root ${OUTDIR}
popd

# Cleanup
rm -r "${DELPHDIR}"
rm "${FILELIST}"
