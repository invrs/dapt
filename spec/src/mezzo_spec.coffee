mezzo = require "../../src/mezzo"

describe "Mezzo", ->

  describe "next", ->
    it "calls the middleware in order", (done) ->
      a = mezzo class
        run: ({ env, next }) ->
          next()

      b = mezzo class
        run: ({ env, next }) ->
          done()

      a b, option: true

    it "passes env variables to run", (done) ->
      a = mezzo class
        run: ({ env, next }) ->
          env.a = true
          next()

      b = mezzo class
        run: ({ env, next }) ->
          expect(env).toEqual a: true
          done()

      a b, option: true

    it "accepts env variable as parameter to next", (done) ->
      opts = a: true

      a = mezzo class
        run: ({ env, next }) ->
          next opts

      b = mezzo class
        run: ({ env, next }) ->
          expect(env).toEqual opts
          done()

      a b, option: true


  describe "options", ->
    it "passes options to constructors", (done) ->
      opts = a: true

      a = mezzo class
        constructor: ({ adapters, index, options }) ->
          expect(adapters[0]).toBe a.mezzo
          expect(adapters[1]).toBe b.mezzo
          expect(adapters.length).toBe 2
          expect(index).toBe 0
          expect(options).toEqual opts

        run: ({ env, next }) ->
          next()

      b = mezzo class
        constructor: ({ adapters, index, options }) ->
          expect(adapters[0]).toBe a.mezzo
          expect(adapters[1]).toBe b.mezzo
          expect(adapters.length).toBe 2
          expect(index).toBe 1
          expect(options).toEqual opts

        run: ({ env, next }) ->
          done()

      a b, opts
