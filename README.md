# Dapt

An interface for building adapters.

## What is an adapter?

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

### Configuring adapters

Adapters can take the following as parameters:

* an object (configuration)
* another adapter

### Run the workflow

If you only pass options to an adapter, it **does not** run the workflow.

The options you pass are saved for a later workflow run:

```coffee
build option: true
```

However, pretty much everything else does run the workflow:

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

  call: ({ env, next }) -> next env
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
