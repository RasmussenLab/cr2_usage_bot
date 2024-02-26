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
# echo Working directory is $PBS_O_WORKDIR
# cd $PBS_O_WORKDIR

# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

### Config
PRIVATE_HOOK_FILE=~/.hook
# Load Slack hook URL from private file
hook_url=$(<$PRIVATE_HOOK_FILE)
# Mails does not need to exit or can be empty
MAILS_FILE=mails.txt 
MAILS=$(<$MAILS_FILE)
# Make group an environment variable
GROUP_FILE=group.txt
GROUP=$(<$GROUP_FILE)
YEAR=$(date '+%Y')
MONTH=$(expr $(date '+%m') + 0)

# usage to file with current date
usage_file=logs/usage_$(date '+%Y_%m_%d').txt
usage -a $GROUP -y $YEAR -m $MONTH > $usage_file

echo Dumped to: $usage_file
echo Mails: "$MAILS"

# Send usage message
python main.py --hook_url $hook_url --message_file $usage_file
exit_code=$?

if [ $exit_code -eq 0 ] && [ -n "$MAILS" ]; then
    sendmail $MAILS < logs/usage_$(date '+%Y_%m_%d')_msg_send.txt
else
    echo "no mail sent."
fi

