from flask import Flask , render_template,jsonify,request
from pymongo import MongoClient
from bson.json_util import dumps
from bson.objectid import ObjectId
import pymongo
import os

app = Flask(__name__)

def get_db():
    client=MongoClient(host="tennis_mongodb",port=27017,username="root",password="Aa123456",authSource="admin")

    db= client ["ranklistdb"]
    return db

@app.route("/")
def Home_Website():
    return render_template('index.html')

@app.route("/players")
def fetch_players():
    db =    get_db()
    _players= db.ranklisttb.find()
    players = [{"id": player["id"],"name": player["name"],"Rank": player["Rank"],"nationality":player["nationality"]}  for player in _players]
    return jsonify({"players":players})
            

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5000)



