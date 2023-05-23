parameter targetap, hdg. //THE FINAL APOAPSIS YOU WANT TO REACH

rcs on.
sas off.

clearscreen.
print "Ignition!".
lock throttle to 1.

set pitch to 90.

LOCK STEERING TO HEADING (hdg,pitch).
wait 2. gear off.
lock pitch TO (90-((90/100)*((SHIP:APOAPSIS/targetAp)*100))). //MAIN GRAVITY TURN LOOP

//wait for 5000m to decouple launch escape.

set availThrust to ship:availablethrust.
local L to 4.

wait until apoapsis > targetAp.


lock throttle to 0.

when alt:radar > 60000 then {toggle ag1. wait 2. toggle ag2.}

run circularize.
//run circwithnonode(targetap,hdg).