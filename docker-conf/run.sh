#!/bin/bash

# install requirements
pip install -r /var/www/project/repo/dev/requirements.txt

# run custom commands
python /var/www/project/repo/dev/manage.py collectstatic --noinput

# start supervisor
/usr/bin/supervisord -n
