#import "common/tudacolors.typ": tuda_colors
#import "title.typ": *
#import "sections.typ": tuda-section, tuda-subsection
#import "locales.typ": *

#let tudaexercise(
  accentcolor: "0b",
  // Supported: "eng", "ger"
  locale: "eng",

  margins: (
    top: 15mm,
    left: 15mm,
    right: 15mm,
    bottom: 20mm,
  ),

  // Currently not supported as typst lacks the feature of dynamically adjusting page margins
  headline: ("title", "name", "id"),

  paper: "a4",

  logo_path: none,

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

  body
) = {
  if paper != "a4" {
    panic("currently just a4 paper is supported")
  }

  let ex = 4.3pt // typst does not have ex

  set document(
    title: info.subtitle, // Should probably add the sheet number or something else
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

  let dict = if locale == "eng" {
    dict_en
  } else if locale == "ger" {
    dict_de
  } else {
    panic("Unsupported locale")
  }

  set heading(numbering: "1.a)")

  let title_rule = 1.2pt

  show heading: it => {
    let c = counter(heading).get()
    if it.level == 1 {
      let sec_title = dict.task + " "
      if info.sheetnumber != none {
        sec_title += str(info.sheetnumber) + "."
      }
      sec_title += str(c.first()) + "."
      tuda-section(sec_title + " " + it.body)
    } else if it.level == 2 {
      let sec_title = ""
      if info.sheetnumber != none {
        sec_title += str(info.sheetnumber) + "."
      }
      sec_title += numbering("1a)", c)
      tuda-subsection(sec_title + " " + it.body)
    } else {
      it
    }
  }

  let ty_accentcolor = color.rgb(tuda_colors.at(accentcolor))

  let identbar = rect(
    fill: ty_accentcolor,
    width: 100%,
    height: 4mm
  )

  let header_frontpage = grid(
    rows: auto,
    row-gutter: 1.4mm + 0.25mm,
    identbar,
    line(length: 100%, stroke: title_rule),
  )

  let inner_page_margin_top = 22pt
  let logo_height = 22mm
  

  context {
    let height_header = measure(header_frontpage).height

    set page(
      paper: paper,
      numbering: "1",
      number-align: right,
      margin: (
        top: margins.top + inner_page_margin_top + height_header, 
        bottom: margins.bottom, 
        left: margins.left, 
        right: margins.right
      ),
      header: header_frontpage,
      header-ascent: inner_page_margin_top,
      footer: none,
      footer-descent: 0mm
    )

    tuda-make-title(
      inner_page_margin_top, 
      title_rule,
      ty_accentcolor, 
      logo_path, 
      logo_height, 
      info,
      dict
      )

    body
  }

}