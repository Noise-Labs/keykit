


###########################################################################################
########						   ################################
######## Choix de patches                            	   ################################
########						   ################################
###########################################################################################

# Format d'un choix de patches: (d�fini dans un fichier .choix)
#------------------------------
# Patch[0]		nbe de patches
# Patch[n]["LSB"]
# Patch[n]["ACn"]
# Patch[n]["low"]	note la plus basse	
# Patch[n]["hig"]	note la plus haute
# Patch[n]["dmin"]	dur�e minimale
# Patch[n]["dmax"]	dur�e maximale
# Patch[n]["vmin"]	volume minimal
# Patch[n]["vmax"]	volume maximal

function RandomMix(choix, nbinst, dispersion, ...)	# retourne une phrase al�atoire 
							# de nbinst notes
							# extraites de "choix", 
							# d�butant chacune dans "dispersion"
# (le r�sultat utilise les canaux 17-nbinst � 16, sauf si (...) donne le premier canal)
{
	if (nargs()==3) {ch1 = 17-nbinst; chf = 16}
	else {ch1 = argv(3); chf = Minimum(ch1+nbinst-1, 16)} 

	ph = ''
	for (m = ch1; m <= chf; m++)	
	{
		ins = rand(1, choix[0])

		ini = PourAC(choix[ins]["LSB"], choix[ins]["ACn"], m)
		
		pitch = rand(choix[ins]["low"], choix[ins]["hig"])
		vol = rand(choix[ins]["vmin"], choix[ins]["vmax"])
		dur = rand(choix[ins]["dmin"], choix[ins]["dmax"])
		
		add = makenote(pitch, dur, vol, m)
		add.time = rand(100)*0.01*dispersion
		
		ph |= (ini+add)
	}
	return (ph)
}



# D�finition d'un choix de patches:
#  (voir un fichier .choix comme exemple)

function ReadPatches(fnom, dir)		# lit un fichier d�finissant un ensemble de patches
					# et leurs param�tres d'utilisation
					# (dir optionnel)
{
	if (nargs() == 1) dir = COMPOS

	res = []
	n = 0
	f = open(dir+fnom+".choix")
	while ((ligne = get(f)) != Eof)
	{
	   if ((p = split(ligne, "\t"))[0] != "\r")
	   {
	      if (substr(p[0],1,1) != "#")
	      {
		n += 1
		res[n]=["LSB" = integer(p[0])]		# LSB (num�ro de banque AC)
		res[n]["ACn"] = integer(p[1])		# num�ro dans la banque AC
		res[n]["low"] = integer(p[2])		# note la plus basse	
		res[n]["hig"] = integer(p[3])		# note la plus haute

		if (substr(p[4],1,1) == ".")		# (indications sp�ciales de dur�e)
		{
		  pv = 5
		  if (p[4] == ".long")
		  {
			res[n]["dmin"] = seconds(1)		
			res[n]["dmax"] = seconds(5)			
		  }
		  else if (p[4] == ".court")
		  {
			res[n]["dmin"] = seconds(0.25)		
			res[n]["dmax"] = seconds(0.5)		
		  }
		  else						# (d�faut)
		  {
			res[n]["dmin"] = seconds(0.25)
			res[n]["dmax"] = seconds(1)
		  }
		}					
		else
		{ 
		  res[n]["dmin"] = integer(p[4])		# dur�e minimale
		  res[n]["dmax"] = integer(p[5])		# dur�e maximale	
		  pv = 6
		}
		
		if (substr(p[pv],1,1) == ".")		# (indications sp�ciales de volume)
		{
			res[n]["vmin"] = 20
			res[n]["vmax"] = 100
		}
		else
		{
		  res[n]["vmin"] = integer(p[pv])		
		  res[n]["vmax"] = integer(p[pv+1])			
		}	

		Bprint("Patch",n,":",res[n])
	      }
	   }
	}
	close(f)
	res[0] = n

	return (res)
}



###########################################################################################
########						   ################################
######## ACpatchmap() pour lib/maps.                   	   ################################
########						   ################################
###########################################################################################


function ACpatchmap()		# appel�e par patchmap() si ACPATCHES > 0
{
	InitACPat()

	list = []
	for (n = 1; n <= ACPat[0]; n++) list[n-1]=["num"= n,"name" = ACPat[n]["nom"] ]

	return (list)
}


function InitACPat()		
{
	if ( ACPATCHES == 0 )
		return()

	ACPat = []
	ind = 0

	datafilename = DATA+"ACpatchmap"+string(ACPATCHES)+".txt"
	f = open(datafilename)

	while ((ligne = get(f)) != Eof) 
	{
		ligne = split(ligne, "\r")[0]		# supression du "\r" �ventuel
		mots = split(ligne, "\t")

		if ((sizeof(mots) >= 3) && (substr(mots[0],1,1) != "#"))
		{
			ind += 1
			ACPat[ind] = ["nom"=mots[0],"lsb"=integer(mots[1]),"pat"=integer(mots[2])]
		}
	}
	ACPat[0] = ind
}
