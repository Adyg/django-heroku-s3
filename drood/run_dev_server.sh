#!/bin/bash
cd /vagrant/{{project_name}}
printf "Installing requirements ...\n"
pip install -r requirements/local.txt

printf "Running collectstatic ...\n"
/usr/bin/python manage.py collectstatic --noinput --settings={{project_name}}.settings.local
printf "Starting server on the box's port 8001 ...\n"
/usr/bin/python manage.py runserver [::]:8001 --settings={{project_name}}.settings.local