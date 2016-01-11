#Gert Sterenborg & Job de Pater
#11 January 2016

source("R/mainScripts.R")

#The assignment:
mainFunction()

#Bigger buffer (5km):
mainFunction(bufferWidth = 5000)

#All the places within 500m around subways:
mainFunction(railType = "subway", bufferWidth = 500)