import os
import pathlib
import random
import time
import yaml

from datetime import datetime, timedelta
from croniter import croniter
import pandas as pd
from slack_webhook import Slack
from src import parser

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

    usage = parser.parse_usage_output(args.message_file)
    _total = {}
    for key, value in zip(usage.headers, usage.total[1:]):
        try:
            _total[key.strip()] = int(value)
        except ValueError:
            _total[key.strip()] = float(value)
    usage.data[usage.total[0].strip(':')] = _total

    storage_gb = int(usage.storage.split(':')[1].split()[0])

    with open('cr2_prices.yaml') as f:
        prices = yaml.safe_load(f)
    df = pd.DataFrame(usage.data).T

    TB_GB = 1024 # binary format, 1000 in decimal format
    msg += (f"\n\nStorage costs: {prices['storage_TB']*storage_gb/TB_GB:,.2f} DKK (per month)"
               "\n               (maximum usage per month is used for prizing)")

    
    costs = df[usage.headers[0]] * prices['thin_node'] / prices['thin_node_cpus']
    costs = costs.to_frame('thin nodes')
    costs['fat nodes'] = df[usage.headers[2]] * prices['fat_node'] / prices['fat_node_cpus']
    costs['gpu nodes'] = df[usage.headers[4]] * prices['gpu_node'] / prices['gpu_node_cpus']
    costs['total'] = costs.sum(axis=1)
    costs.columns.name = 'in DKK:'
    costs.index.name = 'user:'

    msg += f"\n\nAll compute costs:"
    msg += f"\n```\n{costs.to_string(float_format='{:,.1f} DKK'.format)}\n```"

    post_message(args.hook_url, msg=msg)
