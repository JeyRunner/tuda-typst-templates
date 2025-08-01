#let dict_de = (
  locale: "ger",
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
  locale: "eng",
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

/// Returns the dictionary for the given locale.
///
/// - locale (str): The locale to get the dictionary for, can be "ger" or "eng".
/// -> Returns: The dictionary for the given locale.
#let get-locale-dict(locale) = {
  if locale == "ger" {
    dict_de
  } else if locale == "eng" {
    dict_en
  } else {
    panic("Unsupported locale: " + locale)
  }
}