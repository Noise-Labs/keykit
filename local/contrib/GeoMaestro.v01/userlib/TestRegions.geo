#points

Or 0 0
p II 1 0

AA 3 3
BB -3 -3

CC -5 5
DD 5 -5

Chh -3 -7
Ch -2 -7
Ch2 3 -7


Z -10 5

Loin -5 -7

#fin

#cercles

Cer3 Or 3
Cer05 Or 0.5
CBB4  BB 4

#fin



#regions

# pour le moment, les points doivent �tre d�sign�s par leur noms
# (donc avoir �t� d�finis dans la section #points, par exemple)

t Joe AA BB Ch2         # triangle nomm� Joe

d Jack Or 2             # disque

r John AA BB            # rectangle


t T1 Ch Chh BB          # T1 intersection de T1, T2 et T3
ET t T2 Ch Ch2 AA
ET t T3 AA BB Ch

d D2 Chh 1              # D2 r�union de D2 et D1
OU d D1 Ch 1

Jack                    # Jack devient la r�union de Jack et de D1
OU d D1 Ch 1
 
t- T1 Ch Chh BB         # les compl�mentaires sont: t-, d- et r-
ET t- T2 Ch Ch2 AA
ET t T3 AA BB Ch


Mecs : Joe              # Mecs est la r�union de Joe, John et Jack
OU John
OU Jack


#fin

