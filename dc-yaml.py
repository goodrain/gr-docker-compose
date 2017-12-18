#!/usr/bin/env python
import sys
import argparse
from lya import AttrDict

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file', action='store', default='/etc/goodrain/docker-compose.yaml', help='yaml file, default is %(default)s')
    parser.add_argument('-u', '--update', action='store_true', help="update yaml config")
    parser.add_argument('-d', '--delete', action='store', help="delete a service")
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin)
    args = parser.parse_args()

    yaml_file = args.file
    cfg = AttrDict.from_yaml(yaml_file)

    if args.update:
        cfg.update_yaml(args.infile)
        with open(yaml_file, 'w') as f:
            cfg.dump(f)
    elif args.delete:
        service = args.delete
        if 'services' in cfg:
           if service in cfg.services:
               cfg.services.pop(service)
           if not cfg.services:
               cfg.pop('services')
           with open(yaml_file, 'w') as f:
               cfg.dump(f)
