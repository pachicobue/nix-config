#!/usr/bin/env python3
import json
import sys

RTK = "@rtk@"

data = json.load(sys.stdin)
data["tool_input"]["command"] = RTK + " " + data["tool_input"]["command"]
json.dump(data, sys.stdout)
