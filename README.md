#Deploying Postgres to Heroku
---

We're going to push our sample app, Gifster, to Heroku.

###Create A Heroku App
---

Login to Heroku, create a new app, and paste the Command Line snippet to add the Heroku remote to your app:

```
$ git init
$ heroku git:remote -a wdi-gifster-prep
```

##Prepare Rails
---

###Add Gems

We need to add a Gem to our app to handle the asset pipeline:

```
# rest of the Gemfile

gem 'rails_12factor', group: :production
```

...and don't forget to `$ bundle install`

We should also specify our Ruby version at the top of our Gemfile, right below the line that specifies rubygems.org as our Gem source:

```
source 'https://rubygems.org'

ruby '2.1.2'
```

###Deploy to Heroku

Add, commit, push!

```
$ git add .
$ git commit -am "make it better"
$ git push heroku master
```

Don't forget to migrate your Heroku DB after deploying (and anytime you make DB changes):

```
$ heroku run rake db:migrate
```

##Other Options
---

###Add A Procfile

A [Procfile](https://devcenter.heroku.com/articles/procfile) (or Process File) tells Heroku what Unix commands to run internally to start our server. For now, we will get in the habit or creating a basic Procfile.

From the root of your app:

```
$ touch Procfile
```

Inside that Procfile, add the basic start command for a rails server:

```
web: bundle exec rails server -p $PORT
```

This line runs the rails server command on every new Web Dyno we use on Heroku. The `-p` flag specifies what post the rails server should listen to and Heroku provides the `$PORT` variable.

The Procfile is optional right now, but required if we use a different webserver or use background workers (like we will tomorrow :D).

###Swap Out Webrick for Passenger

We can switch our web server for performance improvements. The two main options for Heroku are [Unicorn](https://github.com/defunkt/unicorn) and [Phusion Passenger](https://github.com/phusion/passenger).

While Heroku supports Unicorn, I prefer Passenger because it is easier to setup and I think the logging and configuration is better. We will install Passenger today. Honestly, the differences are immaterial at this point.

Add the passenger gem to your Gemfile:

```
# bottom of Gemfile

gem "passenger"
```

...then `$ bundle install`.

After that, update your Procfile to use Passenger. Replace the file contents with this:

```
web: bundle exec passenger start -p $PORT --max-pool-size 3
```

You can leave the `--max-pool-size` on 3 until you understand when to change it. 

Other Passenger options and explanations for each (and more details on using Passenger with Heroku) can be found here: [phusion/passenger-ruby-heroku-demo](https://github.com/phusion/passenger-ruby-heroku-demo).

###Managing Environmental Variables

You can list all your ENV variables (which Heroku calls config vars) with this command:

```
$ heroku config
```

Here are some additional commands:

```
$ heroku config:set NAME_OF_VAR='value' # add a new var or change and existing one
$ heroku config:unset NAME_OF_VAR # delete a var you already set
```

But, honestly, the best way to manage your ENV variables is through [Figaro](https://github.com/laserlemon/figaro). You can see our previous lesson from Project 1 for details on setting up Figaro. The main command to "sync" your ENV variables with Heroku is:

```
$ figaro heroku:set -e your_environment
```

Boom! Done.

###Other Great Addons

1. *Papertrail* is amazing for handling logging in Production. Adding it is simple from the web... and even simpler using the Heroku CLI:

```
$ heroku addons:add papertrail
```

Then open it with:

```
$ heroku addons:open papertrail
```

2. *Heroku Scheduler* is awesome for running recurring rake tasks (did you know you can write custom rake tasks?).

```
$ heroku addons:add scheduler
```

Setup here: [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler)

###That's It!

Good job!