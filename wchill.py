import sys

temp=int(sys.argv[1])
wind=int(sys.argv[2])
hum=int(sys.argv[3])

if temp < 50:
	rf = 35.74+(.6215*temp)-(35.75*(wind**.16))+(.4275*(temp*(wind**.16)))
else:
	rf = (2.04901523*temp)+(10.14333127*hum)-(0.22475541*temp*hum)-(.00683783*(temp**2))-(.05481717*(hum**2))+(.00122874*(temp**2)*hum)+(.00085282*temp*(hum**2)) -(.00000199*(temp**2)*(hum**2))-42.379
	
comment="No Danger"
if(rf < -19): 
	comment="Frostbite in 30 mins"
if(rf < -33): 
	comment="Frostbite in 10 mins"
if(rf < -48): 
	comment="Frostbite in 5 mins"
if(rf > 82): 
	comment="Heat Stress in 45 min"
if(rf > 85):      
	comment="Heat Stress in 30 min"
if(rf > 88):      
	comment="Heat Stress in 20 min"	
if(rf > 90):      
	comment="Heat Stress in 15 min"
	
print("Real Feel = {0:.2f} degF - ".format(rf),comment)
