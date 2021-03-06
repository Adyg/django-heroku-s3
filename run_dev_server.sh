#!/bin/bash
cd /vagrant_data
printf "Running migrations ...\n"
/usr/bin/python manage.py migrate

printf "Installing requirements ...\n"
pip install -r requirements/local.txt

printf "Running collectstatic ...\n"
/usr/bin/python manage.py collectstatic --noinput --settings={{project_name}}.settings.local
printf "Starting server on the box's port 8001 ...\n"
/usr/bin/python manage.py runserver [::]:8001 --settings={{project_name}}.settings.local