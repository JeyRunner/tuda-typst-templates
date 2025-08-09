#import "common/format.typ": format-date
#import "locales.typ": *

/// Creates the subline content. If `info-layout` is a dict, the subline gets filled following
/// the order specified by the keys in the `info-layout` dict. If a key is present in the
/// `info` but not in `info-layout`, it does not show up in the subline.
///
/// - exercise-type (string): The type of exercise specified
/// - info (dict): The info dict containing all relevant data for the subline
/// - info-layout (dict, boolean): A dict specifying the layout of the subline. If `false`
///   the value of `#info.custom-subline` gets returned as content
/// - dict (dict): A language dict to translate standard/pre-defined strings.
/// -> Returns content filling the subline of the title
#let resolve-info-layout(exercise-type, info, info-layout, dict) = {
  if not info-layout {
    return [#info.custom-subline]
  }


  let default_keys_exercise = ("term", "date", "sheet")
  let default_keys_submission = ("group", "tutor", "lecturer")
  let default_keys = if exercise-type == "exercise" {
    default_keys_exercise
  } else {
    default_keys_exercise + default_keys_submission
  }

  /// Checks if `filter-key` is present in `info-dict` and appends it to `target-list`
  /// if that is the case. Also format the value of key `date` to match the locale.
  let sort-info-to-list(target-list, info-dict, filter-key) = {
    for (info-key, info-value) in info-dict.pairs() {
      if info-key in default_keys {
        if info-key == filter-key {
          if info-key == "date" {
            info-value = format-date(info-value, dict.locale)
          }
          target-list.push([#dict.at(info-key) #info-value])
        }
      } // This case makes sure the default submission keys don't get mistaken for custom keys
      // I.e. we don't want submission keys ("group", "tutor", "lecturer") showing up, if
      // exercise-type isn't "submission"!
      else if info-key not in default_keys_submission {
        if info-key == filter-key {
          target-list.push([#info-value])
        }
      }
    }
    return target-list
  }


  let left-items = ()
  let right-items = ()
  if exercise-type not in ("exercise", "submission") {
    panic("Exercise template only supports types 'exercise' and 'submission'")
  } else {
    // Handle layouting, right first then default the rest to left
    for layout-key in info-layout.at("right") {
      right-items = sort-info-to-list(right-items, info, layout-key)
    }
    for layout-key in info-layout.at("left") {
      left-items = sort-info-to-list(left-items, info, layout-key)
    }
  }
  grid(
    columns: (1fr, 1fr),
    align: (alignment.left, alignment.right),
    left-items.join(linebreak()), right-items.join(linebreak()),
  )
}

#let tuda-make-title(
  inner_page_margin_top,
  title_rule,
  accent_color,
  on_accent_color,
  text_color,
  colorback,
  logo_element,
  logo_height,
  info,
  info-layout,
  exercise-type,
  dict,
) = {
  let text_on_accent_color = if colorback {
    on_accent_color
  } else {
    text_color
  }

  let text_inset = if colorback {
    (x: 3mm)
  } else {
    (:)
  }

  let stroke_color = if colorback {
    black
  } else {
    text_color
  }

  let stroke = (paint: stroke_color, thickness: title_rule / 2)

  v(-inner_page_margin_top + 0.2mm) // would else draw over header

  set text(fill: text_on_accent_color)

  box(
    fill: if colorback { accent_color },
    width: 100%,
    outset: 0pt,
    {
      // line creates a paragraph spacing
      set par(spacing: 4pt)
      v(logo_height / 2)
      grid(
        columns: (1fr, auto),
        box(inset: (y: 3mm), {
          set text(font: "Roboto", weight: "bold", size: 12pt)
          grid(
            row-gutter: 1em,
            inset: text_inset,
            if "title" in info {
              text(info.title, size: 20pt)
            },
            if "subtitle" in info {
              info.subtitle
            },
            if "author" in info {
              if type(info.author) == array {
                for author in info.author {
                  if type(author) == array {
                    [#author.at(0)
                      #text(weight: "regular", size: 0.8em)[(Mat.: #author.at(1))]]
                    linebreak()
                  } else {
                    author
                    linebreak()
                  }
                }
              } else {
                info.author
              }
            },
          )

          v(.5em)
        }),
        {
          if logo_element != none {
            move(
              dx: 6mm,
              {
                set image(height: logo_height)
                logo_element
              },
            )
          }
        },
      )
      v(6pt)
      line(length: 100%, stroke: stroke)
      if info-layout != none {
        block(
          inset: text_inset,
          resolve-info-layout(exercise-type, info, info-layout, dict),
        )
        line(length: 100%, stroke: stroke)
      }
    },
  )
}
