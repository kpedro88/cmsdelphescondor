
# Configurable
TAG='16Mar21'
OUTDIR="/eos/user/a/aalbert/mc/delphes"

GRIDPACK=$(readlink -e $(ls -1ctr *tar.gz | head -1))

# Make proxy accessible from AFS home
# This way the condor jobs can use it
PROXY_TMP=$(voms-proxy-info -p)
PROXY=${HOME}/$(basename ${PROXY_TMP})
cp ${PROXY_TMP} ${PROXY}

# Will submit jobs for all data sets in list
for DATASET in $(cat datasets.txt); do

    if [[ "$DATASET"=*"RunIIFall17" ]]; then 
        YEAR=2017
    elif [[ "$DATASET"=*"RunIIAutumn18" ]]; then
        YEAR=2018
    else 
        echo "Are you sure your data set name is parsed correctly? Name: ${DATASET}"
        exit 1
    fi

    # Delphes need MiniAOD or bigger inputs
    if [[ "$DATASET"=*"NANOAODSIM" ]]; then 
        DATASET=$(dasgoclient --query="parent dataset=${DATASET}" | sed "s|[ \t]*$||g;s|^[ \t]*||g;")
        echo "Input is NANO, so I will run on parent dataset ${DATASET}"
    fi

    # Working directory, short sample nickname
    SHORT="$(echo $DATASET | sed 's|/Run.*||g;s|/||g')_${YEAR}"
    WDIR="wdir/${TAG}/${SHORT}"
    mkdir -p $WDIR

    # One dataset = one condor job = one file list
    # May want to set up a splitting scheme in case
    # the datasets are large
    dasgoclient --query="file dataset=${DATASET}" > $WDIR/files.txt

    # Done
    condor_submit submit.jdl \
                 -append "dataset=${DATASET}" \
                 -append "short=${SHORT}"     \
                 -append "outdir=${OUTDIR}"   \
                 -append "tag=${TAG}"         \
                 -append "proxy=${PROXY}"     \
                 -append "gridpack=${GRIDPACK}"     \
                 -append "transfer_input_files = $WDIR/files.txt" \
                 -batch-name delphes_${TAG}_${SHORT}
done