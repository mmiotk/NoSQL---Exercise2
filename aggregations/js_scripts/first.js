
//Aggregations in mongodb
//Wypisuje 5 najczęściej występujących słów w bazie


var options = {allowDiskUse: true, cursor: {batchSize: 4}};

var project = { $project: {text: 1, _id: 0}};
var unwind = { $unwind: "$text"};
var group = { $group: {_id: "$text", ilosc: {$sum : 1}}};
var sort = { $sort: {ilosc: -1}};
var limit = {$limit: 5};

var cursor = db.marta.aggregate([
  project,
  unwind,
  group,
  sort,
  limit
  ], options);

cursor.forEach(function(item){
  printjson(item);
  var avg = item.ilosc / 1000000.0;
  print("Średnia wynosi: ",avg);
});
