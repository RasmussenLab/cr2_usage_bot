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

The python script to send the message:

```bash
python main.py --hook_url URL --message_file path/to/message
```
