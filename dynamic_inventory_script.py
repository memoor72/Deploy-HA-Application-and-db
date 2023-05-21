#!/usr/bin/env python

import json
import os


def dynamic_inventory():
    with open('inventory.json') as f:
        data = json.load(f)

    inventory = {
        'app': {
            'hosts': data,  # data is already a list of IP addresses
            'vars': {}
        },
       
        '_meta': {
            'hostvars': {}
        }
    }

    return inventory


print(json.dumps(dynamic_inventory()))
