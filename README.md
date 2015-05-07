# django-heroku-s3
Django 1.8 project template with built-in [Heroku](https://heroku.com/), [Vagrant](https://www.vagrantup.com/) and [Amazon S3](http://aws.amazon.com/s3/) support.

What you will end up with
-------------------------

1. Django project skeleton
2. Settings for running the project on [Heroku](https://heroku.com/), using [waitress](http://waitress.readthedocs.org/en/latest/) and [S3](http://aws.amazon.com/s3) for static files.
3. Custom bash scripts for pushing to Heroku, publishing assets to S3 and running the dev server.
4. Vagrant box setup with basic development environment (postgresql, pip, heroku toolbelt, git)

Prerequisites
-------------

1. A [Heroku](https://heroku.com/) account
2. An [Amazon AWS](http://aws.amazon.com) account
3. [Vagrant](http://www.vagrantup.com/downloads) installed


Basic Usage
-----------

- Start a new django project with (make sure to change projectname to the actual project name): `$ django-admin startproject --template=https://github.com/Adyg/django-heroku-s3/archive/master.zip --extension sh,py,pp --name Vagrantfile,Procfile projectname`

- Start up the vagrant box with (this might take a while): `$ cd projectname/vagrant && vagrant up`

- SSH into the vagrant box with `$ vagrant ssh`. The project will be available under `/vagrant`. A postgresql database will be automatically created (the username/pass are the [projectname])

- Use `$ heroku auth:login` to authenticate with Heroku

Amazon S3
---------
- Create an [Amazon S3 bucket ](https://console.aws.amazon.com/s3)
- After creating the bucket, under it's Properties > Permissions section, update it's  CORS configuration to something along the lines of:
```
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>PUT</AllowedMethod>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```
- Create a new [IAM User](https://console.aws.amazon.com/iam/home) (remember to download it's access key and secret access key)
- Go to the new IAM User's page and attach a new policy (e.g AmazonS3FullAccess) to allow access to S3

Heroku
------
- Create an app on [Heroku](https://heroku.com/) (aim for it's name to be the same as the Django project name, otherwise customization to the bash scripts will be needed)
- Inside the vagrant box, go to the `/vagrant/[projectname]` dir and run `$ heroku git:remote -a [projectname]`
- Inside the vagrant box, run the `$ ./deploy_heroku.sh` script to push the project to Heroku
- Update the project Heroku settings (can be run inside the vagrant box, under the /vagrant/projectname dir):
```
$ heroku config:set DJANGO_SETTINGS_MODULE=projectname.settings.heroku
$ heroku config:set AWS_STORAGE_BUCKET_NAME=[S3 bucket name]
$ heroku config:set AWS_ACCESS_KEY_ID=[S3 access key]
$ heroku config:set AWS_SECRET_ACCESS_KEY=[S3 secret access key]
$ heroku config:set SECRET_KEY=random_string
$ heroku config:set DISABLE_COLLECTSTATIC=1
 ```
Note: the static assets will not be pushed to Heroku (the included .slugignore file prevents it). Instead, they should be published to S3 via the included `$ ./publish_assets.sh` (from inside the vagrant box). The reason is to reduce the Heroku slug size as much as possible.

Dev Server
----------
The Django development server can be started inside the Vagrant box by using the `$ /vagrant/[projectname]/run_dev_server.sh` script. The development server will be available on the host machine at http://localhost:9171 (you can change the port in the Vagrantfile)
