

# Fonctions de distortion:
#-------------------------
# Si l'on veut utiliser les Volume[], Pit[], Dur[], Pan[], PB[],
#
#  utiliser les fonctions:	 UseMIDI_dur(lsco, pan, dist, ch) 
#				 UseMIDI_vol(lsco, pn, min, max, pan, dist, ch)
#				 UseMIDI_pit(lsco, pn, min, max, pan, dist, ch)
#				 UseMIDI_pan(lsco, pn, min, max, pan, dist, ch)
#
# ce qui a pour effet de faire agir les fonctions de distortion sur le param�tre num�ro pn
# en mettant l'intervalle [0..127] � l'�chelle [min..max]
#
# pour Dur, c'est automatiquement p3 qui est utilis�; les Clicks sont traduits en secondes
# (ce qui est �quivalent � un "t 0 60" au d�but du score)
#
# Attention: il n'y a pas de corr�lation avec le nodur �ventuel du m�me �v�nement.
# Autrement dit, si Vol d�pend de nodur.vol mais aussi de nodur.dur (ce qui est permis pour
# le MIDI), �a ne marchera pas (nodur.dur sera toujours 96)
# Autrement dit encore, les fonctions de distortion doivent �tre "pures" pour �tre utilis�e 
# en mode CSound (mais rien n'emp�che d'�crire une fonction CScore tordue..)

function NoScore() {return ([0=0])}

function UseMIDI_dur(lsco, pan, dist, ch)
{
	p3 = SCgetpn(lsco, 3)
	artph = phrase("'ad"+string(integer(seconds(1)*p3))+"'")
	ddur = efunction(Dur[ch])(artph, pan, dist, ch)	
	return (SCpn(lsco, 3, p3+ddur/float(seconds(1))))
}
function UseMIDI_vol(lsco, pn, min, max, pan, dist, ch)
{
	pvol = SCgetpn(lsco, pn)
	artvol = 127*(pvol-min)/float(max-min)
	artph = phrase("'ad"+string(artvol)+"'")
	dvol = efunction(Volume[ch])(artph, pan, dist, ch)
	return (SCpn(lsco, pn, min+(max-min)*(dvol+artvol)/float(127)))
}
function UseMIDI_pit(lsco, pn, min, max, pan, dist, ch)
{
	ppit = SCgetpn(lsco, pn)
	artpit = 127*(ppit-min)/float(max-min)
	dpit = efunction(Pit[ch])(phrase("'ad"+string(artpit)+"'"), pan, dist, ch)
	return (SCpn(lsco, pn, min+(max-min)*(dpit+artpit)/float(127)))
}
function UseMIDI_pan(lsco, pn, min, max, pan, dist, ch)
{
	ppan = SCgetpn(lsco, pn)
	artpan = 127*(ppan-min)/float(max-min)
	dpan = efunction(Pan[ch])(phrase("'ad"+string(artpan)+"'"), pan, dist, ch)
	return (SCpn(lsco, pn, min+(max-min)*(dpan+artpan)/float(127)))
}

############################################################################################


# Exemple de fonction CScore bas�e sur les fonctions de distortion MIDI:
# -----> il faut r�gler les param�tres (9 par instrument) 
#	 en fonction de l'orchestre CSound

function UseMIDI(tsco,fvol,fpan,fpit,fdur,fpb,nodur,pan,dist,ch)	
{
	pvol = []; volmin = []; volmax = []
	ppit = []; pitmin = []; pitmax = []
	ppan = []; panmin = []; panmax = []

	####################################################
	#          � adapter aux l'instruments !!          #
	#					           #
	# exemple idiot pour 3 instruments:
	#  (qui auraient les m�mes param�trages)
	for (i=1; i<=3; i++)
	{
	  pvol[i] = 4 ; volmin[i] = 0 ;	  volmax[i] = 100 
	  ppit[i] = 5 ; pitmin[i] = 500 ; pitmax[i] = 5000
	  ppan[i] = 6 ; panmin[i] = 0 ;	  panmax[i] = 10
	}
	#					           #
	####################################################

	for (l=1; l<= tsco[0]; l++)
	{
		p1 = integer(split(tsco[l],"i. \t")[0])	

		lsco = UseMIDI_dur(tsco[l], pan, dist, ch)
		lsco = UseMIDI_vol(lsco, pvol[p1], volmin[p1], volmax[p1], pan, dist, ch)
		lsco = UseMIDI_pit(lsco, ppit[p1], pitmin[p1], pitmax[p1], pan, dist, ch)
		lsco = UseMIDI_pan(lsco, ppan[p1], panmin[p1], panmax[p1], pan, dist, ch)
		tsco[l] = lsco
	}
	return (ArCopy(tsco))
}

# fin de la partie "distribution" 
#############################################################################################
# d�but de la partie "d�merdez-vous"


function CStest(tsco,fvol,fpan,fpit,fdur,fpb,nodur,pan,dist,ch)	
{
	pvol = []; volmin = []; volmax = []
	ppit = []; pitmin = []; pitmax = []
	ppan = []; panmin = []; panmax = []

	####################################################
	#          � adapter aux l'instruments !!          #
	#					           #
	# exemple idiot pour 3 instruments:
	#  (qui auraient les m�mes param�trages)
	for (i=1; i<=3; i++)
	{
	  pvol[i] = 4 ; volmin[i] = 0 ;	  volmax[i] = 100 
	  ppit[i] = 5 ; pitmin[i] = 100 ; pitmax[i] = 1000
	  ppan[i] = 6 ; panmin[i] = -10 ; panmax[i] = 10
	}
	#					           #
	####################################################

	for (l=1; l<= tsco[0]; l++)
	{
		p1 = integer(split(tsco[l],"i. \t")[0])	

		lsco = UseMIDI_dur(tsco[l], pan, dist, ch)
		lsco = UseMIDI_vol(lsco, pvol[p1], volmin[p1], volmax[p1], pan, dist, ch)
		lsco = UseMIDI_pit(lsco, ppit[p1], pitmin[p1], pitmax[p1], pan, dist, ch)
		lsco = UseMIDI_pan(lsco, ppan[p1], panmin[p1], panmax[p1], pan, dist, ch)
		tsco[l] = lsco
	}
	return (ArCopy(tsco))
}





function SCExample(tsco,fvol,fpan,fpit,fdur,fpb,nodur,pan,dist,ch)	# voil� les param�tres !
{
	# tsco est un array !

	if (nodur == '')		# cas o� le score est tout seul
	{

	}

	else				# il y a aussi un nodur dans l'�v�nement
	{

	}
}


























