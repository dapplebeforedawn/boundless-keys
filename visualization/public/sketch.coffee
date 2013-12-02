applyXYZ = (fcn)->
  [0,1,2].map fcn, @

# each pixel is 1mm
scalePosition = (pos)->
  applyXYZ (coord)->
    pos[coord] * 1000

# allow for 0,0 being the screen center
translatePosition = (pos, P)->
  newPos    = [ 0, 0, 0 ]  # ignore z for now
  newPos[0] = pos[0] + P.width/2
  newPos[1] = pos[1] + P.height/2
  newPos

sketchProc = (P) ->

  P.setup = ->
    P.size(600, 600, P.WEBGL)

  P.draw = ->
    P.background(224)
    P.noStroke()
    P.lights()

    position = Accelerometer.position
    position = scalePosition position
    position = translatePosition position, P

    P.fill 166, 244, 130
    P.translate(position...)
    P.sphere(8)

    document.getElementById("x-val").textContent = position[0]
    document.getElementById("y-val").textContent = position[1]
    document.getElementById("z-val").textContent = position[2]

# attaching the sketchProc function to the canvas
canvas = document.getElementById("canvas")
processingInstance = new Processing(canvas, sketchProc)
