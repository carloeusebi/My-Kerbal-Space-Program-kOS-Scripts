set m_time to time:seconds + eta:periapsis.
set v0 to velocityat(ship,m_time):orbit:mag.
set v1 to sqrt(body:mu / (body:radius + periapsis)).
set circularize to node(m_time, 0, 0, v1 - v0).
add circularize.

runpath("0:/maneuver.ks", circularize).

lock throttle to 0.
unlock steering.