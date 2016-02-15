# Hubot Factoids

A factoids implementation for Hubot, inspired by [oftn-bot](https://github.com/oftn/oftn-bot).

[![Build Status](https://travis-ci.org/hubot-scripts/hubot-factoids.svg)](https://travis-ci.org/hubot-scripts/hubot-factoids)

## Features

* Supports [hubot-auth](https://github.com/hubot-scripts/hubot-auth).
* @mention support: factoid value will be directed at mentioned user.
* Customizable prefix
* Aliases: point a factoid at the value of another factoid.
* Substitutive editing using sed-like syntax.
* Factoid history: any time a new value is set on a factoid, the name of the
user, current date, previous value and new value are recorded
* Factoid popularity: currently only visible in the raw data
* HTTP route to view raw JSON factoid data.

## Installation

`npm install hubot-factoids`

## Configuration

`HUBOT_BASE_URL` _[required]_ - URL of Hubot (ex. http://myhubothost.com:5555/)

`HUBOT_FACTOID_PREFIX` _[optional]_ - prefix character to use for retrieving a
factoid (defaults to `!` if unset)

## Commands

### Create/update a factoid

Creates a new factoid if it doesn't exist, or overwrites the factoid value with
the new value. Factoids maintain a history (can be viewed via the factoid URL)
of all past values along with who updated the value and when.

> **Note:** `<factoid>` can be any string which does not contain `=` or `=~`
(these reserved characters delimit the factoid and its value), although special
characters should be avoided.

`hubot: learn <factoid> = <details>`

### Inline editing a factoid

If you prefer, you can edit a factoid value inline, using a sed-like substitution
expression.

`hubot: learn <factoid> =~ s/expression/replace/gi`

`hubot: learn <factoid> =~ s/expression/replace/i`

`hubot: learn <factoid> =~ s/expression/replace/g`

`hubot: learn <factoid> =~ s/expression/replace/`

### Set an alias

An alias will point to the specified pre-existing factoid and when invoked will
return that factoid's value.

`hubot: alias <factoid> = <factoid>`

### Forget a factoid

Disables responding to a factoid. The factoid is not deleted from memory, and
can be re-enabled by setting a new value (its complete history is retained).

`hubot: forget <factoid>`

### Get URL to factoid data

Serves a page with the raw JSON output of the factoid data

`hubot: factoids`

### Recall a factoid value

Recall the value of the given factoid.

> **Note:** Hubot should not be directly addressed.

`!<factoid>`

Can be combined with a @mention to direct the message at another user:

`!factoid @user`

Hubot will respond accordingly:

`Hubot> @user: factoid value`

### Search for a factoid

Find a factoid containing the given string. The string can be matched in either
the factoid key or value.

`hubot: search foobar`


### Drop a factoid

**Permanently removes a factoid—this action cannot be undone.**
If [hubot-auth](https://github.com/hubot-scripts/hubot-auth) script is loaded,
"admin" or "factoids-admin" role is required to perform this action. It's
recommended you use the `forget` command instead of `drop`.

`hubot: drop <factoid>`
