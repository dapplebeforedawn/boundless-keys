class InitialFrame
  constructor: (accelValues)->
    @gAccel        = accelValues.slice(0, 3)   # g
    @accel         = calcAccel.call(@)         # m/s^2
    @timestamp     = accelValues.slice(3, 4)   # ms
    @timeDelta     = [0,0,0]                   # seconds
    @endVelocity   = [0,0,0]
    @positionDelta = [0,0,0]
    @position      = [0,0,0]

  tare: (accelValues)->
    tare = (coord)->
      accelValues[coord] - @gAccel[coord]
    applyXYZ.call(@, tare).concat accelValues[3]

  calcAccel = ->
    times9_8 = (val)-> (val * 9.801)
    @gAccel.map times9_8, @

  applyXYZ = (fcn)->
    [0,1,2].map fcn, @

module.exports = InitialFrame
