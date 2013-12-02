{EventEmitter}  = require "events"
Frame           = require "./Frame"
InitialFrame    = require "./InitialFrame"
MMA8452Q        = require "./MMA8452Q"

class PositionTracker extends EventEmitter
  constructor: (@speed)->
    @speed       or= 50
    @initialFrame  = null
    @accelerometer = new MMA8452Q

  # call read n times and average to get a stable zero point
  init: (afterInit)->
    previousValue = [0, 0, 0, 0]
    nTimes = 30
    initPrevious = (times, afterInit)->
      if !times
        @initialFrame = new InitialFrame(previousValue)
        afterInit.call @
        return

      computeNext = (values)->
        [x, y, z, stamp] = values
        [pX, pY, pZ]     = previousValue
        previousValue    = [pX+x/nTimes, pY+y/nTimes, pZ+z/nTimes, stamp]

      readResult = (err, values)->
        computeNext(values)
        initPrevious.call(@, times - 1, afterInit)
      @accelerometer.read readResult.bind(@)

    initPrevious.call(@, nTimes, afterInit)

  run: ()->
    step = (lastFrame)->
      ()->
        readResult = (err, values)->
          return console.log(err) if err
          newFrame = new Frame(lastFrame, @initialFrame.tare(values))
          @emit "data", newFrame
          setTimeout step(newFrame).bind(@), @speed
        @accelerometer.read readResult.bind(@)

    step(@initialFrame).bind(@)()

  start: ()->
    @init(@run)

module.exports = PositionTracker
