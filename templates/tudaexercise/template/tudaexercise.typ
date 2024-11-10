#import "common/tudacolors.typ": tuda_colors
#import "common/props.typ": *
#import "common/util.typ": *
#import "common/footnotes.typ": *
#import "common/headings.typ": *
#import "common/page_components.typ": *

#import "@preview/i-figured:0.2.3"


#let tuda-exercise(
  title: [Title],
  exercise-number: 1,

  // The code of the accentcolor.
  // A list of all available accentcolors is in the list tuda_colors
  accentcolor: "9c",

  // Size of the main text font
  fontsize: 10pt,//10.909pt, //11pt,

  // Currently just a4 is supported
  paper: "a4",

  // Author name as text, e.g "Albert Author"
  author: "An Author",

  // Date of submission as string
  data: datetime(
    year: 2023,
    month: 10,
    day: 4,
  ),

  // language for correct hyphenation
  language: "eng",

  // Set the margins of the content pages.
  // The title page is not affected by this.
  // Some example margins are defined in 'common/props.typ':
  //  - tud_page_margin_small  // same as title page margin
  //  - tud_page_margin_big
  // E.g.   margin: (
  //   top: 30mm,
  //   left: 31.5mm,
  //   right: 31.5mm,
  //   bottom: 56mm
  // ),
  margin: tud_page_margin_small,

  show-extended-header: true,

  body

) = context {
  // checks
  //assert(tuda_colors.keys().contains(accentcolor), "accentcolor unknown")
  //assert.eq(paper, "a4", "currently just a4 is supported as paper size")
  //[#paper]

  // vars
  let accentcolor_rgb = tuda_colors.at(accentcolor)
  let heading_line_spacing = 4.4pt
  let heading_margin_before = 12pt
  let heading_3_margin_before = 12pt
  let font-default = "XCharter"


  // Set document metadata.
  set document(
    title: title,
    author: author
  )

  // Set the default body font.
  set par(
    justify: true,
    //leading: 4.7pt//0.42em//4.7pt   // line spacing
    leading: 4.8pt//0.42em//4.7pt   // line spacing
  )
  show par: set block(below: 1.1em) // was 1.2em


  set text(
    font: font-default,
    size: fontsize,
    fallback: false,
    lang: language,
    kerning: true,
    ligatures: false,
    //spacing: 92%  // to make it look like the latex template
    //spacing: 84%  // to make it look like the latex template
    spacing: 91%  // to make it look like the latex template
  )

  if paper != "a4" {
    panic("currently just a4 as paper is supported")
  }


  

  ///////////////////////////////////////
  // page setup
  // with header and footer
  let header = tud-header(
    accentcolor_rgb: accentcolor_rgb,
    content: if show-extended-header {
      set text(
        font: font-default,
        size: fontsize
      )
      v(2.5mm)
      stack(
        [Exercise #title],
        v(2mm),
        [Last Name, First Name: ],
        v(2.5mm),
        line(length: 100%, stroke: tud_heading_line_thin_stroke),
      ) 
    }
  )

  let footer = [
    #text(
        font: "Roboto",
        stretch: 100%,
        fallback: false,
        weight: "regular",
        size: 10pt
    )[
      #set align(right)
      // context needed for page counter for typst >= 0.11.0
      #context [
        #let counter_disp = counter(page).display()
        #counter_disp
      ]
    ]
  ]

  let header_height = measure(header).height
  let footer_height = measure(footer).height

  // inner page margins (from header to text and text to footer)
  let inner_page_margin_top = 5mm //0pt//20pt //3mm
  let inner_page_margin_bottom = 30pt





  ////////////////////////////
  // content page setup
  let content_page_margin_full_top = margin.top + inner_page_margin_top + 1*header_height


  ///////////////////////////////////////
  // headings
  set heading(
    numbering: (..numbers) => {
      [#exercise-number.]
      numbering("1 a", ..numbers)
    }
  )
  show heading.where(
  ): it => {
    assert(it.level <= 2)

    let title-prefix = if it.level <= 1 {"Taks "} else {""}
    tud-heading-with-lines(
        heading_margin_before: heading_margin_before,
        heading_line_spacing: heading_line_spacing,
        text-size: 10pt,
        text-prefix: title-prefix,
        counter-suffix: if it.level > 1 {")"} else {":"},
        text-weight: if it.level > 1 {"regular"} else {"bold"},
        it
    )
    
  }




  ///////////////////////////////////////
  // configure footnotes
  set footnote.entry(
    separator: line(length: 40%, stroke: 0.5pt)
  )
  // somehow broken: 
  //show footnote.entry: it => tud-footnote(it)


  ///////////////////////////////////////
  // Display font checks
  check-font-exists("Roboto")
  check-font-exists("XCharter")





  ///////////////////////////////////////
  // Content pages
  
  // body has different margins than title page
  // @todo some bug seems to insert an empty page at the end when content (title page) appears before this second 'set page'
  set page(
    margin: (
      left: margin.left, //15mm,
      right: margin.right, //15mm,
      top: margin.top + inner_page_margin_top + 1*header_height,  // 15mm
      bottom: margin.bottom + inner_page_margin_bottom + footer_height //20mm
    ),
     // header
    header: header,
    // don't move header up -> so that upper side is at 15mm from top
    header-ascent: inner_page_margin_top,//0%,
    // footer
    footer: footer,
    footer-descent: inner_page_margin_bottom //footer_height // @todo
  )

  // disable heading outlined for outline
  set heading(outlined: false)

  // restart page counter
  counter(page).update(1)
  // restart heading counter
  counter(heading).update(0)


  // enable heading outlined for body
  set heading(outlined: true)

  // Display the paper's contents.
  body
}
