class Mezzo
  constructor: (@Klass) ->

  args: (args) ->
    @env  ||= {}
    @opts ||= {}
    mezzos   = [ @ ]

    args.forEach (arg) =>
      if typeof arg == "object"
        @opts[k] = v for k, v of arg
      else if typeof arg == "function" && arg.mezzo
        mezzos.push arg.mezzo

    return if mezzos.length == 1

    klasses = mezzos.map (mezzo, i) =>
      if mezzo.Klass
        new mezzo.Klass adapters: mezzos, index: i, options: @opts

    klass = klasses[0]

    next = klasses.reverse().reduce (memo, klass) =>
      (env) => klass.run env: @env, next: memo
    , ->

    next()

module.exports = (->
  (Klass) ->
    mezzo = new Mezzo Klass

    fn = (args...) ->
      mezzo.args args
      fn
    
    fn.mezzo = mezzo
    fn
)()
