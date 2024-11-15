#import "common/format.typ": format-date

#let tuda-make-title(
  inner_page_margin_top,
  title_rule,
  accent_color,
  logo_element,
  logo_height,
  info,
  dict
) = {
  v(-inner_page_margin_top + 0.2mm) // would else draw over header

    box(
      fill: accent_color, 
      width: 100%,
      outset: 0pt,
      {
        // line creates a paragraph spacing
        set par(spacing: 4pt)
        v(logo_height / 2)
        grid(
          columns: (1fr, auto),
          box(inset: 3mm,{
            set text(font: "Roboto", weight: "bold", fill: white)
            grid(row-gutter: 1em,
              if info.title != none {
                text(info.title, size: 20pt)
              },
              if info.subtitle != none {
                text(info.subtitle, size: 12pt)
              },
              if info.author != none {
                text(info.author, size: 12pt)
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
        line(length: 100%, stroke: title_rule / 2)
        if info.term != none or info.date != none or info.sheetnumber != none {
          set text(fill: white)
          grid(
            inset: (left: 3mm),
            row-gutter: 0.4em,
            if info.term != none {
                info.term
            },
            if info.date != none {
              if type(info.date) == datetime {
                format-date(info.date, dict.locale)
              } else {
                info.date
              }
            },
            if info.sheetnumber != none {
              dict.sheet + " " + str(info.sheetnumber)
            }
          )
          line(length: 100%, stroke: title_rule  /2)
        }
      }
    )
}