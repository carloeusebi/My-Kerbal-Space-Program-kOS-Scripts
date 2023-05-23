core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
runpath("0:/copyfiles.ks").
print "Press enter to start countdown.".
wait until terminal:input:getchar() = terminal:input:return.
runpath("0:/ascent.ks", 75000, 353).