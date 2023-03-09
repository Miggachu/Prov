from flask import Flask, render_template
import sqlite3
con = sqlite3.connect("Porvoo.db")

cur = con.cursor()

cur.execute('SELECT * FROM top5')

data = cur.fetchall() 
con.close()

con = sqlite3.connect("Porvoo.db")

cur = con.cursor()

cur.execute('SELECT HEX FROM hexcol')

  
colors = cur.fetchall()
  
con.close()
   
app = Flask(__name__)

@app.route("/")
def home():

  labels =[]
  values =[]
  color =[]
  for row in data:
    labels.append(row[1])
  for row in data:
    values.append(row[2])
  for row in colors:
    color.append("#"+row[0])

  #För att debugga jinjan
  #labels = [row[0] for row in data]
  #values = [row[1] for row in data]
  
  #return data
  return render_template("graph.html", labels=labels, values=values, color=color) 

#if__name__== "__main__":app.run(port=8000, debug=True)
