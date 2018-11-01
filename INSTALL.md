# Running the KQ Scene Scoring server on a local computer

If you want to run KQ Scene Scoring on your computer, or do development on it,
follow the instructions in this section.  Instructions for installing it on Heroku
are provided later on.

Clone the repo and set up gems and the initial database:

```sh
$ git clone https://github.com/acidhelm/kq_scene_scoring_server.git
$ cd kq_scene_scoring_server
$ bundle install --path vendor/bundle
$ bin/rails db:schema:load
```

If you don't want to set up a GitHub account, you can also 
[download the source code](https://github.com/acidhelm/kq_scene_scoring_server/archive/master.zip)
and unzip it.

There is one configuration key that you need to set, but you'll only have
to do this once.  In the `kq_scene_scoring_server` directory, run:

```sh
$ ruby -e 'require "securerandom"; puts "ATTR_ENCRYPTED_KEY=#{SecureRandom.hex 16}"' > .env
```

That creates an encryption key that only works on your computer.  You should not
copy that key to any other computer; generate a new key if you start using
KQ Scene Scoring on another computer.

Then run the Rails server:

```sh
$ bin/rails server
```

## Create your KQ Scene Scoring account

KQ Scene Scoring accounts are used to hold the list of tournaments that you are
scoring and your Challonge API key.  You can find your API key in
[your account settings](https://challonge.com/settings/developer).

There is no UI for creating accounts, but you can make an account in the Rails
console.  Run the console:

```sh
$ bin/rails console
```

Then run this command to make an account:

```ruby
> User.create user_name: "A user name",
              api_key: "Your API key",
              password: "A password"
```

The user name and password that you set here are used to log in to KQ Scene
Scoring.  They do not have to be the same as your Challonge user name and password.

# Running KQ Scene Scoring on Heroku

KQ Scene Scoring is ready to deploy to a Heroku app, so that tournament scores can
be viewed by anyone.  These instructions assume that you have created accounts
on Heroku and GitHub.  KQ Scene Scoring doesn't require any paid components, so you
can use a free Heroku account.

## Deploying to Heroku using the command line

To use command-line tools, you must install the
[Heroku CLI app](https://devcenter.heroku.com/articles/heroku-cli).  After you
clone the repo, run:

```sh
$ heroku create <heroku app name>
```

For example, run this command:

```sh
$ heroku create my-kq-scene-scoring
```

to create <tt>my-kq-scene-scoring.herokuapp.com</tt>.  `heroku create` also
creates a git remote with the default name of "heroku".  Then, push
the app to that remote:

```sh
$ git push heroku master
```

You'll see a bunch of output as the app is compiled and installed.  Next,
create the environment variable `ATTR_ENCRYPTED_KEY`.  Instead of creating an
`.env` file, you add the variable to your Heroku app's configuration:

```sh
$ key=`ruby -e 'require "securerandom"; puts SecureRandom.hex(16)'`
$ heroku config:set ATTR_ENCRYPTED_KEY=$key
```

Next, set up the database:

```sh
$ heroku run rails db:migrate
```

Run the Rails console:

```sh
$ heroku console
```

and create a KQ Scene Scoring account as described earlier.  You can then access
KQ Scene Scoring at https://your-app-name.herokuapp.com.

## Deploying to Heroku using a Web browser

On GitHub, fork the KQ Scene Scoring repo to make a copy of it in your GitHub account.
On your Heroku dashboard, click _New_&rarr;_Create new app_, and give it a name.
Click that app in the dashboard, then click _Deploy_.  In the _Deployment method_
section, click _GitHub_, then _Connect to GitHub_.  That will show a popup window
from GitHub asking you to allow Heroku to access your GitHub account.  Click the
_Authorize_ button.

The _Connect to GitHub_ page will now show your GitHub account and a search
field.  Enter the name of your forked repo and click _Search_.  Click _Connect_
next to your repo in the search results.

The page will have a new _Manual deploy_ section at the bottom.  Click _Deploy
branch_ to deploy the <tt>master</tt> branch to your Heroku app.  Once the
deployment is done, the page will say "Your app was successfully deployed." <tt>\o/</tt>

Click _Settings_, then in the top-right corner, click _More_&rarr;_Run console_.
Type "bash", then click _Run_.  Run the Ruby command to generate an encryption key
as described earlier, and copy the key.  Close the console.

Click _Reveal config vars_ and create an <tt>ATTR_ENCRYPTED_KEY</tt> variable.
Use the encryption key that you just created as the value for that variable.
Create <tt>SLACK_TOKEN</tt> too if you want to send Slack notifications.

Click _More_&rarr;_Run console_ again, and enter "rails db:migrate". When that
finishes, click _Run another command_ at the bottom of the window, and enter
"console".  Create a KQ Scene Scoring account as described earlier.  You can then
access KQ Scene Scoring at https://your-app-name.herokuapp.com.
