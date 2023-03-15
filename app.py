#Steg 1: Installera en viritualenv Genom att använda virtualenv kan du undvika att installera Python-paket globalt som kan bryta systemverktyg eller andra projekt. 
#Steg 2: Skapa en virituell miljö genom att gå in i VS code och med (Ctrl+Shift+P) så kan du ta dig till Command Palette, bärja skriva in Python: Create Environment 
# och i drop down listan som visas så väljer du (Venv) som skapar och aktiverar en .venv virituell miljö. 
#Steg 3: Installera Flask (python3 -m pip install flask)

#När vi har installerat flask paketet så måste vi importera Flask från flask paketet
from flask import Flask, render_template

#import sqlite3-satsen importerar sqlite3-modulen i programmet. 
# Med de klasser och metoder som definieras i sqlite3-modulen kan vi kommunicera med SQLite-databasen.
import sqlite3

# Man använder connect(databas namn) metoden för att upprätta en anslutning till SQLite så måste vi fylla in vårt databasnamn vi vill 
# ansluta till om man anger databas filnamnet till en databas som redan existerar på datorn kommer den att ansluta till den 
# men om den angivna databasen inte existerar kommer SQLite skapa en ny åt dig, den här metoden returnerar SQlite Connection Object 
# om anslutningen lyckas.
con = sqlite3.connect("Porvoo.db")

# cursor() metoden skapar ett cursor objekt för att köra SQLite queries/kommandon.
cur = con.cursor()

# cur.execute() metoden kommer att köra köra vår query och returnera vårt resultat
# i vårt fall kommer den att hämta all data från (tabell namn) tabellen med hjälp av SELECT *. 
cur.execute('SELECT * FROM top5')

# För att kunna läsa vårt query resultat så använder vi oss av metoden fetchall().
data = cur.fetchall()
 
# Close() metoden kommer att stänga av uppkopplingen till databasen när arbetet är klart
# och frigör uppkopplingen till framtida operationer.
con.close()

# (Se rad 13-31 )
con = sqlite3.connect("Porvoo.db")

cur = con.cursor()

cur.execute('SELECT HEX FROM hexcol')


colors = cur.fetchall()
  
con.close()
#(Se rad 13-31)

# Skapar en flask application med namnet app.
# Tanken med den första parametern är att ge Flask en uppfattning om vad som hör till din applikation.
# Detta namn används för att hitta resurser i filsystemet, kan användas av tillägg för att förbättra felsökningsinformation och mycket mer.
#Så det är viktigt vad du tillhandahåller där. Om du använder en enskild modul är __name__ alltid det korrekta värdet.
app = Flask(__name__)

#I vår applikation är URL-adressen ("/") associerad med vår rot-URL.
# Så om vår webbplats domän var www.exampl.com och vi vill lägga till routing till "www.exampl.com/hello",
# så skulle vi använda "/hello".
@app.route("/")

# skapar/definerar funktionen (home)
def home():

# Variablar med tomma arreys som vi använder oss av för att föra in värden i följande for loop.
  labels =[]
  values =[]
  color =[]
 
 # Andra raden i vår top5 tabell skrivs till  label variabeln
 # raderna börjar alltid med 0 så i vårt fall är det 0-2.
  for row in data:
    labels.append(row[1])
    
 # Tredje raden i vår top5 tabell skrivs till values variabeln.
  for row in data:
    values.append(row[2])
    
 #Första raden i vår color tabell skrivs till color variabeln, och lägger till ett # så att hexadicimal färgerna kan läsas av.
  for row in colors:
    color.append("#"+row[0])
  
  # returnerar data till vår render template (graph.html) och kopplar ihop parametrarna med argumenten.
  return render_template("graph.html", labels=labels, values=values, color=color) 

# __name__ är en inbyggd specialvariabel som utvärderar namnet på den aktuella modulen. 
# Om källfilen körs som huvudprogram, ställer tolken in variabeln __name__ att ha värdet "__main__". 
# app.run(port=8000, debug=True) startar appen via den lokala porten 8000 och sätter på debug mode.
if __name__== "__main__":
  app.run(port=8000, debug=True)
