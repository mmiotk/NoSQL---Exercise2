library(rmongodb)
library(ggplot2)

mongo <- mongo.create()

if(mongo.is.connected(mongo)){
      mongo.get.databases(mongo)
      coll = mongo.get.database.collections(mongo,"test")
      
      
       project = mongo.bson.from.JSON('{ "$project": {"text": 1, "_id": 0}}')
       unwind = mongo.bson.from.JSON('{ "$unwind": "$text"}')
       group =  mongo.bson.from.JSON('{ "$group": {"_id": "$text", "ilosc": {"$sum" : 1}}}')
       sort = mongo.bson.from.JSON('{ "$sort": {"ilosc": -1}}')
       limit = mongo.bson.from.JSON('{"$limit": 5}')
      
       cmdList = list(project,unwind,group,sort,limit)
       result = mongo.aggregation(mongo,"test.marta",cmdList)
       
       listResult = mongo.bson.value(result,"result")
       mresult = sapply(listResult, 
                        function(x) return( c(x$'_id',x$ilosc)) )
       dataResult = as.data.frame(t(mresult))
       rownames(dataResult) <- dataResult[,1]
       colnames(dataResult) <- c("word","count")
      
       print(dataResult) 
      
}

mongo.destroy(mongo)