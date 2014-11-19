library(rmongodb)
library(stringr)
library(plyr)
library(parallel)

inputFile = "trainSet.txt"
fileOpen = file(inputFile,open ="r")

i <<- 0

mongo <- mongo.create()

prepareData = function(readLine){
            
      readLine = gsub('[[:punct:]]'," ",readLine)
      readLine = tolower(readLine)
      splitLine = str_split(readLine,"\\s+")
      splitLine = unlist(splitLine)
      return (splitLine[-length(splitLine)])
      
}

makeListBson = function(object){
      msg = paste(c(object),collapse = ' ')
      buffer = mongo.bson.buffer.create()
      i <<- i+1
      mongo.bson.buffer.append(buffer,"originalText",msg)
      mongo.bson.buffer.append(buffer,"numberSentence",i)
      mongo.bson.buffer.append(buffer,"text",object)
      mongo.bson.buffer.append(buffer,"howWords",length(object))
      newobject = mongo.bson.from.buffer(buffer)
      
      return(newobject)
}

howMuch = 0

cores = detectCores()


if(mongo.is.connected(mongo)){
      mongo.get.databases(mongo)
      coll = mongo.get.database.collections(mongo,"test")
      while(length(readLine <- readLines(fileOpen,n=25000,warn=FALSE)) > 0){
            howMuch = howMuch + 1
            list = mclapply(readLine,prepareData,mc.cores = cores)
            listBson = lapply(list,makeListBson)
            mongo.insert.batch(mongo,"test.marta",listBson)
            msg = paste("Add 25000 records per",howMuch,sep=" ")
            print(msg)
            
      }
      #list = lapply(readLine,prepareData)
      #mongo.insert.batch(mongo,coll[3],list)

      close(fileOpen)
      mongo.destroy(mongo)
}







