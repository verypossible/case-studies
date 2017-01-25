# Phoenix Example Chat App

## Step 1 - Install

First you'll need:
* `mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez`

Then we'll fire up a new Phoenix app with `mix phoenix.new phoenix_chat`. Allow Phoenix to build dependencies during this step or else you'll have to do it manually later. Phoenix comes with built in websocket support but we will need a DB*.

*Phoenix likes having at Postgresql instance even if we won't be using it in this example. If you already have Postgresql installed and configured and running then you can skip this part:

* `mkdir -p db/postgres`
* `initdb db/postgres -U postgres`
* `pg_ctl -D db/postgres/ start`
* `mix ecto.create && mix ecto.migrate`

Now we can fire up our app with: `mix phoenix.start`.

## Step 2 - Create Chat Page


## Step 3 - Sending and Receiving Messages
