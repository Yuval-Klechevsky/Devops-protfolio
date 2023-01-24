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
    subscriptions = [{"first_name": subscription["first_name"],
                      "last_name": subscription["last_name"],
                      "birth_date":subscription["birth_date"],
                      "weight":subscription["weight"],
                      "height":subscription["height"],
                      "training_program":subscription["training_program"]}
                       for subscription in _subscriptions]

    return jsonify({"subscriptions":subscriptions})

@app.route("/subscriptions/ids", methods=[ "GET"])
def show_all_ids_subcriptions():
    db = get_db()
    _subscriptions= db["GYM_mongodb_tb"].find()
    subscriptions = [{"_id": str(subscription["_id"]),
                      "first_name": subscription["first_name"],
                      "last_name": subscription["last_name"]}  
                       for subscription in _subscriptions]

    return jsonify({"subscriptions":subscriptions})

@app.route("/subscriptions/<training_program>", methods=[ "GET"])
def get_subscription_by_progrem(training_program):
    if request.method == 'GET': 
        db = get_db()
        subscription = db["GYM_mongodb_tb"].find({"training_program":training_program})
        sub = dumps(subscription)
        return sub

@app.route("/subscription/<id>", methods=[ "GET"])
def get_subscription(id):
    if request.method == 'GET': 
        db = get_db()
        subscription = db["GYM_mongodb_tb"].find_one({"_id":ObjectId(id)})
        sub = dumps(subscription)
        return sub

@app.route("/subscription", methods=[ "POST"])
def get_add_subscription():
    if request.method == 'POST': 
        first_name_1 = request.get_json(force=True)["first_name"]
        last_name_1 = request.get_json(force=True)["last_name"]
        birth_date_1 = request.get_json(force=True)["birth_date"] 
        training_program_1 = request.get_json(force=True)["training_program"]
        weight_1=request.get_json(force=True)["weight"],
        height_1=request.get_json(force=True)["height"],
        db = get_db()
        subscription= db["GYM_mongodb_tb"].insert_one({"first_name": first_name_1 ,
                                                       "last_name": last_name_1 ,
                                                       "birth_date":birth_date_1 ,
                                                       "height":height_1,
                                                       "weight":weight_1,
                                                       "training_program":training_program_1})

        sub = jsonify(Message='User added successfully!')
        return sub

@app.route("/subscription/<id>", methods=[ "PUT"])
def get_update_subscription(id):
    if request.method == 'PUT': 
        first_name_2 = request.get_json(force=True)["first_name"]
        last_name_2 = request.get_json(force=True)["last_name"]
        birth_date_2 = request.get_json(force=True)["birth_date"] 
        training_program_2 = request.get_json(force=True)["training_program"]
        db = get_db()
        subscription= db["GYM_mongodb_tb"].update_one({"_id":ObjectId(id)},
                                                      {'$set':{"first_name": first_name_2,
                                                       "last_name": last_name_2 ,"birth_date":birth_date_2,
                                                       "training_program":training_program_2}})
        msg = jsonify(Message='User updated successfully!')
        return msg

@app.route("/subscription/<id>", methods=[ "DELETE"])
def get_delete_subscription(id):
    if request.method == 'DELETE': 
        db = get_db()
        subscription= db["GYM_mongodb_tb"].delete_one({"_id":ObjectId(id)})
        if subscription.deleted_count:
            msg = jsonify(Message='User delete successfully!')
        else:
            msg = jsonify(Message='Internal Problem!')
    return msg

@app.route("/subscription/<id>/BMI", methods =[ "GET" ])
def get_BMI_subscription(id):
    if request.method == 'GET':
        db = get_db()
        weight= ((db["GYM_mongodb_tb"].find_one({"_id":ObjectId(id)},{"weight":1}))) 
        height= ((db["GYM_mongodb_tb"].find_one({"_id":ObjectId(id)},{"height":1})))

        BMI = round(((((float(weight["weight"]))) / (float(height["height"]))/100)**2),2)
        if BMI <= 18.4:
            msg = jsonify(Message='Your BMI Is Under Weight')
        if BMI <= 24.9:
            msg = jsonify(Message='Your BMI Is Normal Weight')
        if BMI <= 29.9:
            msg = jsonify(Message='Your BMI Is Over Weight')
        if BMI <= 34.9:
            msg = jsonify(Message='Your BMI Is Obesity Weight (Class 1)')
        if BMI <= 39.9:
            msg = jsonify(Message='Your BMI Is Obesity Weight (Class 2)')
        if BMI > 39.9:
            msg = jsonify(Message='Your BMI Is Obesity Weight (Class 3)')
    return msg

@app.route("/id-for-test" , methods= [ "GET" ])
def id_for_e2e_testing():
    if request.method =='GET':
        db = get_db()
        mycol = db["GYM_mongodb_tb"]
        result = list(mycol.find({}, {"_id": 1}))
        random_id = choice(result)["_id"]
        return str(random_id)


if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5000)



