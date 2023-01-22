db = db.getSiblingDB("ranklistdb");
db.ranklisttb.drop() 

db.ranklisttb.insertMany([
    {
        "id": 1 ,
        "name": "Carlos Alcaraz",
        "Rank": 1 ,
        "nationality": "Spain"
    },

    {
        "id": 2 ,
        "name": "Rafael Nadal",
        "Rank": 2 ,
        "nationality": "Spain"
    }
]);