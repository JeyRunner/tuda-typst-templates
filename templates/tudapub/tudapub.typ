#import "tudacolors.typ": tuda_colors
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
  let heading_line_thin_stroke = 0.75pt
  let heading_2_line_spacing = 5.3pt
  let heading_2_margin_before = 12pt
  let heading_3_margin_before = 12pt

  let thesis_type_text = {
    if thesis_type == "master" {"Master"}
    else if thesis_type == "bachelor" {"Bachelor"}
    else {panic("thesis_type has to be either 'master' or 'bachelor'")}
  }

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
        line(length: 100%, stroke: heading_line_thin_stroke),
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
        line(length: 100%, stroke: heading_line_thin_stroke),
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
        line(length: 100%, stroke: heading_line_thin_stroke),
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
  let title_seperator_spacing = 15pt
  let title = [#title]
  //let title_height = 150pt //measure(title, styles).height
  let title_page_inner_margin_left = 8pt
  let logo_tud_height = 22mm

  let submission_date = date_of_submission.display("[month repr:long] [day], [year]")
  if (language == "ger") {
    submission_date = date_of_submission.display("[day].[month repr:numerical].[year]")
  }

  page[
    //#set par(leading: 1em)
    #set text(
      //font: "Comfortaa",
      font: "Roboto",
      //stretch: 50%,
      //fallback: false,
      weight: "bold",
      size: 35.86pt,
      //height: 
    )
    #let title_height = 3.5em //measure(title, styles).height

    //#v(80pt)
    #grid(
      rows: (auto, 1fr),
      stack(
        // title
        block(
          inset: (left: title_page_inner_margin_left),
          height: title_height)[
            #set par(
              justify: false,
              leading: 20pt   // line spacing
            )
            #align(bottom)[#title]
          ],
        v(title_seperator_spacing),
        line(length: 100%, stroke: heading_line_thin_stroke),
        v(3mm), // title_seperator_spacing
        //
        // sub block with reviewers and other text
        block(inset: (left: title_page_inner_margin_left))[
          #set text(size: 12pt)
          #title_german
          \
          #set text(weight: "regular")
          #thesis_type_text thesis by #author
          \
          Date of submission: #submission_date
          \
          \
          #for (i, reviewer_name) in reviewer_names.enumerate() [
            #(i+1). Review: #reviewer_name
            \
          ]
          #v(-5pt) // spacing optional
          #location
        ],
        v(15pt)
      ),
      // color rect with logos
      rect(
        fill: color.rgb(accentcolor_rgb),
        stroke: (
          top: heading_line_thin_stroke,
          bottom: heading_line_thin_stroke
        ),
        inset: 0mm,
        width: 100%,
        height: 100%//10em
      )[
        
        #v(logo_tud_height/2)
        #style(styles => {
          let tud_logo = image(logo_tuda_path, height: logo_tud_height)
          let tud_logo_width = measure(tud_logo, styles).width
          let tud_logo_offset_right = -6.3mm
          tud_logo_width += tud_logo_offset_right

          align(right)[
            //#natural-image(logo_tuda_path)
            #grid( 
              // tud logo
              // move logo(s) to the right
              box(inset: (right: tud_logo_offset_right), fill: black)[
                #tud_logo
              ],
              // sub logo
              v(5mm),
              // height from design guidelines
              if logo_institue_path != none {
                box(inset: (right: logo_institue_offset_right), fill: black)[
                  #{
                    if logo_institue_sizeing_type == "width" {
                      image(logo_institue_path, width: tud_logo_width*(2/3))
                    }
                    else {
                      image(logo_institue_path, height: logo_tud_height*(2/3))
                    }
                  }
                ]
              }
            )
          ]
        })
        
      ]
    )
  ]


  
  //[
  //  Header: #header_height
  //]

  // body has different margins than title page
  let inner = 4mm
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
    //#heading(
    //  level: 1, outlined: false
    //)[Contents]

    // style outline for table of contents
    #let fill_dot_space = 3pt

    // alternative (simpler than next solution)
    #if outline_table_of_contents_style == "adapted" {
      show outline.entry.where(
        level: 1
      ): it => {
        // prevent recursion
        if it.fill != none {
          // new outline entry without fill
          let params = it.fields()
          params.fill = none
          //params.page = [#params.page]
          strong[
            #set text(
              font: "Roboto",
              fallback: false,
            )
            #v(14pt, weak: true)
            #outline.entry(..params.values())
          ]
        } else {
          it
        }
      }

      outline(
        target: heading.where(outlined: true),
        depth: heading_numbering_max_level,
        indent: 1em,
        fill: block(width: 100% - 1em)[
          #repeat[ #h(fill_dot_space) . #h(fill_dot_space) ] 
        ]
      )
    }
    //*/

    
    // own outline elements
    /*
    #let mem-lengths = state("mem-lengths", ())
    #let space = 1em
    #show outline.entry: it => style(styles => {
        locate(loc => {
            let el = it.element
            let c-heading = numbering(el.numbering, ..counter(heading).at(el.location()))

            let indent = if it.level > 1 {
                mem-lengths.at(loc).at(it.level - 2)
            } else {0pt}

            let preamb = [#h(indent)#c-heading#h(space)]
            let size = measure(preamb, styles)

            mem-lengths.update(array => {
                if array.len() > it.level - 1 {
                    array.at(it.level - 1) = size.width
                } else {
                    array.push(size.width)
                }
                array
            })

            /*
            let text_params = ()
            if it.level == 1 {
              text_params = (
                font: "Roboto",
                fallback: false,
                weight: "bold"
              )
            }
            set text(
              ..text_params
            )*/
            [
              #preamb#el.body 
              #box(width: 1fr, repeat[ #h(fill_dot_space) . #h(fill_dot_space)]) 
              #box(width: 1.5em)[
                #align(right)[#it.page]
              ] 
              //#it.page
            ]
        })
    })
    */
    


    
    // own rewritten outline
    #if outline_table_of_contents_style == "rewritten" {
      heading(
        level: 1, outlined: false
      )[Contents]


      locate(loc => {
        let headings = query(
          selector(heading.where(outlined: true)).after(loc),
          loc,
        )


        
        // outline params
        let heading_numbering_intent = 1em
        let heading_numbering_width_per_level = 0.65em
        let heading_first_level_v_space = 15pt
        let heading_page_number_width = 1.5em

        // go over all headings
        let heading_counter = counter("h")
        for it in headings {
          if it.level > heading_numbering_max_level {
            continue
          }

          // save location and page of current heading
          let it_loc = it.location()
          //let it_page = numbering(it_loc.page-numbering(), ..counter(page).at(it_loc))
          let page = counter(page).at(it.location())
          let it_counter_arr = counter(heading).at(it_loc)

          let numbering_width = heading_numbering_width_per_level*it.level


          let sum_prev_levels = range(it.level).sum()
          let padd = (  (it.level - 1) * heading_numbering_intent 
                      + (sum_prev_levels) * heading_numbering_width_per_level*1 
                      )
          // box[#pad(left: padd)
          let preamb = box(fill: none)[#pad(left: padd)[
            #box(width: numbering_width + heading_numbering_intent, fill: none)[
              #numbering(it.numbering, ..it_counter_arr) //.display(it.numbering)
            ]
            //#h(1em)
          ]]

          //let t = 0
          //t = measure(preamb, styles).width
          //[#t]

          // only count, if the heading is numbered!
          let text_params = ()
          let fill_dots = box(width: 1fr, repeat[ #h(fill_dot_space) . #h(fill_dot_space)]) 

          // heading with level 1 has different styling
          if it.level == 1 {
            text_params = (
              font: "Roboto",
              fallback: false,
              weight: "bold"
            )
            fill_dots = box(width: 1fr)//, repeat(str.from-unicode(32)))
            v(heading_first_level_v_space, weak: true)
          }
          set text(
            ..text_params
          )
          link(it_loc)[
            #preamb#it.body 
            #fill_dots
            #box(width: heading_page_number_width)[
              #align(right)[#page.join()]
            ] 
            //#it.page
            //\
            //#it.fields()
            //#outline.entry(it.level, it, [Test], [], [])
            \
          ]
          heading_counter.step(level: it.level)
        }
      })


    }


    // check args
    #if not (outline_table_of_contents_style == "adapted" or outline_table_of_contents_style == "rewritten") {
      panic("outline_table_of_contents_style has to be either 'adapted' or 'rewritten'")
    }

  ]




  // restart page counter
  counter(page).update(1)
  // restart heading counter
  counter(heading).update(1)

  // Display the paper's contents.
  body
})
