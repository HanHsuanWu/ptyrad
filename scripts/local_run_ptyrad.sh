#!/bin/bash

# This shell script is designed to run multiple PtyRAD jobs locally using N GPUs
# Go to the `ptyrad/` root directory and call this script with `bash ./scripts/local_run_ptyrad.sh`
# Optional arguments:
#   -n: number of GPUs (default: 4)
#   -p: path to params file (default: params/PSO_reconstruct.yml)
# Example: `bash ./scripts/local_run_ptyrad.sh -n 2 -p params/custom_params.yml`

# Define default parameters
N=4
PARAMS_PATH=""

# Parse the command-line arguments
while getopts n:p: flag
do
    case "${flag}" in
        n) N=${OPTARG};;
        p) PARAMS_PATH=${OPTARG};;
    esac
done

# Run jobs on each GPU
for i in $(seq 0 $((N-1))); do
    echo "Starting job on GPU $i with params: ${PARAMS_PATH}"
    ptyrad run --params_path "${PARAMS_PATH}" --gpuid $i --jobid $i 2>&1 &
    if [ "$i" -eq 0 ]; then
        sleep 60  # Longer pause after first job
    else
        sleep 10  # Normal pause for subsequent jobs
    fi
done

echo "All jobs submitted!" 