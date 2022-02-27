#!/usr/bin/env python3
import argparse


def is_ready(logfile: str, min_peers: int) -> bool:
    """
    Checks log file for New outbound connections to have a minimum amount of peers
    :param logfile: Log file path to check
    :param min_peers: minimum amount of peers required
    :return: return boolean True if minimum amount of peers is found
    """
    with open(logfile, "r") as file:
        for line in file:
            if "New outbound peer connected:".upper() in line.upper() and f"PEER={min_peers}" in line.upper():
                return True

    return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Readiness Probe Overkill")
    parser.add_argument("--log", "-l", type=str, action="store", dest="log", required=True,
                        help='Path to log file to parse')
    parser.add_argument("--min-peers", type=str, action="store", dest="min_peers", default=3,
                        help="Minimum peers before ready")

    args = parser.parse_args()

    if is_ready(args.log, args.min_peers):
        print(f"{args.min_peers} Peers connected ready!")
        exit(0)
    else:
        print("Not enough peers not ready!")
        exit(1)
