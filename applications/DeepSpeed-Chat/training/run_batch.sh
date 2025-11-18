#!/bin/bash

if [ $# -ne 4 ] && [ $# -ne 5 ]; then
  echo "Usage: $0 <script_name> <hostfiles_folder_path> <output_folder_path> <timeout_seconds> <login node port (optional)>"
  exit 1
fi

script_name="$1"
hostfiles_folder_path="$2"
output_folder_path="$3"
timeout_seconds="$4"
input_login_node_port="${5:-22}"

if [ ! -d "$hostfiles_folder_path" ]; then
  echo "Folder '$hostfiles_folder_path' does not exist."
  exit 1
fi

mkdir -p $output_folder_path

# Iterate through hostfiles in the folder
for hostfile in "$hostfiles_folder_path"/hostfile_*; do
  if [ -f "$hostfile" ]; then
    # Extract the name without "hostfile_"
    filename=$(basename "$hostfile")
    job_name="${filename#hostfile_}"

    # Extract the login node and slots from the hostfile
    read -r login_node slots < "$hostfile"

    cmd_job="docker exec deepspeed-training bash -c 'cd ${PROJECT_PATH}/DeepSpeedExamples/applications/DeepSpeed-Chat/training && ./${script_name}.sh $job_name $hostfiles_folder_path/$filename $output_folder_path'"

    # Submit the job to the login node in parallel
    timeout ${timeout_seconds}s ssh -t "$login_node" "$cmd_job" &
  fi
done

echo "All jobs submitted."

# Wait for all background jobs to finish
wait

echo "All jobs finished."
