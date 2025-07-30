#let get-locale() = {
  context {
    return str(text.lang)
  }
}

#let check-locale(locale) = {
  let dict = toml("../translations.toml")
  if locale not in dict.languages {
    let allowed_langs = dict.languages.join("', '", last: "' and '") + "'"
    panic("Unknown language: '" + locale + "'. Only languages " + allowed_langs + " are supported")
  }  
}

#let lang(key) = {
  if key == none {panic("No key specified")}
  let dict = toml("../translations.toml")
  context {
    return dict.translations.at(key).at(text.lang)
  }  
}
