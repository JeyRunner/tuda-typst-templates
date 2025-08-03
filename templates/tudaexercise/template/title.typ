#import "common/format.typ": format-date
#import "locales.typ": *

#let resolve-info-layout(exercise-type, info, info-layout, dict) = {
  if info-layout == false {
    return [#info.at(0)]
  }
    

  let default_keys_exercise = ("term", "date", "sheet")
  let default_keys_submission= ("group", "tutor", "lecturer")
  let default_keys = if exercise-type == "exercise" {
    default_keys_exercise
  } else {
    default_keys_exercise + default_keys_submission
  }

  // This function is a little weird, but it prevents code duplication.
  let sort-info-to-list(target-list, info-dict, filter-key) = {
     for (info-key, info-value) in info-dict.pairs() {
        if info-key in default_keys {
          if info-key == filter-key {
            if info-key == "date" {
              info-value = format-date(info-value, dict.locale) 
            }
            target-list.push([#dict.at(info-key) #info-value])
          }
        }
        else if info-key not in default_keys_submission{
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
  } else  {

     // Handle layouting, right first then default the rest to left
    for layout-key in info-layout.at("right") {
      right-items = sort-info-to-list(right-items, info, layout-key)
    }
    for layout-key in info-layout.at("left") {
      left-items = sort-info-to-list(left-items, info, layout-key)  
    }
  }
     grid(
      columns: (1fr,1fr),
      align: (alignment.left, alignment.right),
      left-items.join(linebreak()),
      right-items.join(linebreak())
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
  dict
) = {
  let text_on_accent_color = if colorback {
    on_accent_color
  } else {
    text_color
  }

  let text_inset = if colorback {
    (x:3mm)
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
    fill: if colorback {accent_color}, 
    width: 100%,
    outset: 0pt,
    {
      // line creates a paragraph spacing
      set par(spacing: 4pt)
      v(logo_height / 2)
      grid(
        columns: (1fr, auto),
        box(inset: (y:3mm),{
          set text(font: "Roboto", weight: "bold", size: 12pt)
          grid(row-gutter: 1em,
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
            }
          )

          v(.5em)
        }
        ),
        { 
          if logo_element != none {
            move(
              dx: 6mm,
              {
                set image(height: logo_height)
                logo_element
              }
            )
          }
        }
      )
      v(6pt)
      line(length: 100%, stroke: stroke)
      if info-layout != none {
        block(
          inset: text_inset,
          resolve-info-layout(exercise-type, info, info-layout, dict)
        )
        line(length: 100%, stroke: stroke)
      }
    }
  )
}