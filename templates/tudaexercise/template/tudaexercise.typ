#import "common/tudacolors.typ": tuda_colors, text_colors
#import "common/props.typ": tud_exercise_page_margin, tud_header_line_height, tud_inner_page_margin_top, tud_title_logo_height
#import "common/headings.typ": tuda-section, tuda-subsection
#import "common/util.typ": check-font-exists
#import "common/colorutil.typ": calc-relative-luminance, calc-contrast
#import "common/dictutil.typ": overwrite-dict
#import "title.typ": *
#import "locales.typ": *

#let design_defaults = (
  accentcolor: "0b",
  colorback: false,
  darkmode: false
)

#let tudaexercise(
  // Supported: "eng", "ger"
  language: "eng",

  margins: tud_exercise_page_margin,

  // Currently not supported as typst lacks the feature of dynamically adjusting page margins
  headline: ("title", "name", "id"),

  paper: "a4",

  logo: none,

  info: (
    title: none,
    // Currently not supported
    header_title: none,
    subtitle: none,
    author: none,
    term: none,
    date: none,
    sheetnumber: none,
  ),

  design: design_defaults,

  body
) = {
  if paper != "a4" {
    panic("currently just a4 paper is supported")
  }

  let margins = overwrite-dict(margins, tud_exercise_page_margin)
  let design = overwrite-dict(design, design_defaults)

  set document(
    title: info.subtitle + sym.dash.em + info.title, // Should probably add the sheet number or something else
    author: info.author
  )

  set par(
    justify: true,
    //leading: 4.7pt//0.42em//4.7pt   // line spacing
    leading: 4.8pt,//0.42em//4.7pt   // line spacing
    spacing: 1.1em
  )
  
  set text(
    font: "XCharter",
    size: 10.909pt,
    fallback: false,
    kerning: true,
    ligatures: false,
    spacing: 91%  // to make it look like the latex template
  )

  let dict = if language == "eng" {
    dict_en
  } else if language == "ger" {
    dict_de
  } else {
    panic("Unsupported language")
  }

  set heading(numbering: (..numbers) => {
    if info.sheetnumber != none {
      numbering("1.1a", info.sheetnumber, ..numbers)
    } else {
      numbering("1a", ..numbers)
    }
  })

  show heading: it => {
    if not it.outlined or it.numbering == none {
      it
      return
    }
    let c = counter(heading).display(it.numbering)
    if it.level == 1 {
      tuda-section(dict.task + " " + c + ": " + it.body)
    } else if it.level == 2 {
      tuda-subsection(c + ") " + it.body)
    } else {
      it
    }
  }

  let ty_accentcolor = if type(design.accentcolor) == color {
    design.accentcolor
  } else if type(design.accentcolor) == str {
    rgb(tuda_colors.at(design.accentcolor))
  } else {
    panic("Unsupported color format. Either pass a color code as a string or pass an actual color.")
  }
  let text_on_accent_color = if type(design.accentcolor) == str {
    text_colors.at(design.accentcolor)
  } else {
    let lum = calc-relative-luminance(design.accentcolor)
    if calc-contrast(lum, 0) > calc-contrast(lum, 1) {
      black
    } else {
      white
    }
  }

  let identbar = rect(
    fill: ty_accentcolor,
    width: 100%,
    height: 4mm
  )

  let header_frontpage = grid(
    rows: auto,
    row-gutter: 1.4mm + 0.25mm,
    identbar,
    line(length: 100%, stroke: tud_header_line_height),
  )

  context {
    let height_header = measure(header_frontpage).height

    set page(
      paper: paper,
      numbering: "1",
      number-align: right,
      margin: (
        top: margins.top + tud_inner_page_margin_top + height_header, 
        bottom: margins.bottom, 
        left: margins.left, 
        right: margins.right
      ),
      header: header_frontpage,
      header-ascent: tud_inner_page_margin_top,
      footer: none,
      footer-descent: 0mm
    )

    tuda-make-title(
      tud_inner_page_margin_top, 
      tud_header_line_height,
      ty_accentcolor, 
      logo, 
      tud_title_logo_height, 
      info,
      dict
      )

    check-font-exists("Roboto")
    check-font-exists("XCharter")

    body
  }

}