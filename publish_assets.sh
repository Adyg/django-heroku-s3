cd {{project_name}} && \
env SECRET_KEY=`heroku config:get SECRET_KEY --app={{project_name}}` \
    AWS_SECRET_ACCESS_KEY=`heroku config:get AWS_SECRET_ACCESS_KEY --app={{project_name}}` \
    AWS_ACCESS_KEY_ID=`heroku config:get AWS_ACCESS_KEY_ID --app={{project_name}}` \
    AWS_STORAGE_BUCKET_NAME=`heroku config:get AWS_STORAGE_BUCKET_NAME --app={{project_name}}` \
    STATIC_ROOT='/vagrant/{{project_name}}/assets' \
    /usr/bin/python manage.py collectstatic --settings={{project_name}}.settings.heroku
cd ..