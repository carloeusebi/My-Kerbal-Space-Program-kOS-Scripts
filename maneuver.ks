parameter nd.

//if stage:deltav:current < nd:deltav:mag {stage. wait 1.}

clearscreen.

print "Node in :" + round(nd:eta) + "s, DeltaV: " + round(nd:deltav:mag,1) + "m/s".

//calculate ship's max acc

lock max_acc to ship:availablethrust / ship:mass.

lock burn_duration to maneuverBurnTime(nd).
lock timetoBurn to nd:eta - (burn_duration / 2).

.

until nd:eta <= (burn_duration/2 + 60){
    print "Burn time: " + round(burn_duration,1) + "s                 " at(0,1).
    print "Time to burn: T-" + round(timetoBurn) + "                  " at(0,2).
    wait 1.
    }

lock np to nd:deltav. //points to node, don't care about the roll direction.
sas off.
lock steering to np.
print "Aligning.." at(0,3).

//now we need to wait until the burn vector and ship's facing are aligned
//wait until vang(np, ship:facing:vector) < 0.25.

//the ship is facing the right direction, let's wait for our burn time
until nd:eta <= (burn_duration/2) {
    print "Burn time: " + round(burn_duration,1) + "s                 " at(0,1).
    print "Time to burn: T-" + round(timetoBurn) + "                  " at(0,2).
    wait 1.
}

//we only need to lock throttle once to a certain variable in the beginning of the loop, and adjust only the variable itself inside it
set tset to 0.

clearscreen.
print "DeltaV: " + round(nd:deltav:mag,1) + "m/s".
print "Initiating burn!".

lock throttle to tset.

set done to False.
//initial deltav
set dv0 to nd:deltav.
set availThrust to ship:availablethrust.

until done
{
    if ship:availablethrust < (availThrust-10){
        stage. wait 1.
        print "staging.".
        set availThrust to ship:availablethrust.
    }   
    //recalculate current max_acceleration, as it changes while we burn through fuel
    set max_acc to ship:availablethrust/ship:mass.

    //throttle is 100% until there is less than 1 second of time left to burn
    //when there is less than 1 second - decrease the throttle linearly
    set tset to min(nd:deltav:mag/max_acc, 1).

    //here's the tricky part, we need to cut the throttle as soon as our nd:deltav and initial deltav start facing opposite directions
    //this check is done via checking the dot product of those 2 vectors
    if vdot(dv0, nd:deltav) < 0
    {
        print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        lock throttle to 0.
        break.
    }

    //we have very little left to burn, less then 0.1m/s
    if nd:deltav:mag < 0.01
    {
        print "Finalizing burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        //we burn slowly until our node vector starts to drift significantly from initial vector
        //this usually means we are on point
        //wait until vdot(dv0, nd:deltav) < 0.5.

        lock throttle to 0.
        print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        set done to True.
    }
}
unlock steering.
unlock throttle.
wait 1.

//we no longer need the maneuver node
remove nd.

//set throttle to 0 just in case.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

function maneuverBurnTime {
    //https://www.youtube.com/watch?v=NzlM6YZ9g4w&ab_channel=CheersKevin

    parameter mnv.
    local dv is mnv:deltav:mag.
    local isp is 0.
    local g0 is 9.80665.

    list engines in myEgnines.
    for en in myEgnines {
        if en:ignition and not en:flameout{        
            set isp to isp + (en:isp * (en:availablethrust / ship:availablethrust)).
        }
    }
    local mf is ship:mass / constant():e^(dV / (isp * g0)).
    local fuelFlow is ship:availablethrust / (isp * g0).
    local t is (ship:mass -mf) / fuelFlow.

    return t.
}