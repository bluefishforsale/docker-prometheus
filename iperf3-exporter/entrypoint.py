#!/usr/bin/python3

import time, socket, json
import argparse
from datetime import datetime
from prometheus_client import start_http_server, Summary, Gauge
from subprocess import PIPE, run

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--interval", type=int, default=30,
                    help="check interval")
parser.add_argument("-o", "--omit_secs", type=int, default=1,
                    help="begin secs of data to omit from stats")
parser.add_argument("-t", "--test_time", type=int, default=10,
                    help="how long for each test to run")
parser.add_argument("-P", "--parallel", type=int, default=1,
                    help="number of simultaneous streams per test")
parser.add_argument("-s", "--servers", default=[], nargs='+',
        help="list of servers<:port> separated by spaces. Port defaults to 5201 if not specified")
args = parser.parse_args()

interval = args.interval
omit = args.omit_secs
test_time = args.test_time
parallel = args.parallel
servers = args.servers

gauge_iperf = Gauge('iperf3', 'iPerf3 metrics', ['name',])

def process_request(t):
  round_start = time.time()
  for server in servers:
    parts = server.split(':')
    if len(parts) >1:
        server = parts[0]
        port=int(parts[1])
    else:
        port=5201
    start = time.time()
    command = f'iperf3 -J -4 -O {omit} -t {time_secs} -P {parallel} -C {server} -p {port}'.split(' ')
    results = run(command, stdout=PIPE, stderr=PIPE, universal_newlines=True)
    results_dict = json.loads(results.stdout)
    print(datetime.now().isoformat(),results_dict)

    _protocol=results_dict["start"]["test_start"]["protocol"]
    _blksize=results_dict["start"]["test_start"]["blksize"]
    _host=results_dict["start"]["connecting_to"]["host"]
    _port=results_dict["start"]["connecting_to"]["port"]

    _download=results_dict["end"]["sum_received"]["bits_per_second"]
    _congestion=results_dict["end"]["sender_tcp_congestion"]

    gauge_speedtest.labels(name='ping',     remote=_host, ).set(_ping)
    gauge_speedtest.labels(name='download', remote=_host, ).set(_download)

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

