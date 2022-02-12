import os
import pathlib
import random
import time

from datetime import datetime, timedelta
from croniter import croniter

from slack_webhook import Slack

def post_message(slack_webhook:str, msg:str):
    slack = Slack(url=slack_webhook)
    slack.post(text=msg)


if __name__ == "__main__":
    import argparse
    argparser = argparse.ArgumentParser(prog="python main.py",
                                        description='Message Computerome2 usage to Slack Channel.')
    argparser.add_argument('--hook_url', required=False, 
                           help="Slack Endpoint to use for posting. Not needed if "
                           "the environment varialbe 'SLACK_WEBHOOK' is set.")
    argparser.add_argument('--message_file', required=True,
                            help='Filepath to text file containing message.')
    args = argparser.parse_args()
    
    try:
        if not args.hook_url: 
            args.hook_url = os.environ["SLACK_WEBHOOK"]
    except KeyError:
        raise EnvironmentError('Missing SLACK_WEBHOOK environment variable. Please set. See README.')
    
    with open(pathlib.Path(args.message_file)) as f:
        msg = f.read()
    msg = f"```\n{msg}```\n"
    post_message(args.hook_url, msg=msg)
