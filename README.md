# Dapt

An interface for building adapters.

## What is an adapter?

Adapters allow your users to configure and execute a custom middleware chain.

For example, [paradiso](https://github.com/invrs/paradiso) uses adapters for asset builds:

```coffee
build      = require "paradiso-build"
browserify = require "paradiso-build-browserify"
coffeeify  = require "paradiso-build-coffeeify"

browserify paths:
  "app/initializers/client": "public/client"

build browserify, coffeeify
```

### Configuring adapters

If you only pass options to an adapter, it **does not** run the middleware chain.

However, it does save the options for a later execution:

```coffee
build option: true
build()  # @options.option is still true
```

### Run the workflow

If you pass an adapter or nothing at all, the middleware chain **does** run:

```coffee
build()
build browserify, coffeeify
build browserify, coffeeify, option: true
```

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
  }) ->

  run: ({ env, next }) -> next env
```

## Order of operation

```coffee
dapt = require "dapt"

a = dapt class
  constructor: ({ @options }) ->

  run: ({ env, next }) ->
    console.log "a @options", @options
  	env.a = true
  	next env

b = dapt class
  run: ({ env, next }) ->
  	console.log "b"
  	env.b = true
  	next env

c = dapt class
  run: ({ env, next }) ->
  	env.c = true
  	console.log "c env", env
  	next env

a b, c, d: true

# Output:
#
#   a @options { d: true }
#   b
#   c env { a: true, b: true, c: true }
```
