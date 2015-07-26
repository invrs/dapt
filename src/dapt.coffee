class Dapt
  constructor: (@Klass) ->

  args: (args) ->
    @env  ||= {}
    @opts ||= {}
    @dapts  = [ @ ]

    args.forEach (arg) =>
      if arg typeof "object"
        opts[k] = v for k, v of arg
      else if arg typeof "function" && arg.dapt
        @dapts.push arg.dapt

    klasses = @dapts.map (dapt, i) =>
      if dapt.Klass
        new Klass adapters: @dapts, index: i, options: @opts

    next  = ->
    klasses.reverse().forEach (klass) =>
      next = (env) -> klass.run env: @env, next: next

    klass.run env: @env, next: next

module.exports = (->
  dapt = new Dapt Klass

  fn = (args...) ->
    dapt.args args
    @
  
  fn.dapt = dapt

  (Klass) -> fn
)()
