#let _lang_order = (
  "en": 0,
  "de": 1
)

// Here is the actual dictionary
#let _lang_dict = (
  "master_thesis":      ("Master thesis", "Master Thesis"),
  "bachelor_thesis":    ("Bachelor thesis", "Bachelor Thesis"),
  "report":             ("Report", "Bericht"),
  "by":                 ("by", "von"),
  "date_of_submission": ("Date of submission:", "Abgabedatum:"),
  "contents":           ("Contents", "Inhaltsverzeichnis"),
  "review":             ("Review", "Korrektur"),
)


#let lang(key) = {
  if key == none {panic("No key specified")}
  context {
    let language = text.lang
    if language not in ("en", "de") {
    panic("Unknown language: '" + language + "'. Only languages 'en' and 'de' are supported")
   }
  return _lang_dict.at(key).at(_lang_order.at(language))
  }
  
  
}