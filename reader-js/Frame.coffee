class Frame
  constructor: (@lastFrame, accelValues)->
    @gAccel        = accelValues.slice(0, 3)   # g
    @accel         = calcAccel.call(@)         # m/s^2
    @timestamp     = accelValues.slice(3, 4)   # ms
    @timeDelta     = calcTimeDelta.call(@)     # seconds
    @endVelocity   = calcEndVelocity.call(@)   # m/s
    @positionDelta = calcPositionDelta.call(@)
    @position      = calcPosition.call(@)

  calcAccel = ->
    times9_8 = (val)-> (val * 9.801)
    @gAccel.map times9_8, @

  calcTimeDelta = ->
    (@timestamp - @lastFrame.timestamp) / 1000

  calcEndVelocity = ->
    velocity = (coord)->
      @accel[coord] * @timeDelta
    applyXYZ.call @, velocity

  # d_x(t) = v(0)*t + 1/2*a*t^2
  calcPositionDelta = ->
    posDelta = (coord)->
      v0_t = @lastFrame.endVelocity[coord] * @timeDelta
      v0_t + 1/2 * @accel[coord] * Math.pow(@timeDelta, 2)
    applyXYZ.call @, posDelta

  # x(t) = x(0) + v(0)*t + 1/2*a*t^2
  calcPosition = ->
    newPosition = (coord)->
      @lastFrame.position[coord] + @positionDelta[coord]
    applyXYZ.call @, newPosition

  applyXYZ = (fcn)->
    [0,1,2].map fcn, @

module.exports = Frame
