library(rmongodb)
library(ggplot2)

mongo <- mongo.create()

if(mongo.is.connected(mongo)){
      mongo.get.databases(mongo)
      coll = mongo.get.database.collections(mongo,"test")
      
      
      group =  mongo.bson.from.JSON('{ "$group": {"_id": "$howWords", "count": {"$sum": 1}} }')
      sort = mongo.bson.from.JSON('{ "$sort": {"count": -1}}')
      sort2 = mongo.bson.from.JSON('{ "$sort": {"_id": -1}}')
      limit = mongo.bson.from.JSON('{"$limit": 5}')
      
      cmdList = list(group,sort,sort2,limit)
      result = mongo.aggregation(mongo,"test.marta",cmdList)
      
      listResult = mongo.bson.value(result,"result")
      print(listResult[[1]])
      
}

mongo.destroy(mongo)