set m_time to time:seconds + eta:apoapsis.
set v0 to velocityat(ship,m_time):orbit:mag.
set v1 to sqrt(body:mu / (body:radius + apoapsis)).
set circularize to node(m_time, 0, 0, v1 - v0).
add circularize.

run maneuver(circularize).