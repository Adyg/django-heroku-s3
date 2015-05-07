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

1. Start a new django project with: 
```
django-admin startproject --template=https://github.com/Adyg/django-heroku-s3/archive/master.zip --extension sh,py,pp --name Vagrantfile,Procfile projectname
```
2. Start up the vagrant box with (this might take a while):
```
cd projectname/vagrant && vagrant up
```
3. SSH into the vagrant box with `vagrant ssh`. The project will be available under `/vagrant`. A postgresql database will be automatically created (the username/pass are the [projectname])
4. Use `heroku auth:login` to authenticate with Heroku

Amazon S3
---------
1. Create an [Amazon S3 bucket ](https://console.aws.amazon.com/s3)
2. After creating the bucket, under it's Properties > Permissions section, update it's  CORS configuration to something along the lines of:
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
3. Create a new [IAM User](https://console.aws.amazon.com/iam/home) (remember to download it's access key and secret access key)
4. Go to the new IAM User's page and attach a new policy (e.g AmazonS3FullAccess) to allow access to S3

Heroku
------
1. Create an app on [Heroku](https://heroku.com/) (aim for it's name to be the same as the Django project name, otherwise customization to the bash scripts will be needed)
2. Inside the vagrant box, go to the `/vagrant/[projectname]` dir and run `heroku git:remote -a [projectname]`
3. Inside the vagrant box, run the `./deploy_heroku.sh` script to push the project to Heroku
4. Update the project Heroku settings related to Amazon S3 (access keys and bucket name) (either via heroku toolbelt or via the Heroku web UI)
5. Add a new Heroku setting: `DISABLE_COLLECTSTATIC` and set it's value to `1`

Note: the static assets will not be pushed to Heroku (the included .slugignore file prevents it). Instead, they should be published to S3 via the included `./publish_assets.sh` (from inside the vagrant box). The reason is to reduce the Heroku slug size as much as possible.

Dev Server
----------
The Django development server can be started inside the Vagrant box by using the `/vagrant/[projectname]/run_dev_server.sh` script. The development server will be available on the host machine at http://localhost:9171 (you can change the port in the Vagrantfile)
