dapt = require "../../src/dapt"

describe "Dapt", ->

  beforeEach ->
    @a = dapt class
      constructor: ({ @options }) ->

      run: ({ env, next }) ->
        console.log "a @options", @options
        env.a_run = true
        next env

    @b = dapt class
      run: ({ env, next }) ->
        console.log "b"
        env.b_run = true
        next env

    @c = dapt class
      run: ({ env, next }) ->
        env.c_run = true
        console.log "c env", env
        next env

  describe "thing", ->
    it "does", ->
      console.log @a opt: true
      console.log @a @b, @c, opt2: true
