[![Build status](https://travis-ci.com/acidhelm/kq_scene_scoring_server.svg?branch=master)](https://travis-ci.com/acidhelm/kq_scene_scoring_server)
[![Coverage status](https://coveralls.io/repos/github/acidhelm/kq_scene_scoring_server/badge.svg?branch=master)](https://coveralls.io/github/acidhelm/kq_scene_scoring_server?branch=master)

# Killer Queen Scene-wide scoring

KQ Scene Scoring is a Rails app that implements the scene-wide scoring system
that will be used for [Bumble Bash 3](https://bumblebash.com/).  It watches
one or more Challonge brackets, calculates the score for each scene based on
the results of the brackets, and shows the scores in a kiosk-like view that can
be shown on a computer in the venue and in your stream.

You can run KQ Scene Scoring on your computer or on a hosting service like
[Heroku](https://heroku.com).  Setup instructions are in the
[INSTALL file](https://github.com/acidhelm/kq_scene_scoring_server/blob/master/INSTALL.md).
The rest of this readme assumes that you've followed those instructions.

# Set up your Challonge brackets

KQ Scene Scoring reads your tournament's Challonge brackets to see how far each
team has progressed.  You can use one bracket with all the teams, or a wild card
bracket followed by a knockout bracket.  Brackets for pool or group play do not
result in knockouts, so those brackets are not used for scoring.

If you have multiple brackets in your tournament, you can set up just the
first bracket, then fill in the other brackets after the results from the first
bracket are known.  KQ Scene Scoring will start reading the later brackets once
they are marked as underway on Challonge.

Each bracket must contain a config file that holds the list of teams, their players,
and the scene that each player represents.  The instructions for making this
file are in [the killer_queen_scene_scoring gem](https://github.com/acidhelm/killer_queen_scene_scoring/blob/master/README.md#the-config-file).

Attach the config file to the first match in each bracket.

# Calculate scores for a tournament

If you want to try out KQ Scene Scoring before you set up your own tournament,
you can use [this copy of the KQ 25 brackets](https://challonge.com/clonekqxxvwc).

Open [the login page](http://localhost:3000/login) in a browser and enter the
user name and password for your KQ Scene Scoring account.  After you log in, you
will see the list of tournaments that KQ Scene Scoring is calculating scores for.

Click _Calculate scores for a tournament_ to start calculating scores for a new tournament.
Enter a title and the alphanumeric ID of the Challonge bracket.  The alphanumeric
ID is the part of the URL after `challonge.com`, so for the sample bracket,
it's `clonekqxxvwc`.  If the bracket is owned by an organization with a
subdomain on challonge.com, enter the subdomain as well.

Click _Create Tournament_ to save the tournament.  The browser will show you
the tournament's page.  Click _Calculate scores now_, and if everything is set
up correctly, the page will show the list of teams and their scores.

# Update the scores

To manually re-read your brackets and recalculate the scores, click _Calculate
scores now_.  You only need to do this at the end of a match, after the Challonge
bracket has been updated with the match's final score.

If your server has a scheduling component, you can have it run a Rake task
periodically to automatically recalculate scores.  The command is:

```sh
rake kq:recalc[ALPHANUMERIC_ID]
```

For example, to recalculate the scores for the sample tournament:

```sh
rake kq:recalc[clonekqxxvwc]
```

If you're using a free Heroku account, you can add the free Heroku Scheduler
add-on to your app, however, it is limited to running a task every 10 minutes.

# Kiosk mode for spectators

Browse to the `/kiosk/ALPHANUMERIC_ID` URL to show the kiosk view.  This is
suitable for showing on a screen in your venue, and in your stream.

The kiosk view automatically refreshes itself.  You can set how often it refreshes
with the `Rails.configuration.kiosk_refresh_time` config variable.  You can also
override that value by passing the time in seconds in the URL, for example
`/kiosk/ALPHANUMERIC_ID?t=30`.
