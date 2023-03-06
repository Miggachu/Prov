from flask import Flask, render_template
import sqlite3
app = Flask(__name__)

@app.route("/")
def home():
  data = [
          ("01-01-2020", 1597),
          ("02-01-2020", 1456),
          ("03-01-2020", 1908),
          ("04-01-2020", 896),
          ("05-01-2020", 755),
  ]
  
  
  color = ["#059bf", 
           "#ffc234", 
           "#22cfcf", 
           "#ff4069", 
           "#ff9020"]
          
          
       
  

  labels = [row[0] for row in data]
  values = [row[1] for row in data]
  
  #return data
  return render_template("graph.html", labels=labels, values=values, color=color) 


#if__name__=="__main__":
   #app.run(port=8000, debug=True)



