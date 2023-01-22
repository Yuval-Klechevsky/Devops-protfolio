db = db.getSiblingDB("GYM_mongodb");
db.GYM_mongodb_tb.drop() 

db.GYM_mongodb_tb.insertMany([
    {
        "id": 1 ,
        "first_name": "Carlos ",
        "last_name": "Alcaraz" ,
        "birth_date":"5/5/2003",
        "training_program": "AB"
    },

    {
        "id": 2 ,
        "first_name": "Rafael ",
        "last_name": "Nadal" ,
        "birth_date":"3/6/1986",
        "training_program": "Full-Body"
    },
    {
        "id": 3 ,
        "first_name": "Luka ",
        "last_name": "Doncic" ,
        "birth_date":"28/2/1999",
        "training_program": "ABC"
    },
]);