library(rmongodb)
library(ggplot2)

mongo <- mongo.create()

if(mongo.is.connected(mongo)){
      mongo.get.databases(mongo)
      coll = mongo.get.database.collections(mongo,"test")
      
      
      group =  mongo.bson.from.JSON('{ "$group": {"_id": "$howWords", "count": {"$sum": 1}} }')
      sort = mongo.bson.from.JSON('{ "$sort": {"count": -1}}')
      limit = mongo.bson.from.JSON('{"$limit": 5}')
      
      cmdList = list(group,sort,limit)
      result = mongo.aggregation(mongo,"test.marta",cmdList)
      
      listResult = mongo.bson.value(result,"result")
      mresult = sapply(listResult, 
                       function(x) return( c(x[1],x[2])) )
      dataResult = as.data.frame(t(mresult))
      rownames(dataResult) <- dataResult[,1]
      colnames(dataResult) <- c("word","count")
      
      ggplot(dataResult,aes(word,count,fill=count)) + guides(fill=FALSE) + geom_bar(stat="identity",colour = "white") + xlab("Number of words") + ylab("How many senetences")
      
      print(dataResult)
      
}

mongo.destroy(mongo)