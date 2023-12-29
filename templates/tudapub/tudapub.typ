#import "tudacolors.typ": tuda_colors
#import "common/outline.typ": *
#import "common/props.typ": *
#import "common/tudapub_title_page.typ": *
#import "util.typ": *



// This function gets your whole document as its `body` and formats
#let tudapub(
  title: [Title],
  title_german: [Title German],

  // "master" or "bachelor" thesis
  thesis_type: "master",

  // the code of the accentcolor.
  // A list of all available accentcolors is in the list tuda_colors
  accentcolor: "9c",

  // size of the main text font
  fontsize: 10.905pt, //11pt,

  paper: "a4",

  // author name as text, e.g "Albert Author"
  author: "A Author",

  // date of submission as string
  date_of_submission: datetime(
    year: 2023,
    month: 10,
    day: 4,
  ),

  location: "Darmstadt",

  // array of the names of the reviewers
  reviewer_names: ("SuperSupervisor 1", "SuperSupervisor 2"),

  // language for correct hyphenation
  language: "eng",

  // set the margins of the content pages.
  // The title tabe is not affected by this.
  margin: (
    top: 30mm, //35.25mm + 0.05mm,//+ 0.02mm,
    left: 31.5mm,
    right: 31.5mm,
    bottom: 56mm
  ),

  // path to the tuda logo containing the file name, has to be a svg.
  logo_tuda_path: "logos/tuda_logo.svg",

  // path to a optinal sub-logo of a institue containing the file name, has to be a svg.
  // E.g. "logos/iasLogo.jpeg"
  logo_institue_path: none,

  // how to set the size of the optinal sub-logo
  // either "width": use tud_logo_width*(2/3)
  // or     "height": use tud_logo_height*(2/3)
  logo_institue_sizeing_type: "width",

  // move the optinal sub-logo horizontally
  logo_institue_offset_right: 0mm,


  // for headings with a height level than this number no number will be shown.
  // The heading with the lowest level has level 1.
  // Note that the numbers of the first two levels will allways be shown.
  heading_numbering_max_level: 3,

  // set space above heading to zero if its the first element on a page
  // This is currently implemened as hack (check the y pos of the heading).
  // Thus when you experience compilation problems (slow, no convergence) set this to false.
  reduce_heading_space_when_first_on_page: true,


  // How the table of contents outline is displayed.
  // Either "adapted":    use the default typst outline and adpat the style 
  // or     "rewritten":  use own custom outline implementation which better reproduces the look of the original latex template.
  //                      Note that this may be less stable than "adapted", thus when you notice visual problems with the outline switch to "adapted".
  outline_table_of_contents_style: "rewritten",


  // content.
  body
) = style(styles => {
  // checks
  //assert(tuda_colors.keys().contains(accentcolor), "accentcolor unknown")
  //assert.eq(paper, "a4", "currently just a4 is supported as paper size")
  //[#paper]

  // vars
  let accentcolor_rgb = tuda_colors.at(accentcolor)
  let heading_2_line_spacing = 5.3pt
  let heading_2_margin_before = 12pt
  let heading_3_margin_before = 12pt


  // Set document metadata.
  set document(
    title: title,
    //author: autor
  )

  // Set the default body font.
  set par(
    justify: true,
    leading: 4.7pt//0.42em//4.7pt   // line spacing
  )
  show par: set block(below: 1.1em) // was 1.2em

  set text(
    font: "XCharter",
    size: fontsize,
    fallback: false,
    lang: language,
    kerning: true,
    spacing: 92%  // to make it look like the latex template
  )

  if paper != "a4" {
    panic("currently just a4 as paper is supported")
  }


  

  ///////////////////////////////////////
  // page setup
  // with header and footer
  let header = box(fill: white,
    grid(
    rows: auto,
    rect(
      fill: color.rgb(accentcolor_rgb),
      width: 100%,
      height: 4mm //- 0.05mm
    ),
    v(1.4mm + 0.25mm), // should be 1.4mm according to guidelines
    line(length: 100%, stroke: 1.2pt) //+ 0.1pt) // should be 1.2pt according to guidelines
  ))

  let footer = grid(
    rows: auto,
    v(0mm),
    line(length: 100%, stroke: 0.6pt), // should be 1.6pt according to guidelines
    v(2.5mm),
    text(
        font: "Roboto",
        stretch: 100%,
        fallback: false,
        weight: "regular",
        size: 10pt
    )[
      #set align(right)
      #counter(page).display()
    ]
  )

  let header_height = measure(header, styles).height
  let footer_height = measure(footer, styles).height

  // inner page margins (from header to text and text to footer)
  let inner_page_margin_top = 22pt //0pt//20pt //3mm
  let inner_page_margin_bottom = 30pt

  // title page has different margins
  let margin_title_page = (
    top: 15mm,
    left: 15mm,
    right: 15mm,
    bottom: 15mm - 1mm  // should be 20mm according to guidelines
  )







  ////////////////////////////
  // content page setup
  let content_page_margin_full_top = margin.top + inner_page_margin_top + 1*header_height


  ///////////////////////////////////////
  // headings
  set heading(numbering: "1.1")

  // default heading (handle cases with level >= 3)
  show heading: it => locate(loc => {
    if it.level > 4 {
      panic("Just heading with a level < 4 are supported.")
    }

    let heading_font_size = {
      if it.level <= 3 {11.9pt}
      else {10.9pt}
    }

    // change heading margin depending if its the first on the page
    let (heading_margin_before, is_first_on_page) = get-spacing-zero-if-first-on-page(
      heading_3_margin_before, 
      loc, 
      content_page_margin_full_top,
      enable: reduce_heading_space_when_first_on_page
    )

    set text(
      font: "Roboto",
      fallback: false,
      weight: "bold",
      size: heading_font_size
    )
    block(breakable: false, inset: 0pt, outset: 0pt)[
      #stack(
        v(heading_margin_before),
        block[
          #if it.level <= heading_numbering_max_level and it.outlined {
            counter(heading).display(it.numbering)
            h(0.3em)
          }
          #it.body
        ],
        v(10pt)
      )
    ]
  })

  // heading level 1
  show heading.where(
    level: 1
  ): it => {
    set text(
      font: "Roboto",
      fallback: false,
      weight: "bold",
      size: 20.6pt,
      //height: 
    )
    [#pagebreak(weak: true)]
    block(breakable: false, inset: 0pt, outset: 0pt, fill: none)[
      #stack(
        v(20mm),
        block[
          //\ \ 
          //#v(50pt)
          #if it.outlined {
            counter(heading).display(it.numbering)
            h(4pt)
          }
          #it.body
        ],
        v(13pt),
        line(length: 100%, stroke: tud_heading_line_thin_stroke),
        v(32pt)
      )
    ]
  }

  // heading level 2 
  show heading.where(
    level: 2
  ): it => locate(loc => {
    // change heading margin depending if its the first on the page
    let (heading_margin_before, is_first_on_page) = get-spacing-zero-if-first-on-page(
      heading_2_margin_before, 
      loc, 
      content_page_margin_full_top,
      enable: reduce_heading_space_when_first_on_page
    )

    set text(
      font: "Roboto",
      fallback: false,
      weight: "bold",
      size: 14.3pt
    )
    //set block(below: 0.5em, above: 2em)
    block(
      breakable: false, inset: 0pt, outset: 0pt, fill: none,
      //above: heading_margin_before,
      //below: 0.6em //+ 10pt
    )[
      #stack(
        v(heading_margin_before),
        line(length: 100%, stroke: tud_heading_line_thin_stroke),
        v(heading_2_line_spacing),
        block[
          #if it.outlined {
            counter(heading).display(it.numbering)
            h(2pt)
          }
          #it.body
          //[is_first_on_page: #is_first_on_page] 
          //#loc.position() #content_page_margin_full_top
        ],
        v(heading_2_line_spacing),
        line(length: 100%, stroke: tud_heading_line_thin_stroke),
        v(10pt)
      )
    ]

    
  })




  ///////////////////////////////////////
  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)




  ///////////////////////////////////////
  // Display the title page
  set page(
    paper: paper,
    margin: (
      left: margin_title_page.left, //15mm,
      right: margin_title_page.right, //15mm,
      //  top: inner + margin.top + header_height
      top: margin_title_page.top + inner_page_margin_top + header_height,  // 15mm
      bottom: margin_title_page.bottom //+ 0*inner_page_margin_bottom + footer_height //20mm
    ),
    // header
    header: header,
    // don't move header up -> so that upper side is at 15mm from top
    header-ascent: inner_page_margin_top,//0%,
    // footer
    footer: none,//footer,
    footer-descent: 0mm //inner_page_margin_bottom
  )

  // make image paths relative to this dir of this .typ file
  let make-path-rel-parent(path) = {
    if not path == none and not path.starts-with("/") {
      return "../" + path
    }
    else {return path}
  }

  tudpub-make-title-page(
    title: title,
    title_german: title_german,
    thesis_type: thesis_type,
    accentcolor: accentcolor,
    language: language,
    author: author,
    date_of_submission: date_of_submission,
    location: location,
    reviewer_names: reviewer_names,
    logo_tuda_path: make-path-rel-parent(logo_tuda_path),
    logo_institue_path: make-path-rel-parent(logo_institue_path),
    logo_institue_sizeing_type: logo_institue_sizeing_type,
    logo_institue_offset_right: logo_institue_offset_right
  )




  ///////////////////////////////////////
  // Content pages
  
  // body has different margins than title page
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




  ///////////////////////////////////////
  // Display the table of contents
  //page()[
  [
    #tudapub-make-outline-table-of-contents(
      outline_table_of_contents_style: outline_table_of_contents_style,
      heading_numbering_max_level: heading_numbering_max_level
    )
  ]




  // restart page counter
  counter(page).update(1)
  // restart heading counter
  counter(heading).update(1)

  // Display the paper's contents.
  body
})
