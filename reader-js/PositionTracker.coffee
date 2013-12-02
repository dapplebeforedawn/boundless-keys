{EventEmitter}  = require "events"
Frame           = require "./Frame"
InitialFrame    = require "./InitialFrame"
MMA8452Q        = require "./MMA8452Q"

class PositionTracker extends EventEmitter
  constructor: (@speed)->
    @speed or= 50
    @initialFrame = nil

  # not proud of this, it was initially a do-one-thing experiment
  # and got shoe-horned when the EventEmitter was added.
  # tood: refactor
  start: ()->
    self = @
    accelerometer = new MMA8452Q
    previousValue = [0, 0, 0, 0]

    # call read n times and average to get a stable
    # zero point
    nTimes = 30
    initPrevious = (times, afterInit)->
      return afterInit() unless times

      computeNext = (values)->
        [x, y, z, stamp] = values
        [pX, pY, pZ]     = previousValue
        previousValue    = [pX+x/nTimes, pY+y/nTimes, pZ+z/nTimes, stamp]

      accelerometer.read (err, values)->
        computeNext(values)
        initPrevious(times - 1, afterInit)

    afterInit = ()->
      initFrame = new InitialFrame(previousValue)

      step = (lastFrame)->
        ()->
          accelerometer.read (err, values)->
            return console.log(err) if err
            newFrame = new Frame(lastFrame, initFrame.tare(values))
            self.emit "data", newFrame
            setTimeout step(newFrame), self.speed
      step(initFrame)()

    initPrevious(nTimes, afterInit)

module.exports = PositionTracker
