#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=cpr_00000 -A cpr_00000
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N  cr2_usage
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e ${PBS_JOBNAME}.${PBS_JOBID}.e
#PBS -o ${PBS_JOBNAME}.${PBS_JOBID}.o
### Email notification: a=aborts, b=begins, e=ends, n=no notifications
#PBS -m ae -M first.last@cpr.ku.dk
### Number of nodes
#PBS -l nodes=1:ppn=1,mem=2gb
### Requesting timeformat is <days>:<hours>:<minutes>:<seconds>
#PBS -l walltime=00:00:05:00

# Load module and activate env
source ~/.bashrc
module load usage_script/2.0

conda activate slack_app

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

# Config
PRIVATE_HOOK_FILE=path/to/file
GROUP=cpr_00000
YEAR=$(date '+%Y')
MONTH=$(date '+%m')

# Load module and activate env
module load usage_script/2.0
conda activate slack_app

# usage to file with current date
usage_file=logs/usage_$(date '+%Y_%m_%d').txt
usage -a $GROUP -y $YEAR -m $MONTH > $usage_file

echo Dumped to: $usage_file

# Load Slack hook URL from private file
hook_url=`cat $PRIVATE_HOOK_FILE`

# Send usage message
python main.py --hook_url $hook_url --message_file $usage_file

