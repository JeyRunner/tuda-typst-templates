#let dict_de = (
  locale: "de",
  task: "Aufgabe",

  sheet: "Übungsblatt",
  group: "Übungsgruppe",
  tutor: "Tutor",
  lecturer: "Dozent",
  point_singular: "Punkt",
  point_plural: "Punkte",
  difficulty: "Schwierigkeitsgrad",
  term: "Semester",
  date: "Abgabe"
)

#let dict_en = (
  locale: "en",
  task: "Task",

  sheet: "Sheet",
  group: "Exercise group",
  tutor: "Tutor",
  lecturer: "Lecturer",
  point_singular: "Point",
  point_plural: "Points",
  difficulty: "Difficulty",
  term: "Term",
  date: "Due"
)

#let dicts = (
  de: dict_de,
  en: dict_en,
)

/// Returns the dictionary for the given locale.
///
/// - locale (str): The locale to get the dictionary for, can be "de" or "en".
/// -> Returns: The dictionary for the given locale.
#let get-locale-dict(locale) = {
  let dict = dicts.at(locale, default: none)
  if dict == none {
    panic("Unsupported locale: " + locale + ". Supported locales are: " + dicts.keys().join(", ", last: " and "))
  }
  dict
}