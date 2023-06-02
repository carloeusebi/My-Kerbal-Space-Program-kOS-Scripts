# My Kerbal Space Program kOS Scripts

Theese are the autopilot scripts I wrote for the video game Kerbal Space Program, I can activate the script from an ingame terminal and they will take control of the spaceship and pilot it.

**BOOT**<br>
A script inside the 'boot' folder can be chosen before flight and it will be automatically executed when the ship power ups.

1. DEFAULT.ks
  - Is my default script, it opens the terminal and waits for the user to press the return key; once it is pressed it executes ASCENT.ks passing default parameters for an equitorial orbit of 75km apoapsis and 90degrees heading;
1. POLAR.ks
  - Same as default, but it passes parameters for a polar orbit: an heading of almost 360degrees;
1. JOT.ks
  - Just Open Terminal: this script does nothing, it just opens the terminal. Usueful to put on second stages or landers;

**SCRIPTS**<br>
Scripts can be called by other scripts as functions, or manually by typing 'run script(param1, param2, ...) from the terminal;

1 ASCENT.ks
  - This scripts is usally called by one of the boot scripts, it accepts an apoapsis and heading parameters. It stars a 10 seconds countdown and ignites the engines. It takes control of the staging and when a speed of 50m/s is reached starts the gravity turn controlling ship's pitch;
  	```
    lock pitch TO ( 90 - ((90 / 100 ) * ((SHIP:APOAPSIS / targetAp ) * 100))). //MAIN GRAVITY TURN LOOP
    ```
  - It prints on terminal current apoapsis height and T-;
  - When target apoapsis is reached it shuts off engines, it waits to reach 60km altitude to deploy eventual antennas and solar panels (must be configured pre-flight via Action Group 1 and 2), then calls the circularize script.
2. ASCENTNOATMO.ks
  - As ascent, but its gravity turn is optimized for taking off from planets without atmosphere.
3. CIRCULARIZE.ks
  - It creates a manouver node for circularization => where apoapsis = periapsis.
4. CIRCWITHNONODES.ks
  - It circularize an orbit withouth creating a manouver node, it involves lots of math and it is less precise than circularize.ks;
  - It is useful in the early game when manouver nodes yet locked.
5. COPYFILES.ks
  - This script copies all local files from the DSN to the ships local storage. It is useful for flights to other celestial bodies where Kerbin signal can be blocked by the celestial body.
6. MANOUVER.ks
  - If passed a manouver node it taks charge exectues that manouver node;
  - It uses Tsiolkovsky Rocket Equations to extimate the burn time and DeltaV requirements. At T-60 it alignes the ship to the DeltaV Vector. It then executes half the burn before the node and half after the node;  
  - It is able to handle ship staging but it doesnt takes staging in account when calculating burn time, this may result in very inprecises trajectories if next stage TWR is very different.
7. MINMUSDESCENDING.ks / MINMUSASCENDING.ks
  - Both scripts call ascent.ks passing optimized equitorial orbit inclination parameters to match Minmus tilted orbit;
  - This optimization allows to reach Minmus with a lower DeltaV profile.
8. NEXTNODE.js
  - This script calls manouver.ks passing the nextnode as a parameters; It is just a convenience to type less in the terminal.
9. ORBITINJECTION.ks
  - This scripts create a manouver node to slow ship down allowing it to be captured by the body's gravity in a circular orbit. It takes current periapsis as orbit's height.
10- SUICIDEBURN.ks
  - This script controls a suicide burn landing. It works mostly for no atmo low gravity bodies like Minmus or the Mun, where no parachute is needed;
  - It is able to land both Landers and Rovers, and chooses a different landing configuration based on the ship type;
  - When called it immediatly points ship retrograde and fires engines until it reaches a groundspeed of 0, letting the ship slowly falling towards the surface;
  - It continuesly calculates ship's stopping distance at current speed and the current distance to the ground;
  - When stopping distance is 110% the distance to the ground it fires engines and safely, gently, with a very low DeltaV consuption lands the Lander/Rover on the surface.

