#
# loopycam
#

#define xx eval "#include loopycam.k"
#define yy loopycam()

INCDEC_MID = 0
INCDEC_MIN = -2
INCDEC_MAX = 2
INCDEC_INC = 1
INCDEC_DEC = -1
DebugOsc = 0
LcdDebug = 0

#define xxx rereadlib();loopycam()

function loopycam() {
	# sleeptill(Now+12b)
	print("GO!")
	if ( VVVVOutput <= 0 ) {
		print("Hey, VVVVOutput needs to be set")
		return()
	}
	o = new loopycamobj()
	while (1) {
		c = Root.waitforconsolekey()
		if ( ascii(c) == 27 ) {
			break
		}
		print("ignoring c=",c)
	}
	deleteobject(o)
}

class loopycamobj {
method init {

	$.mode = "display"

	$.clicks_to_wait_osc = milliclicks(60 * 1000) # 60 seconds
	$.clicks_to_wait_joy = milliclicks(60 * 1000) # 60 seconds

	$.autochangetid = -1
	$.automation = 0
	$.defaultdt = 8b
	$.skip = 0
	$.constanteffects = 0
	$.nopause = 0
	$.nexteffecttime = Now
	$.defaultinterval = 1000
	$.effectinterval = $.defaultinterval
	$.stayontill = 0
	$.dt = $.defaultdt
	$.numpresets = 0
	$.presetnames = []
	$.loadpresetnames(".")
	$.effecton = []
	$.effects = [
# 		"IscMirror1" =		["ch"=1, "ct"=2, "params"= [
# 			"splitx" = ["ch"=2,"ct"=1],
# 			"splity" = ["ch"=2,"ct"=2]
# 			]],
# 		"IscMirror2" =		["ch"=1, "ct"=3, "params"= [
# 			"x1" = ["ch"=2,"ct"=3],
# 			"y1" = ["ch"=2,"ct"=4],
# 			"x2" = ["ch"=2,"ct"=5],
# 			"y2" = ["ch"=2,"ct"=6]
# 			]],
# 		"SmokingEdges" =	["ch"=1, "ct"=4, "params"= [
# 			"blend" = ["ch"=2,"ct"=7],
# 			"strengthx" = ["ch"=2,"ct"=8],
# 			"strengthy" = ["ch"=2,"ct"=9],
# 			"dirblend" = ["ch"=2,"ct"=10],
# 			"moveblend" = ["ch"=2,"ct"=11]
# 			]],
# 		"MotionFade" =		["ch"=1, "ct"=5, "params"= [
# 			"detectrange" = ["ch"=2,"ct"=12],
# 			"lifefade" = ["ch"=2,"ct"=13],
# 			"inputmix" = ["ch"=2,"ct"=14]
# 			]],
# 		"ReflColors1" =		["ch"=1, "ct"=6, "params"= [
# 			"zoomred" = ["ch"=2,"ct"=15],
# 			"zoomgreen" = ["ch"=2,"ct"=16],
# 			"zoomblue" = ["ch"=2,"ct"=17]
# 			]],
# 		"Reflection1" =		["ch"=1, "ct"=8, "params"= [
# 			"zoom" = ["ch"=2,"ct"=21]
# 			]],
# 		"EdgeEnhance" =		["ch"=1, "ct"=9, "params"= [
# 			"horizontal" = ["ch"=2,"ct"=22],
# 			"vertical" = ["ch"=2,"ct"=23],
# 			"enhance" = ["ch"=2,"ct"=24]
# 			]],
# 		"ColPersist" =		["ch"=1, "ct"=10, "params"= [
# 			"persist" = ["ch"=2,"ct"=25]
# 			]],
# 		"RectRandom" =		["ch"=1, "ct"=11, "params"= [
# 			"count" = ["ch"=2,"ct"=26,"min"=10,"max"=110],
# 			"size" = ["ch"=2,"ct"=27, "min"=10,"max"=110],
# 			"zoom" = ["ch"=2,"ct"=28, "min"=10,"max"=110]
# 			]],
# 		"ColorWarp" =		["ch"=1, "ct"=13, "params"= [
# 			"hueoffset" = ["ch"=2,"ct"=31],
# 			"huescale" = ["ch"=2,"ct"=32],
# 			"satoffset" = ["ch"=2,"ct"=33],  # around half
# 			"satscale" = ["ch"=2,"ct"=34]    # around half
# 			]],
# 		"LumaCycle" =		["ch"=1, "ct"=14, "params"= [
# 			"offset" = ["ch"=2,"ct"=35],
# 			"startpos" = ["ch"=2,"ct"=36],
# 			"endpos" = ["ch"=2,"ct"=37],
# 			"starthue" = ["ch"=2,"ct"=38],
# 			"startsat" = ["ch"=2,"ct"=39],
# 			"startval" = ["ch"=2,"ct"=40],
# 			"endhue" = ["ch"=2,"ct"=41],
# 			"endsat" = ["ch"=2,"ct"=42],
# 			"endval" = ["ch"=2,"ct"=43]
# 			]],
# 		"MultiExposure" =	["ch"=1, "ct"=1, "params"= [
# 			"exposure2delay" = ["ch"=2,"ct"=56],
# 			"exposure3delay" = ["ch"=2,"ct"=57],
# 			"exposure" = ["ch"=2,"ct"=58]
# 			]]

		"PeteGaussianBlur" = [ "params" = [
			"Radius" = [],
			"Edge Factor" = [],
			"Fake It" = [],
			"Passes" = [],
			"Do UnSharpMask" = [],
			"Aspect Ratio" = [],
			"UnSharpMask Amou" = [],
			"Do Odd But Cool" = []
			]],
		"iua_RectField" = [ "params" = [
			"Count" = [],
			"Size" = [],
			"Variation" = [],
			"Mode" = []
			]],
		"iua_Edge_Glow" = [ "params" = [
			"Horizontal" = [],
			"Vertical" = [],
			"Enhance" = []
			]],
		"PeteGlow" = [ "params" = [
			"Inner Radius" = [],
			"Outer Radius" = [],
			"Passes" = [],
			"Floor" = [],
			"Ceiling" = [],
			"Aspect Ratio" = []
			]],
		"PetePosterize" = [ "params" = [
			"Levels" = []
			]],
		"PeteRadialBlur" = [ "params" = [
			"Layer Scale" = [],
			"Quality" = []
			]],
		"iua_frame_echo" = [ "params" = [
			"Echo" = [],
			"Decay" = []
			]],
		"PeteChromium" = [ "params" = [
			"Edge1" = [],
			"Edge2" = [],
			"Tint Red" = [],
			"Tint Green" = [],
			"Tint Blue" = []
			]],
		"PeteHalfTone" = [ "params" = [
			"Dot Size" = [],
			"Style" = [],
			"Angle" = [],
			"Smoothing" = []
			]],
		"PeteVectorize" = [ "params" = [
			"Pre-Filter" = [],
			"Resolution" = [],
			"Monochrome" = [],
			"Colour Count" = [],
			"Palette Persiste" = [],
			"Difference Thres" = []
			]],
		"PeteTimeBlur" = [ "norand" = 1, "params" = [
			"Time" = []
			]],
		"PeteKaleidascope" = [ "params" = [
			"Divisions" = [],
			"Output Angle" = [],
			"Source Angle" = [],
			"Source Centre X" = [],
			"Source Centre Y" = [],
			"Output Centre X" = [],
			"Output Centre Y" = [],
			"Reflection Line" = [],
			"Source Angle Pro" = []
			]],
		"PeteMetaImage" = [ "params" = [
			"Size" = [],
			"Do Distance Base" = [],
			"Cheap And Nasty" = []
			]],
		"PeteMetaImage" = [ "params" = [
			]],
		"PeteRectDistort" = [ "params" = [
			"Enable Clear" = [],
			"Enable Rectangle" = [],
			"Rate" = [],
			"Width" = [],
			"Height" = [],
			"X Delta" = [],
			"Y Delta" = [],
			"Persistence" = []
			]],
		"PeteRefraction" = [ "params" = [
			"Refraction" = [],
			"Cell Width" = [],
			"Cell Height" = [],
			"Allow Magnificat" = []
			]],
		"PeteSolarize" = [ "params" = [
			"Threshold" = [],
			"Start" = [],
			"End" = [],
			"Limit" = [],
			"Floor" = [],
			"Ceiling" = []
			]],
		"PeteTile" = [ "params" = [
			"Angle" = [],
			"Skew Angle" = [],
			"Cell Width" = [],
			"Cell Height" = []
			]],
		"PeteWave" = [ "params" = [
			"Friction" = [],
			"Speed" = []
			]],
		"PetePanSpinZoom" = [ "params" = [
			"Origin X" = [],
			"Origin Y" = [],
			"Rotation" = [],
			"Scale" = []
			]]
		]


	$.timeblurdll = "PeteTimeBlur.dll"

	$.ispressed = ["L1"=0,"L2"=0,"R1"=0,"R2"=0,"X"=0,"SQUARE"=0,"CIRCLE"=0,"TRIANGLE"=0]
	$.anypressed = 0

	$.looperport = 8888
	$.looper = open(string($.looperport)+"@127.0.0.1","wb","osc_send")
	$.j = getjoymonitor()
	$.arr = joyinit()
	for ( jn in $.arr ) {
		$.j.notify($,jn)
	}
	$.lastosc = 0
	$.lastjoy = 0
	$.randomizing = 0
	$.currloop = 0
	$.midval = 32767
	$.maxval = 65535
	$.isplaying = [0=2,1=0,2=0,3=0]

	$.fulldisplay()
	$.autonext = 1
	$.setautonext($.autonext)
	$.xor = 0
	$.border = 0
	$.setxor($.xor)
	$.setborder()
	$.moveamount = 8
	$.setmoveamount()

	for ( loop=0; loop<4; loop++ ) {
		$.sendosc([0="/looper/play",1=loop,2=$.isplaying[loop]])
	}
	for ( i in $.effects ) {
		print("Effect = ",i)
		e = $.effects[i]
		dll = i + ".dll"
		$.sendosc([0="/looper/loadplugin",1=(dll)])
		# Disable everything, and make timeblur a post-loopy effect
		$.sendosc([0="/looper/enableplugin",1=dll,2=0])
	}

	# $.osclistenport = 1337
	# s = string($.osclistenport)+"@"+Hostname
	# $.oscf = open(s,"rA","osc_listen")
	# if ( $.oscf < 0 ) {
	# 	print("Unable to listen on ",Osclisten," !?")
	# 	$.osctid = -1
	# } else {
	# 	print("Listening for OSC on ",s," ...")
	# 	$.osctid = task $.osctask()
	# }
	$.osctid = -1
	$.oscf = -1

	# fn0 = $.getrandompreset()
	# $.loadpreset(fn0)

	$.dotimeblur = 0
	$.timeblur($.dotimeblur)

	# $.autotid = task $.autoloop()
	$.autotid = -1
}
method currentloop(n)
{
	$.sendosc([0="/looper/currentloop",1=n])
}
method recordloop(loopnum,tm,totaltm) {
	if ( nargs() < 3 ) {
		totaltm = tm
	}
	# print("RECORDLOOP tm=",tm,"  totaltm=",totaltm)
	# print("RECORDLOOP loopnum=",loopnum," tm=",tm)

	$.currentloop(loopnum)
	$.sendosc([0="/looper/record",1=1])

	if ( $.sleeptill(Now+tm) ) {
		$.currentloop(loopnum)
		$.sendosc([0="/looper/record",1=0])
		return(1)
	}
	$.currentloop(loopnum)
	$.sendosc([0="/looper/record",1=0])

	if ( $.pausetill(Now+(totaltm-tm)) ) {
		# unlock($)
		return(1)
	}

	# unlock($)

	# if ( $.lastosc > 0 && (Now-$.lastosc) < $.clicks_to_wait_osc ) {
	#	print("OSC SEEN!!! NOT waiting...")
	#	while ( (Now-$.lastosc) < $.clicks_to_wait_osc ) {
	#		sleeptill(Now+1b)
	#	}
	#	print("OSC IDLE !!! continuing with autoloop")
	# }
	if ( $.lastjoy > 0 && (Now-$.lastjoy) < $.clicks_to_wait_joy ) {
		print("JOYSTICK SEEN!!! lastjoy=",$.lastjoy," waiting...")
		while ( (Now-$.lastjoy) < $.clicks_to_wait_joy ) {
			$.pokelog()
			if ( $.sleeptill(Now+1b) ) {
				print("SLEEPTILL wakes up JOYSTICK")
				break
			}
		}
		print("JOYSTICK IDLE !!! continuing with autoloop")
		$.lastjoy = 0
	}
	return(0)
}
method pokelog() {
	fn = "c:\\local\\vvvv\\vvvv_40beta19.1\\frame_written.log"
	f = open(fn,"w")
	put(f,"poke log from keykit\n")
	close(f)
}
method stoploop(loopnum) {
	m = [0="/looper/play",1=loopnum,2=0]
	$.sendosc(m)
}
method sendosc(m) {
	if ( DebugOsc )
		print("Sending to looper, OSC m=",m)
	mdep("osc","send",$.looper,m)
}
method seteffects(onoff) {
	print("SETEFFECTS onoff=",onoff)
	$.randomizing = onoff
	$.dorandomizing()
}
method quadrantdisplay() {
	$.sendosc([0="/looper/quadrantdisplay"])
}
method randompositions(aspect) {
	$.sendosc([0="/looper/randompositions",1=float(aspect)])
}
method randomposition1(aspect) {
	$.sendosc([0="/looper/randomposition1",1=float(aspect)])
}
method randomposition(aspect) {
	$.sendosc([0="/looper/randomposition",1=float(aspect)])
}
method fulldisplay() {
	$.sendosc([0="/looper/fulldisplay"])
}
method setsizefactor(f) {
	$.sendosc([0="/looper/sizefactorall",1=f])
}
method setautonext(v) {
	$.sendosc([0="/looper/autonext",1=v])
}
method togglesmooth(v) {
	$.sendosc([0="/looper/togglesmooth"])
}
method setxor(v) {
	$.sendosc([0="/looper/xor",1=v])
}
method setborder() {
	$.sendosc([0="/looper/border",1=$.border])
}
method setmoveamount() {
	v = $.moveamount
	$.sendosc([0="/looper/moveamount",1=v])
}
method morewindows() {
	$.sendosc([0="/looper/morewindows"])
}
method lesswindows() {
	$.sendosc([0="/looper/lesswindows"])
}
method alllive() {
	$.sendosc([0="/looper/alllive"])
}
method settext(s) {
	$.sendosc([0="/looper/settext",1=s])
}
method cleartext() {
	$.sendosc([0="/looper/cleartext",1=0])
}
method slowstop(shortdt) {
	$.stoploop(3)
	if ( $.nopause == 0 )
		sleeptill(Now+shortdt)
	$.stoploop(2)
	if ( $.nopause == 0 )
		sleeptill(Now+shortdt)
	$.stoploop(1)
	if ( $.nopause == 0 )
		sleeptill(Now+shortdt)
	$.stoploop(0)
	if ( $.nopause == 0 )
		sleeptill(Now+shortdt)
}

method faststop() {
	$.stoploop(3)
	$.stoploop(2)
	$.stoploop(1)
	$.stoploop(0)
}

method sleeptill(endtm) {
	# print("    SLEEPTILL endtm=",endtm,"  dt=",(endtm-Now))

	if ( $.constanteffects != 0 && Now > $.constanteffects ) {
		$.constanteffects = 0
	}

	if ( $.nopause != 0 && Now > $.nopause ) {
		$.nopause = 0
	}

	if ( $.skip != 0 ) {
		$.skip = 0
		return(1)
	}
	totn = 0
	dt = 2
	while ( Now < endtm ) {
		millisleep(100)
		if ( $.skip != 0 ) {
			$.skip = 0
			return(1)
		}
		if ( $.constanteffects != 0 && Now > $.nexteffecttime) {

			# $.randomeffects(2)

			fn = $.getrandompreset()
			if ( fn != "" )
				$.loadpreset(fn)

			$.nexteffecttime = Now + milliclicks($.effectinterval)
		}
	}
	return(0)
}

method pausetill(endtm) {
	if ( $.nopause != 0 ) {
		# print("NOPAUSE!")
		return(0)
	}
	return($.sleeptill(endtm))
}

method onepass(label,effects,full,leng,pauseleng,times,nostop) {

	print("ONEPASS leng=",leng,"  pauseleng=",pauseleng)
	slowstopdt = 1b/4
	smalldt = 1b/4

	$.faststop()
	$.noeffects()
	$.settext(label)
	if ( $.pausetill(Now+2b) ) {
		$.cleartext()
		return()
	}
	$.cleartext()

	if ( full != 0 ) {
		$.fulldisplay()
	} else {
		$.quadrantdisplay()
	}

	loopcount = 0
	if ( effects ) {
		fn0 = $.getrandompreset()
		fn1 = $.getrandompreset(fn0)
		fn2 = $.getrandompreset(fn0,fn1)
		fn3 = $.getrandompreset(fn0,fn1,fn2)
	}
	while (1) {
	    loopcount++
	    print("TOP OF LOOP, full=",full)
	    if ( full != 0 ) {
		if ( effects && loopcount <= 1) {
			print("RANDOMPRESET!")
			$.loadpreset(fn0)
			if ( $.sleeptill(Now+smalldt) )
				return()
		}
		# if ( $.sleeptill(Now+smalldt) )
		# 	return()
		for ( n=0; n<full; n++ ) {
			# print("IN FULL LOOP full=",full," n=",n)
			if ( $.recordloop(0,leng) ) {
				return()
			}
			if ( $.stayontill > 0 ) {
				till = Now + leng
			} else {
				till = Now + leng
			}
			# print("PAUSING TILL AFTER RECORDING leng=",leng," dtill=",till-Now)
			if ( $.pausetill(till) )
				return()
		}
		$.saveinputframe()
		$.saveoutputframe()
		finalsleep = pauseleng - leng
		if ( $.pausetill(finalsleep) )
			return()

	    } else {

		if ( effects ) $.loadpreset(fn0)
		if ( $.sleeptill(Now+smalldt) )
			return()
		if ( $.recordloop(0,leng) )
			return()

		if ( effects ) $.loadpreset(fn1)
		if ( $.sleeptill(Now+smalldt) )
			return()
		if ( $.recordloop(1,leng) )
			return()

		if ( effects ) $.loadpreset(fn2)
		if ( $.sleeptill(Now+smalldt) )
			return()
		if ( $.recordloop(2,leng) )
			return()

		if ( effects ) $.loadpreset(fn3)
		if ( $.sleeptill(Now+smalldt) )
			return()
		if ( $.recordloop(3,leng) )
			return()

		$.saveinputframe()
		$.saveoutputframe()

		if ( $.stayontill == 0 ) {
			if ( $.pausetill(Now+pauseleng) )
				return()
			if ( nostop == 0 )
				$.slowstop(slowstopdt)
		} else {
			if ( $.pausetill(leng) )
				return()
		}
	    }
	    if ( $.stayontill == 0 || $.stayontill <= Now ) {
		if ( times > 1 ) {
			times--
			print("CONTINUING times is now ",times)
			continue
		}
		break
	    }
	    # print("CONTINUING because of stayontill!")
	}
	$.stayontill = 0
}

method onewild(label,full,nostop) {

	$.settext(label)
	if ( $.pausetill(Now+2b) ) {
		$.cleartext()
		return()
	}
	$.cleartext()

	oldpause = $.nopause
	oldeffects = $.constanteffects
	$.constanteffects = Now + milliclicks(999*1000)
	$.nopause = Now + milliclicks(999*1000)
	$.effectinterval = 200
	$.onepass("",1,full,4b,0,4,nostop)

	$.effectinterval = $.defaultinterval
	$.constanteffects = oldeffects
	$.nopause = oldpause
}
method randomaction() {
	r = rand(4)
	print("RANDOM r=",r)
	if ( r == 0 ) {
		$.randompositions(1.0)
	} else if ( r == 1 ) {
		$.randomposition(1.0)
	} else if ( r == 2 ) {
		$.sendosc([0="/looper/nextloop"])
		$.sendosc([0="/looper/record",1=1])
		sleeptill(Now+milliclicks(2000))
		$.sendosc([0="/looper/record",1=0])
	} else if ( r == 3 ) {
		fn0 = $.getrandompreset()
		$.loadpreset(fn0)
	}
}
method autochange(atype,millis) {
	print("AUTOCHANGE START !  atype=",atype)
	for ( n=0; n<8; n++ ) {
		$.lesswindows()
	}
	for ( n=0; n<8; n++ ) {
		$.morewindows()
	}
	$.border = 1
	$.setborder()
	if ( atype == 1 ) {
		$.togglesmooth()
		$.timeblur(1)
		$.fulldisplay()
		millis = 5000
	} else if ( atype == 2 ) {
		$.togglesmooth()
		$.timeblur(0)
		$.quadrantdisplay()
		$.autonext = 1
		$.setautonext($.autonext)
	} else if ( atype == 3 ) {
		$.togglesmooth()
		$.timeblur(0)
		# $.quadrantdisplay()
		$.randompositions(1.0)
		$.autonext = 1
		$.setautonext($.autonext)
	} else {
		print("UNEXPECTED VALUE of atype!? ",atype)
	}
	state = 0
	while (1) {
		print("\nautochange loop state=",state)
		if ( atype == 1 ) {
			fn0 = $.getrandompreset()
			$.loadpreset(fn0)
			sleeptill(Now+milliclicks(millis))
		} else if ( atype == 2 ) {
			fn0 = $.getrandompreset()
			$.loadpreset(fn0)
			sleeptill(Now+milliclicks(400))
			if ( state < 4 ) {
				$.sendosc([0="/looper/record",1=1])
				sleeptill(Now+milliclicks(2000))
				$.sendosc([0="/looper/record",1=0])
			} else if ( state == 4 ) {
				sleeptill(Now+milliclicks(2000))
			} else if ( state >= 5 && state <= 12 ) {
				$.sendosc([0="/looper/record",1=1])
				sleeptill(Now+milliclicks(1000))
				$.sendosc([0="/looper/record",1=0])
				sleeptill(Now+milliclicks(1000))
			}
			state++
			if ( state > 12 )
				state = 0

		} else if ( atype == 3 ) {
			fn0 = $.getrandompreset()
			$.loadpreset(fn0)
			sleeptill(Now+milliclicks(400))
			if ( state < 7 ) {
				$.sendosc([0="/looper/record",1=1])
				sleeptill(Now+milliclicks(2000))
				$.sendosc([0="/looper/record",1=0])
				sleeptill(Now+milliclicks(100))
				$.randomposition(1.0)
				sleeptill(Now+milliclicks(100))
			} else if ( state < 8 ) {
				$.sendosc([0="/looper/record",1=1])
				sleeptill(Now+milliclicks(2000))
				$.sendosc([0="/looper/record",1=0])
				sleeptill(Now+milliclicks(100))
				$.randompositions(1.0)
				sleeptill(Now+milliclicks(100))
			}
			state++
			if ( state >= 8 )
				state = 0

		} else {
			print("Unexpected value of atype!? ",atype)
			sleeptill(Now+milliclicks(millis))
		}
	}
}
method autochange_old(atype,millis) {
	$.togglesmooth()
	for ( n=0; n<8; n++ ) {
		$.lesswindows()
	}
	for ( n=0; n<8; n++ ) {
		$.morewindows()
	}
	while (1) {
		if ( atype == 1 ) {
			$.randomposition(1.0)
			sleeptill(Now+milliclicks(millis))
		} else if ( atype == 2 ) {
			$.randompositions(1.0)
			sleeptill(Now+milliclicks(millis))
		} else if ( atype == 3 ) {
			$.randomaction()
			sleeptill(Now+milliclicks(millis))
		} else {
			print("Unexpected value of atype!? ",atype)
			sleeptill(Now+milliclicks(millis))
		}
	}
}
method autoloop() {

	$.settext("It's alive...")
	sleeptill(Now+$.dt)

	$.quadrantdisplay(1)
	$.setborderwidth(2)

	while ( 1 ) {

		$.onepass("Long Loops...",0,0,8b,16b,1,0)
		$.onepass("Long Loops with Effects...",1,0,8b,16b,1,0)
		$.onepass("Long Loop Fullscreen with Effects...",1,1,8b,16b,1,0)
		$.onepass("Medium Loops...",0,0,2b,8b,2,0)
		$.onepass("Medium Loops with Effects...",1,0,2b,8b,2,0)
		$.onepass("Medium Loop Fullscreen with Effects...",1,4,2b,8b,2,0)
		$.onepass("Short Loops...",0,0,1b/2,4b,4,0)
		$.onepass("Short Loops With Effects...",1,0,1b/2,4b,4,0)
		$.onepass("Short Loop Fullscreen With Effects...",1,8,1b/2,4b,4,0)

		$.setborderwidth(0)
		$.onewild("Total Chaos...",0,1)
		$.onewild("Total Chaos Fullscreen...",4,1)
		$.setborderwidth(2)
	}
}
method osctask() {
	while ( (d=get($.oscf)) != Eof ) {

		print("osctask got d=",d)
		addr = d[0]
		v = d[1]
		m = []
		# lock($)
		if ( addr ~~ "/mrmr/pushbutton/0/.*" ) {
			$.currloop(0)
			m = [0="/looper/record",1=(v>0)]
		} else if ( addr ~~ "/mrmr/pushbutton/1/.*" ) {
			$.currloop(1)
			m = [0="/looper/record",1=(v>0)]
		} else if ( addr ~~ "/mrmr/pushbutton/2/.*" ) {
			$.currloop(3)
			m = [0="/looper/record",1=(v>0)]
		} else if ( addr ~~ "/mrmr/pushbutton/3/.*" ) {
			$.currloop(2)
			m = [0="/looper/record",1=(v>0)]
		} else if ( addr ~~ "/mrmr/pushbutton/4/.*" ) {
			if ( v > 0 ) {
				$.randomizing = 1
			} else {
				$.randomizing = 0
			}
			$.dorandomizing()
		} else if ( addr ~~ "/mrmr/pushbutton/5/.*" ) {
			print("pushbutton 5? v=",v)
			m = [0="/looper/displayquadrants",1=(v==0)]
		} else if ( addr ~~ "/web/skip" ) {
			print("skip v=",v)
			$.skip = v
		} else if ( addr ~~ "/web/stay" ) {
			print("stay v=",v)
			$.stayontill = Now+milliclicks(v*1000)
		} else if ( addr ~~ "/web/constanteffects" ) {
			$.constanteffects = Now + milliclicks(v*1000)
			print("CONSTANTEFFECTS ON! = ",Now)
		} else if ( addr ~~ "/web/nopause" ) {
			$.nopause = Now + milliclicks(v*1000)
			print("NOPAUSE ON! = ",Now)
		}

		if ( sizeof(m) > 0 ) {
			$.sendosc(m)
		}
		$.lastosc = Now
		# unlock($)
			
	}
}

method delete {
	for ( jn in $.arr ) {
		$.j.unnotify($,jn)
	}
	if ( $.oscf > 0 )
		close($.oscf)
	close($.looper)
	kill($.autotid)
	if ( $.osctid > 0 )
		kill($.osctid)
	kill($.autochangetid)
}
method analogchange(jn,nm,v) {

	# Control current loop with D-pad

	oldmode = $.mode
	if ( nm == "Y" && v == 0 ) {	# up
		$.mode = "window"
	} else if ( nm == "X" && v == $.maxval ) {  # right
		if ( $.automation )
			$.mode = "auto"
		else
			$.mode = "movement"
	} else if ( nm == "Y" && v == $.maxval ) {  # down
		$.mode = "display"
	} else if ( nm == "X" && v == 0 ) {  # left
		$.mode = "options"
	}
	if ( v == 0 || v == $.maxval )
		print("MODE IS NOW: ",$.mode)
}

method togglerandomizing() {
	$.randomizing = 1 - $.randomizing
	$.dorandomizing()
}

method dorandomizing() {
	p = controller(1,3,127 * $.randomizing)
	p.port = VVVVOutput
	# print("sending to salvation p=",p)
	realtime(p)
	if ( $.randomizing ) {
		print("Randomizing is ON")
	} else {
		print("Randomizing is OFF")
	}
}

method sendvvvvcontroller(ch,ct,cv) {
	p = controller(ch,ct,cv)
	p.port = VVVVOutput
	# print("sending to VVVV p=",p)
	realtime(p)
}
method timeblur(v) {
	print("SENDING TIMEBLUR ENABLE v=",v)

	if ( v == 0.0 ) {
		$.sendosc([0="/looper/enableplugin",1=$.timeblurdll,2=0])
	} else {
		$.sendosc([0="/looper/enableplugin",1=$.timeblurdll,2=2])
		$.sendosc([0="/looper/pluginparam",1=$.timeblurdll,2="time",3=v])
	}
}
method turneffectonoff(eff,onoff) {
	if ( onoff ) {
		$.effecton[eff] = 1
	} else {
		delete $.effecton[eff]
	}
	e = $.effects[eff]
	dll = eff + ".dll"
	$.sendosc([0="/looper/enableplugin",1=dll,2=onoff])
	# $.sendvvvvcontroller(e["ch"],e["ct"],onoff*127)
}

method noeffects() {
	print("NOEFFECTS")
	for ( eff in $.effects ) {
		if ( ("norand" in $.effects[eff]) )
			continue
		$.turneffectonoff( eff, 0 )
	}
}

method effectnumbered(n) {
	nr = 0
	for ( eff in $.effects ) {
		if ( nr == n ) {
			return(eff)
		}
		nr++
	}
	return("")
}

method randomeffects(nr) {
	if ( nargs() < 1 )
		nr = 3
	neffects = sizeof($.effects)
	if ( nr > neffects )
		nr = neffects
	# $.noeffects() 
	print("RANDOMEFFECTS!  nr=",nr)
	$.effecton = []
	for ( n=0; n<nr; n++ ) {
		rr = rand(neffects)
		eff = $.effectnumbered(rr)
		while ( (eff in $.effecton) || ("norand" in $.effects[eff]) ) {
			rr = rand(sizeof($.effects))
			eff = $.effectnumbered(rr)
		}
		print("Choosing eff=",eff)
		$.effecton[eff] = 1
	}
	for ( eff in $.effects ) {
		if ( "norand" in $.effects[eff] )
			continue
		if ( eff in $.effecton ) {
			$.turneffectonoff( eff, 1 )
			$.randomparams1(eff)
		} else {
			$.turneffectonoff( eff, 0 )
		}
	}
}

method randomparams() {
	for ( eff in $.effecton ) {
		print("Randomizing params of eff=",eff)
		$.randomparams1(eff)
	}
}

method randomparams1(eff) {
	e = $.effects[eff]
	if ( ! ( "params" in e ) ) {
		print("No params in eff=",eff," ??")
		return()
	}
	# print("PARAMS = ",e["params"])
	for ( prm in e["params"] ) {
		pp = e["params"][prm]
		cv = rand(128)
		cv = cv / 127.0
		# if ( ("min" in pp) && ("max" in pp) ) {
		# 	mn = pp["min"]
		# 	mx = pp["max"]
		# 	cv = mn + rand(mx-mn)
		# 	# print("Using min/max for eff=",eff," cv=",cv)
		# } else {
		# 	cv = rand(128)
		# }
		# print("Eff=",eff,"  Param=",prm," cv=",cv)
		$.effects[eff]["params"][prm]["curr"] = cv
		dll = eff+".dll"
		$.sendosc([0="/looper/pluginparam",1=dll,2=prm,3=cv])

		# $.sendvvvvcontroller(pp["ch"],pp["ct"],cv)
	}
}

method newpresetname() {
	n = $.numpresets
	while ( 1 ) {
		fn = "preset_"+string(n)+".lpy"
		if ( ! fileexists(fn) ) {
			return(fn)
		}
		n++
	}
}

method savepreset() {
	fn = $.newpresetname()
	print("SAVEPRESET fn=",fn)
	f = open(fn,"w")
	for ( eff in $.effecton ) {
		e = $.effects[eff]
		put(f,"e:"+eff+"\n")
		for ( prm in e["params"] ) {
			pp = e["params"][prm]
			if ( ! ("curr" in pp) ) {
				print("No current value for param=",prm," ??")
			} else {
				put(f,"p:"+prm+":"+string(pp["curr"])+"\n")
			}
		}
	}
	close(f)
	$.presetnames[fn] = 1
}

method loadpresetnames(dir) {
	print("LOADPRESETNAMES dir=",dir)
	$.presetnames = []
	for ( fn in lsdir(dir) ) {
		if ( fn ~~ ".*\\.lpy$" ) {
			$.presetnames[dir+"\\"+fn] = 1
		}
	}
	print("PRESETNAMES = ",$.presetnames)
}
method getrandompreset(fn0,fn1,fn2) {
	if ( nargs() < 3 )
		fn2 = ""
	if ( nargs() < 2 )
		fn1 = ""
	if ( nargs() < 1 )
		fn0 = ""
	while ( 1 ) {
		fn = $.randompresetname()
		if ( fn == "" ) {
			print("No presets!?")
			return("")
		}
		if ( fn!=fn0 && fn!=fn1 && fn!=fn2 ) {
			break
		}
	}
	return(fn)
}

method loadpreset(fn) {

	$.noeffects()
	f = open(fn,"r")
	if ( f < 0 ) {
		print("Can't load fn=",fn)
		return()
	}
	print("LOADING PRESET fn=",fn)
	curreff = ""
	while ( (line=get(f)) != Eof ) {
		w = split(line,":")
		# print("line=",line," w=",w)
		if ( w[0] == "e" ) {
			curreff = w[1]
			$.turneffectonoff( curreff, 1 )
		} else if ( w[0] == "p" ) {
			prm = w[1]
			cv = float(w[2])
			if ( curreff == "" ) {
				print("Hey, no curreff?")
				continue
			}
			pp = $.effects[curreff]["params"][prm]
			# print("Loading curreff=",curreff," prm=",prm,"  effarr=",$.effects[curreff])
			$.effects[curreff]["params"][prm]["curr"] = cv

			dll = curreff+".dll"
			$.sendosc([0="/looper/pluginparam",1=dll,2=prm,3=cv])
		}
	}
	close(f)
}

method randompresetname() {
	rn = rand(sizeof($.presetnames))
	r = 0
	for ( fn in $.presetnames ) {
		if ( r == rn )
			return(fn)
		r++
	}
	return("")
}

method setborderwidth(v) {
	$.sendosc([0="/looper/borderwidth",1=v])
}

method saveinputframe() {
	# $.sendosc([0="/looper/saveinputframe",1=$.currloop])
}
method saveoutputframe() {
	# $.sendosc([0="/looper/saveoutputframe",1=$.currloop])
}

method buttonchange(jn,nm,v) {
	dirmap = ["TRIANGLE" = "D", "SQUARE" = "U", "X" = "L", "CIRCLE" = "R"]
	dir = dirmap[nm]
	$.lastjoy = Now
	m = []
	print ("buttonchange mode=",$.mode," nm=",nm,"  dir=",dir,"  v=",v)
	$.ispressed[nm] = v

	if ( $.ispressed["R1"] && $.ispressed["L1"] && $.ispressed["L2"] ) {
		print("SHOULD BE RESTARTING!!?? ispressed=", $.ispressed)
		f = open("c:\\local\\ata\\restart.do","w")
		put(f,"hello\n")
		close(f)
		return()
	}

	if ( nm == "R1" ) {
		if ( $.ispressed["L1"] ) {
			# $.sendosc([0="/looper/newposition",1=$.currloop])
			$.sendosc([0="/looper/recordoverlay",1=(v==1)])
		} else {
			$.sendosc([0="/looper/record",1=(v==1)])
		}
		if ( v )
			$.anypressed = 1
		return()
	}
	if ( nm == "R2" ) {
		if ( v == 0 ) {
			if ( $.anypressed ) {
				print("Something else was pressed, do nothing?")
			} else {
				$.sendosc([0="/looper/nextloop"])
			}
		} else {
			$.anypressed = 0
		}
		return()
	}
	if ( nm == "L1" ) {
		# PRESET stuff
		if ( v ) {
			if ( $.ispressed["L2"] ) {
				print("L2-L1 PRESSED, slow move")
				$.moveamount -= 4
				if ( $.moveamount < 2 )
					$.moveamount = 2
				$.setmoveamount()
				$.anypressed = 1
			} else {
				$.anypressed = 0
			}
		} else {
			if ( $.anypressed == 0 ) {
				print("Randomizing preset")
				fn0 = $.getrandompreset()
				if ( fn0 != "" )
					$.loadpreset(fn0)
			} else {
				print("DO NOTHING")
			}
		}
		return()
	}
	if ( nm == "L2" ) {
		# EFFECTS stuff
		if ( v ) {
			if ( $.ispressed["L1"] ) {
				print("L2-L1 PRESSED, fast move")
				$.moveamount += 4
				if ( $.moveamount > 30 )
					$.moveamount = 30
				$.setmoveamount()
				$.anypressed = 1
			} else {
				$.anypressed = 0
			}
		} else {
			if ( $.anypressed == 0 ) {
				print("Randomizing parameters")
				$.randomparams()
			} else {
				print("DO NOTHING")
			}
		}
		return()
	}

	if ( $.ispressed["L1"] ) {
		# Preset actions
		print("PRESET ACTION dir = ",dir)
		if ( v == 0 ) {
			return()
		}
		if ( dir == "D" ) {
		} else if ( dir == "L" ) {
			$.loadpresetnames("mild_presets")
		} else if ( dir == "U" ) {
			print("SAVE PRESET")
			$.savepreset()
			$.anypressed = 1
		} else if ( dir == "R" ) {
			$.loadpresetnames("bold_presets")
		}
		return()
	}
	if ( $.ispressed["L2"] ) {
		# Effects actions
		if ( v == 0 ) {
			return()
		}
		if ( dir == "D" ) {
			$.noeffects()
			# $.randomeffects(3)
		} else if ( dir == "L" ) {
			# $.randomeffects(1)
			if ( $.dotimeblur < 0.2 ) {
				$.dotimeblur = 0.0
			} else {
				$.dotimeblur -= 0.05
			}
			$.timeblur($.dotimeblur)
		} else if ( dir == "U" ) {
			$.randomeffects(2)
		} else if ( dir == "R" ) {
			if ( $.dotimeblur >= 1.0 ) {
				$.dotimeblur = 1.0
			} else {
				$.dotimeblur += 0.05
			}
			# $.dotimeblur = 1 - $.dotimeblur
			$.timeblur($.dotimeblur)
		}
		$.anypressed = 1 # so letting up L2 doesn't randomize params
		return()
	}

	else if ( $.mode == "display" ) {
	    if ( v > 0 ) {
		if ( dir == "D" ) {
			$.randompositions(1.0)
		} else if ( dir == "R" ) {
			# $.randomposition(1.0)
			$.randomposition1(1.0)
		} else if ( dir == "L" ) {
			$.quadrantdisplay()
		} else if ( dir == "U" ) {
			$.fulldisplay()
		}
	    }
	}
	else if ( $.mode == "auto" ) {
	    if ( v > 0 ) {
		if ( dir == "D" ) {
			kill($.autochangetid)
		} else if ( dir == "R" ) {
			kill($.autochangetid)
			$.autochangetid = task $.autochange(3,1000)
		} else if ( dir == "L" ) {
			kill($.autochangetid)
			$.autochangetid = task $.autochange(1,1000)
		} else if ( dir == "U" ) {
			kill($.autochangetid)
			$.autochangetid = task $.autochange(2,1000)
		}
	    }
	}
	else if ( $.mode == "movement" ) {
	    if ( v > 0 ) {
		if ( dir == "D" ) {
			# $.sendosc([0="/looper/movement",1=0])
		} else if ( dir == "R" ) {
			# $.sendosc([0="/looper/movement",1=1])
		} else if ( dir == "L" ) {
			# $.sendosc([0="/looper/movement",1=2])
		} else if ( dir == "U" ) {
			# $.sendosc([0="/looper/movement",1=3])
			$.savepreset()
		}
	    }
	}
	else if ( $.mode == "window" ) {
	    if ( v > 0 ) {
		if ( dir == "D" ) {
			$.alllive()
			# $.setsizefactor(0.9)
		} else if ( dir == "R" ) {
			$.morewindows()
		} else if ( dir == "L" ) {
			$.lesswindows()
		} else if ( dir == "U" ) {
			# $.setsizefactor(1.1)
		}
	    }
	}
	else if ( $.mode == "options" ) {
	    if ( v > 0 ) {
		if ( dir == "D" ) {
			$.togglesmooth()
		} else if ( dir == "L" ) {
			$.xor = 1 - $.xor
			$.setxor($.xor)
		} else if ( dir == "R" ) {
			$.autonext = 1 - $.autonext
			$.setautonext($.autonext)
		} else if ( dir == "U" ) {
			$.border = 1 - $.border
			$.setborder()
			# $.alllive()
		}
	    }
	}
	else if ( $.nm == "X" ) {
		print("OLD UNUSED CODE A!?!??")
		$.anypressed = 1
		if ( v > 0 ) {
			if ( $.ispressed["L2"] ) {
				print("ONE EFFECT")
				$.randomeffects(1)
			} else if ( $.ispressed["L1"] ) {
				print("PREV PRESET")
			} else {
				$.isplaying[$.currloop] = 2
				$.sendosc([0="/looper/play",1=$.currloop,2=$.isplaying[$.currloop]])
			}
		}
	}
	else if ( nm == "CIRCLE" ) {   # aka B or 2
		print("OLD UNUSED CODE B!?!??")
		$.anypressed = 1
		if ( v > 0 ) {
			if ( $.ispressed["L2"] ) {
				print("3 EFFECTS")
				$.randomeffects(3)
			} else if ( $.ispressed["L1"] ) {
				print("NEXT PRESET")
			} else {
				print("RESTART LOOP ",$.currloop)
				$.sendosc([0="/looper/restart",1=$.currloop])
			}
		}
	}
	else if ( nm == "SQUARE" ) {   # aka A or 4

		print("OLD UNUSED CODE C!?!??")
		$.anypressed = 1

		if ( v > 0 ) {
			if ( $.ispressed["L2"] ) {
				print("2 EFFECTS")
				$.randomeffects(2)
			} else if ( $.ispressed["L1"] ) {
				print("SAVE PRESET")
				$.savepreset()
			} else {
				print("START PLAYING LOOP ",$.currloop)
				# start playing
				$.isplaying[$.currloop] = 1
				$.sendosc([0="/looper/play",1=$.currloop,2=$.isplaying[$.currloop]])
			}
		}
	}
	else if ( nm == "TRIANGLE" ) {   # aka C or 1
		print("OLD UNUSED CODE D!?!??")
		$.anypressed = 1
		if ( v > 0 ) {
			if ( $.ispressed["L2"] ) {
				$.noeffects()
			} else if ( $.ispressed["L1"] ) {
				print("FIRST PRESET")
			} else {
				print("STOP PLAYING LOOP ",$.currloop)
				# stop playing
				$.sendosc([0="/looper/play",1=$.currloop,2=0])
				$.isplaying[$.currloop] = 0
			}
		}
	}
	else {
		print("No action for nm=",nm)
	}
	if ( sizeof(m) > 0 ) {
		print("HEY, you forget a sendosc!!")
		# $.sendosc(m)
	}
}
}
