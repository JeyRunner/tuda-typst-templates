#let lang(key) = {
  if key == none {panic("No key specified")}
  let dict = toml("translations.toml")
  context {
    let language = text.lang
    if language not in dict.languages {
      let allowed_langs = dict.languages.join("', '", last: "' and '") + "'"
      panic("Unknown language: '" + language + "'. Only languages " + allowed_langs + " are supported")
    }
  
  return dict.translations.at(key).at(language)
  }
  
  
}