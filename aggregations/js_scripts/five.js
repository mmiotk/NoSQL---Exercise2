// Wypisanie ilości słów dla sentencji w przedziale 2503 - 2508

var result = db.marta.group({
  cond: {"numberSentence": {$gte: 2503, $lt: 2508}}
  , key: {numberSentence: true}
  , initial: {total_words_len: 0}
  , reduce: function(doc, out) { out.total_words_len += doc.text.length; }
  , finalize: function(out) { out.total_words_len }
} );

printjson(result);
