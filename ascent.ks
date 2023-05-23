parameter targetap, hdg. //THE FINAL APOAPSIS YOU WANT TO REACH

rcs on.
sas off.

from {local x is 10.} until x = 0 STEP {set x to x-1.} DO {
    clearscreen. print "Countdown:". print "T - " + x.    
    wait 1.
}
clearscreen.
print "Ignition!".
lock throttle to 1.
until ship:maxthrust > 0 {stage. wait 1.}

set pitch to 90.

LOCK STEERING TO HEADING (hdg,pitch).
wait 1. gear off.


when ship:verticalspeed > 50 then { //DECIDE WHEN YOU WANT TO START THE GRAVITY TURN
    
	print "Initiating gravity turn.". print "Target Apoapsis: " + targetAp/1000 + "km, heading: " + hdg.
	lock pitch TO (90-((90/100)*((SHIP:APOAPSIS/targetAp)*100))). //MAIN GRAVITY TURN LOOP
}

//wait for 5000m to decouple launch escape.

set availThrust to ship:availablethrust.
local L to 4.

until apoapsis > targetAp{
    print "Apoapsis: " + round(apoapsis/1000,3) + "km "at (0,3).
    print "in T - " + round(eta:apoapsis,1) at (20,3).
    //if pitch < 45 {lock steering to prograde. print "Locking steering to prograde" at(0,4).}
    if ship:availablethrust < (availThrust-10) and alt:radar>5000 {
        stage. wait 1.
        print "staging." at (0,L).
        set L to L + 1.
        set availThrust to ship:availablethrust.
    }
}

lock throttle to 0.

when alt:radar > 60000 then {toggle ag1. wait 2. toggle ag2.}

run circularize.
//run circwithnonode(targetap,hdg).