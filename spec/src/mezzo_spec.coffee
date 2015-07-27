mezzo = require "../../src/mezzo"

describe "Mezzo", ->

  beforeEach ->
    @a = mezzo class
      constructor: ({ @options }) ->

      run: ({ env, next }) ->
        console.log "a @options", @options
        env.a_run = true
        next env

    @b = mezzo class
      run: ({ env, next }) ->
        console.log "b"
        env.b_run = true
        next env

    @c = mezzo class
      run: ({ env, next }) ->
        env.c_run = true
        console.log "c env", env
        next env

  describe "thing", ->
    it "does", ->
      console.log @a opt: true
      console.log @a @b, @c, opt2: true
