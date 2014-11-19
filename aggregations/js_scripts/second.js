//Aggregations in mongodb
//Ile sentencji zawiera największą ilość słów


var options = {allowDiskUse: true, cursor: {batchSize: 4}};

var group = { $group: {_id: "$howWords", count: {$sum: 1}} };
var sort = { $sort: {count: -1}};
var sort2 = { $sort: {_id: -1}};
var limit = {$limit: 1};

var cursor = db.marta.aggregate([
  group,
  sort,
  sort2,
  limit
  ], options);

cursor.forEach(function(item){
  printjson(item);
   print("Najdłuższa sentencja posiada ",item._id," słów")  ;
});
