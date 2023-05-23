parameter targetAlt.
parameter hdg.

if ship:availablethrust = 0 {stage. wait 1.}
clearscreen.
when alt:radar > 75000 then {lock steering to prograde.}

set targetvel to sqrt(body:mu / (body:radius + apoapsis)).
lock shipvel to velocity:orbit:mag.
lock deltav to targetvel - shipvel.

until eta:apoapsis < (maneuverBurnTime(deltav)/2) {
    printthings().
    print "Burn in T-" + round(eta:apoapsis - (maneuverBurnTime(deltav)/2)) + "s          " at (0,4).
}

lock throttle to 1.
set availThrust to ship:availablethrust.
set debug to 0.

until deltav < 10{   
    printthings().
    print "Apoapsis: " + round(apoapsis/1000,3) + "m    " at (0,4).
    print "Periapsis: " + round(periapsis/1000,3) + "m   " at (0,5).
    if ship:availablethrust < (availThrust/2){
        set debug to deltav.
        stage. wait 1.        
        set availThrust to ship:availablethrust.
    }
}

until deltav < 0.1 {
    printthings().
    print "Apoapsis: " + round(apoapsis/1000,3) + "m    " at (0,4).
    print "Periapsis: " + round(periapsis/1000,3) + "m   " at (0,5).
    lock throttle to deltav / (ship:availablethrust / ship:mass).
}

lock throttle to 0.

clearscreen.
print "Apoapsis: " + round(apoapsis/1000,3).
print "Periapsis: " + round(periapsis/1000,3).
print "Last stage DeltaV remaining: " + round(debug,1).
print targetvel + "; " + shipvel + "; " + deltav.

function maneuverBurnTime {
    //https://www.youtube.com/watch?v=NzlM6YZ9g4w&ab_channel=CheersKevin

    parameter dv.
    local isp is 0.
    local g0 is 9.80665.

    list engines in myEgnines.
    for en in myEgnines {
        if en:ignition and not en:flameout{        
            if ship:availablethrust = 0 {stage. wait 1.}
            set isp to isp + (en:isp * (en:availablethrust / ship:availablethrust)).
        }
    }
    local mf is ship:mass / constant():e^(dV / (isp * g0)).
    local fuelFlow is ship:availablethrust / (isp * g0).
    local t is (ship:mass -mf) / fuelFlow.

    return t.
}

function printthings {
    print "Target Orbit: " + targetAlt + "m   " at (0,0).
    print "Ship Velocity: " + round(shipvel) + "m/s             " at (0,1).
    print "Target Velocity: " + round(targetvel) + "m/s" at (0,2).
    print "DeltaV: " + round(deltav) + "m/s           " at (0,3).    
}
