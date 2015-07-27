# Mezzo

An interface for building adapters.

## What is an adapter?

Adapters allow your users to build a custom configuration/middleware chain for...anything!

For example, this is how users of [paradiso](https://github.com/invrs/paradiso) configure the web server:

```coffee
routes  = require "./routes"
server  = require "paradiso-server"
express = require "paradiso-server-express"

server routes, express,
  port:   9000
  static: "public"
```

Or configure client asset builds:

```coffee
build      = require "paradiso-build"
browserify = require "paradiso-build-browserify"
coffeeify  = require "paradiso-build-coffeeify"

browserify paths:
  "app/initializers/client": "public/client"

build browserify, coffeeify
```

### Goals

* Abstract library-specific code into smaller testable libraries.
* Maintain a similar interface for libraries that do the same thing.
* Don't change your app code, change the adapter.
* Piece together different adapters easily.

### Configuring adapters

If you only pass options to an adapter, it **does not** run the middleware chain.

```coffee
build option: true
```

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

## Write an adapter

Adapters are similar to middleware in web applications.

Basic structure for writing an adapter:

```coffee
mezzo = require "mezzo"

module.exports = mezzo class
  constructor: ({
    @adapters  # array of adapters in order of execution
    @options   # any options passed as a parameter (merged)
    @index     # index of this adapter in `@adapters`
  }) ->

  run: ({ env, next }) -> next env
```

### Put it all together

```coffee
mezzo = require "mezzo"

# Build adapters
#
a = mezzo class
  constructor: ({ @options }) ->

  run: ({ env, next }) ->
    console.log "a @options", @options
  	env.a_run = true
  	next env

b = mezzo class
  run: ({ env, next }) ->
  	console.log "b"
  	env.b_run = true
  	next env

c = mezzo class
  run: ({ env, next }) ->
  	env.c_run = true
  	console.log "c env", env
  	next env

# Set options
#
a opt: true

# Execute middleware chain
#
a b, c, opt2: true

# Output:
#
#   a @options { opt: true, opt2: true }
#   b
#   c env { a_run: true, b_run: true, c_run: true }
```
