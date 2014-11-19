//Use: mongodb --quiet third.js
// Wypisanie z ilu słów jest najwięcej sentencji


var options = {allowDiskUse: true, cursor: {batchSize: 4}};

var group = { $group: {_id: "$howWords", count: {$sum: 1}} };
var sort = { $sort: {count: -1}};
var limit = {$limit: 5};

var cursor = db.marta.aggregate([
  group,
  sort,
  limit
  ], options);

cursor.forEach(function(item){
  printjson(item);
  print("Sentencji z",item._id,"słowami jest ",item.count);
  print("Stanowi to",Math.round((item.count / 1000000.0) * 100), "% wszystkich sentencji");
});
