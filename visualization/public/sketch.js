// Generated by CoffeeScript 1.6.1
(function() {
  var applyXYZ, canvas, processingInstance, scalePosition, sketchProc, translatePosition;

  applyXYZ = function(fcn) {
    return [0, 1, 2].map(fcn, this);
  };

  scalePosition = function(pos) {
    return applyXYZ(function(coord) {
      return pos[coord] * -100;
    });
  };

  translatePosition = function(pos, P) {
    var newPos;
    newPos = [0, 0, 0];
    newPos[0] = pos[1] + P.width / 2;
    newPos[1] = pos[0] + P.height / 2;
    return newPos;
  };

  sketchProc = function(P) {
    P.setup = function() {
      return P.size(600, 600, P.WEBGL);
    };
    return P.draw = function() {
      var position;
      P.background(224);
      P.noStroke();
      P.lights();
      position = Accelerometer.position;
      position = scalePosition(position);
      position = translatePosition(position, P);
      P.fill(166, 244, 130);
      P.translate.apply(P, position);
      P.sphere(8);
      document.getElementById("x-val").textContent = position[1];
      document.getElementById("y-val").textContent = position[0];
      return document.getElementById("z-val").textContent = position[2];
    };
  };

  canvas = document.getElementById("canvas");

  processingInstance = new Processing(canvas, sketchProc);

}).call(this);
