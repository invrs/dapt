# Dapt

An interface for building adapters.

## What does that mean?

Adapters allow your users to configure and execute a custom workflow.

For example, [paradiso](https://github.com/invrs/paradiso) uses adapters for asset builds:

```coffee
build      = require "paradiso-build"
browserify = require "paradiso-build-browserify"
coffeeify  = require "paradiso-build-coffeeify"

browserify paths:
  "app/initializers/client": "public/client"

build browserify, coffeeify
```

Pass a config object or another adapter as parameters to an adapter.

## Install

```bash
npm install dapt
```

## Write an adapter

Adapters are similar to middleware in web applications.

Basic structure for writing an adapter:

```coffee
dapt = require "dapt"

module.exports = dapt class
  constructor: ({
    @adapters  # array of adapters in order of execution
    @options   # any options passed as a parameter (merged)
    @index     # index of this adapter in `@adapters`
    @next      # function to call the next adapter
  }) ->

  call: ({ env, next }) -> @next env
```

## Order of operation

```coffee
dapt = require "dapt"

a = dapt class
  constructor: ({ @options }) ->

  call: ({ env, next }) ->
    console.log "a @options", @options
  	env.a = true
  	@next env

b = dapt class
  call: ({ env, next }) ->
  	console.log "b"
  	env.b = true
  	@next env

c = dapt class
  call: ({ env, next }) ->
  	env.c = true
  	console.log "c env", env
  	@next env

a b, c, d: true

# Output:
#
#   a @options { d: true }
#   b
#   c env { a: true, b: true, c: true }
```
