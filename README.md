# CR2 Usage Bot

> Code base (initial commit) somehow ended up with me through someone else.  
> Use to make CPR SPA slack channel workspace a bit less serious by posting cat noises;)

## Setup Environment

Use the [slack-webhook-python](https://github.com/10mohi6/slack-webhook-python) package.

### Using conda Environment

Set up the environment using conda - you possibly have to install (Mini-) Anaconda.

```bash
# pwd is this repo
conda env create --file environment.yml
```

## Install SlackBot, Bot and Webhooks

1. Create a SlackApp and optionally set an App icon
2. Activate the Feature `Webhooks`

See [documentation](https://api.slack.com/messaging/webhooks)

## Execution

The python script to send the message can be executed for testing:

```bash
python main.py --hook_url URL --message_file path/to/message
```

Test with example

```
conda activate slack_app
hook=$(cat hook) # hook should contain weburl
python main.py --hook_url $hook --message_file logs/usage_2022_02_10.txt
```

### Delayed job submission

```bash
qsub jobscript.sh -a 02151010 -M your.mail@cpr.ku.dk -A cpr_00000 -W grouplist=cpr_00000 
```

should start the job on February 15th at 10.10am. So one could also specify the year as 
defined in the options of `-a` flag of `qsub`:

```     
-a date_time
          Available for qsub and qalter only.   

          Defines or redefines the time and date at which  a  job
          is   eligible  for  execution.  Date_time  conforms  to
          [[CC]]YY]MMDDhhmm[.SS], for  the  details,  please  see
          Date_time in:  sge_types(1).

          If this option is used with qsub or if a  corresponding
          value is specified in qmon then a parameter named a and
          the value in the format CCYYMMDDhhmm.SS will be  passed
          to  the defined JSV instances (see -jsv option below or
          find more information concerning JSV in jsv(1))
```

### Crontab

> Not supported by Computerome2. Users are not allowed to schedule cron jobs


The job script can be scheduled for regular submission to the cluster using the 
jobscript.

> Adapt `jobscript.sh` header for defaults and set PRIVATE_HOOK_FILE path to url file (with restricted access)

Add a cron job to `crontab -u henweb -e` your crontab. The `PATH` has to be adapted or 
you have to provide the fullpath to the jobscript.

```bash
# every Monday 10 after 10am
10 10 * * 1 qsub jobscript.sh -M your.mail@cpr.ku.dk -A cpr_00000 -W grouplist=cpr_00000
```


