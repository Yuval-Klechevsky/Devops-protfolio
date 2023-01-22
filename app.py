from flask import Flask , render_template,jsonify,request
from pymongo import MongoClient
from bson.json_util import dumps
from bson.objectid import ObjectId
import pymongo
import os

app = Flask(__name__)

def get_db():
    client=MongoClient(host='mongodb://root:Aa123456@mongodb:27017/GYM_mongodb',port=27017,username="root",password="Aa123456",authSource="admin")


    db= client ["GYM_mongodb"]
    return db

@app.route("/")
def Home_Website():
    return render_template('index.html') 

@app.route("/subscriptions")
def fetch_subscriptions():
    db = get_db()
    _subscriptions= db["GYM_mongodb_tb"].find()
    subscriptions = [{"id": subscription["id"],"first_name": subscription["first_name"],"last_name": subscription["last_name"],"birth_date":subscription["birth_date"],"training_program":subscription["training_program"]}  for subscription in _subscriptions]
    return jsonify({"subscriptions":subscriptions})
        

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5000)



