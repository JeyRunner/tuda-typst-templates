#import "common/format.typ": format-date

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
    ()
  }

  let stroke_color = if colorback {
    black
  } else {
    text_color
  }

  let stroke = (paint: stroke_color, thickness: title_rule / 2)

  v(-inner_page_margin_top + 0.2mm) // would else draw over header

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
          set text(font: "Roboto", weight: "bold", size: 12pt, fill: text_on_accent_color)
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
                    author.at(0) + " (Mat.: " + author.at(1) + ")"
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
      if "term" in info or "date" in info or "sheetnumber" in info {
        set text(fill: text_on_accent_color)
        grid(
          columns: (1fr, 1fr),
          align: (left, right),
          inset: text_inset,
          row-gutter: 0.4em,
          grid.cell(
          if info.term != none {
              info.term
          } + "\n" +
          if info.date != none {
            if type(info.date) == datetime {
              format-date(info.date, dict.locale)
            } else {
              info.date
            }
          }),
          grid.cell(
          if "sheetnumber" in info {
            text(font: "Roboto", weight: "bold", dict.sheet) + ": " + str(info.sheetnumber)
            linebreak()
          } +
          if "groupnumber" in info {
            text(font: "Roboto", weight: "bold", dict.group) + ": " + str(info.groupnumber)
            linebreak()
          } +
          if "tutor" in info {
            text(font: "Roboto", weight: "bold", dict.tutor) + ": " + info.tutor
            linebreak()
          } + 
          if "lecturer" in info {
            text(font: "Roboto", weight: "bold", dict.lecturer) + ": " + info.lecturer
            linebreak()
          }
          ),
        )
        line(length: 100%, stroke: stroke)
      }
    }
  )
}