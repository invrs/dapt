class Dapt
  constructor: (@Klass) ->

  args: (args) ->
    @env  ||= {}
    @opts ||= {}
    dapts   = [ @ ]

    args.forEach (arg) =>
      if typeof arg == "object"
        @opts[k] = v for k, v of arg
      else if typeof arg == "function" && arg.dapt
        dapts.push arg.dapt

    return if dapts.length == 1

    klasses = dapts.map (dapt, i) =>
      if dapt.Klass
        new dapt.Klass adapters: dapts, index: i, options: @opts

    klass = klasses[0]

    next = klasses.reverse().reduce (memo, klass) =>
      (env) => klass.run env: @env, next: memo
    , ->

    next()

module.exports = (->
  (Klass) ->
    dapt = new Dapt Klass

    fn = (args...) ->
      dapt.args args
      fn
    
    fn.dapt = dapt
    fn
)()
