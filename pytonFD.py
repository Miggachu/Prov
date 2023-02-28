from flask import Flask, render_template
import sqlite3
app = Flask (_name_)
@app.route("/")
def home():
     data = [
         ("01-01-2020", 1597),
         ("02-01-2020", 1456),
         ("03-01-2020", 1908),
         ("04-01-2020", 896),
         ("05-01-2020", 755),
         ("06-01-2020", 355),
         ("07-01-2020", 155),
         ("08-01-2020", 145),
         ("09-01-2020", 725),
     ]

     
    
    labels = [row[0] for row in data]
    values = [row[1]for row in data]
    labels = []
    values = []
    for row in data:
        labels.append(row[0])
        values.append(row[1])
   #return data
   return render_template("graph.html", labels=labels, values=values)



if_name_== "_main_":
  app.run(port=8000, debug=True)