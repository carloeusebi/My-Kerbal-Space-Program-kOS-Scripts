rcs on.
sas off.
if ship:availablethrust < 1 {stage.}
set gear to alt:radar < 1000.

clearscreen.

print "Ship is " + ship:type + ".".
lock steering to retrograde.
wait until vdot(ship:facing:forevector, retrograde:vector) > 0.999.
print "Initiating Burn.".
wait 2.

when alt:radar < 500 then {gear on.}

lock throttle to ship:groundspeed / (ship:availablethrust / ship:mass).

until ship:groundspeed < 5 {print "Groundspeed: " + round(ship:groundspeed) + "m/s    " at (0,2).}

lock throttle to 0.

lock steering to srfRetrograde.
lock pct to (stoppingDistance() / distanceToGround()) * 110/100.

//wait 1. set warp to 4.
clearscreen.

until pct > 1 {printValues().}
    lock throttle to (pct * 105/100).
    print "IGNITION!!" at(0,3).

until ship:verticalspeed > -0.1 {printValues().}
lock steering to up.

// only if rover
if ship:type = "Rover" {
    print "Separating lander" at (0,3).
    set ship:control:pilotmainthrottle to 1.
    stage.
    wait 1.
    kUniverse:forceactive(core:vessel).
}
else{    
    set ship:control:pilotmainthrottle to 0.
    print "LANDED!" at(0,3).	
}

unlock steering.



function distanceToGround {
    return altitude - body:geopositionOf(ship:position):terrainHeight - 2.
}

function stoppingDistance{
    local grav is constant():g * (body:mass / body:radius^2).
    local maxDeceleration is (ship:availablethrust / ship:mass) - grav.
    return ship:verticalspeed^2 / (2 * maxDeceleration).
}

function groundSlope {
  local east is vectorCrossProduct(north:vector, up:vector).

  local center is ship:position.

  local a is body:geopositionOf(center + 5 * north:vector).
  local b is body:geopositionOf(center - 3 * north:vector + 4 * east).
  local c is body:geopositionOf(center - 3 * north:vector - 4 * east).

  local a_vec is a:altitudePosition(a:terrainHeight).
  local b_vec is b:altitudePosition(b:terrainHeight).
  local c_vec is c:altitudePosition(c:terrainHeight).

  return vectorCrossProduct(c_vec - a_vec, b_vec - a_vec):normalized.
}

function printValues{
    print "Stopping distance: " + round(stoppingDistance()) + "m    " at (0,0).
    print "Distance to ground: " + round(distanceToGround()) + "m    " at(0,1).
    print "Vertical Speed: " + round(ship:verticalspeed) + "m/s           " at (0,2).
    print "pct: " + round(pct,3) + "; real pct: " + round(stoppingDistance() / distanceToGround(),3) at (0,3).
}