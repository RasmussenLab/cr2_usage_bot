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

The job script can be scheduled for regular submission to the cluster using the 
jobscript.

> Adapt `jobscript.sh` header for defaults and set PRIVATE_HOOK_FILE path to url file (with restricted access)

```bash
# every Monday 10 after 10am
10 10 * * 1 qsub jobscript.sh -M your.mail@cpr.ku.dk -A cpr_00000 -W grouplist=cpr_00000
```
