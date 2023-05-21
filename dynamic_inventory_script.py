#!/usr/bin/env python

import json
import os


def dynamic_inventory():
    with open('inventory.json') as f:
        data = json.load(f)

    inventory = {
        'app': {
            'hosts': data['app_instance_ips']['value'],
            'vars': {}
        },
        'bastion': {
            'hosts': [data['bastion_host_ip']['value']],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }

    return inventory


print(json.dumps(dynamic_inventory()))
