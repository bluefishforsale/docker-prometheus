#!/usr/bin/python3

import time, socket, json
import argparse
from datetime import datetime
from prometheus_client import start_http_server, Summary, Gauge
from subprocess import PIPE, run

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--interval", type=int, default=300,
                    help="speedtest check interval")
parser.add_argument("-p", "--port", type=int, default=9119,
                    help="port the http /metrics server will bind to")
parser.add_argument("-s", "--servers", default=[], nargs='+',
                    help="list of server ids separated by spaces")
args = parser.parse_args()

servers = args.servers
test_interval = args.interval # initiate speed test every 60 seconds

#g_ping = Gauge('speedtest_ping', 'Ping Time', ['name', 'server_id', 'server_name', 'server_cc', 'server_sponsor'])
gauge_speedtest = Gauge('speedtest_cli', 'Speedtest Run', ['name', 'server_id', 'server_name', 'server_cc', 'server_sponsor', 'server_distance'])

def process_request(t):
  round_start = time.time()
  for server in servers:
    start = time.time()
    command = f'speedtest-cli --json --server {server}'.split(' ')
    results = run(command, stdout=PIPE, stderr=PIPE, universal_newlines=True)
    results_dict = json.loads(results.stdout)
    print(datetime.now().isoformat(),results_dict)

    server_id = results_dict["server"]["id"]
    server_name=results_dict["server"]["name"]
    server_cc=results_dict["server"]["cc"]
    server_sponsor=results_dict["server"]["sponsor"]
    server_distance=results_dict["server"]["d"]
    ping = results_dict["ping"]
    upload = results_dict["upload"]
    download = results_dict["download"]

    gauge_speedtest.labels(name='ping', server_id=server_id, server_name=server_name, server_sponsor=server_sponsor, server_cc=server_cc, server_distance=server_distance).set(ping)
    gauge_speedtest.labels(name='upload', server_id=server_id, server_name=server_name, server_sponsor=server_sponsor, server_cc=server_cc, server_distance=server_distance).set(upload)
    gauge_speedtest.labels(name='download', server_id=server_id, server_name=server_name, server_sponsor=server_sponsor, server_cc=server_cc, server_distance=server_distance).set(download)

    iter_t = (time.time() - start)
    time.sleep(t / (len(servers)*iter_t))

  round_t = time.time() - round_start
  time.sleep(t - round_t)

if __name__ == '__main__':

  # Start up the server to expose the metrics.
  start_http_server(args.port)
  # Generate some requests.
  while True:
    try:
      process_request(args.interval)
    except TypeError:
      print("TypeError returned from speedtest server")
    except socket.timeout:
      print("socket.timeout returned from speedtest server")

