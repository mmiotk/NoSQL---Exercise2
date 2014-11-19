// Ile slow ma najkrotsza sentencja i ile razy wystepuje z ta iloscia

var options = {allowDiskUse: true, cursor: {batchSize: 4}};

var group = { $group: {_id: "$howWords", count: {$sum: 1}} };
var sort = { $sort: {_id: 1}};
var limit = {$limit: 5};

var cursor = db.marta.aggregate([
  group,
  sort,
  limit
  ], options);

cursor.forEach(function(item){
  printjson(item);
});
