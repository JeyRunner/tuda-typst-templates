#import "props.typ": tud_heading_line_thin_stroke

#let tud-heading-with-lines(
  heading_margin_before: 0mm,
  heading_line_spacing: 0mm,
  text-size: 14.3pt,
  text-weight: "bold",
  text-prefix: "",
  text-suffix: "",
  counter-suffix: "",
  it
) = {
  set text(
      font: "Roboto",
      fallback: false,
      weight: text-weight,
      size: text-size
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
      v(heading_line_spacing),
      block({
        text-prefix
        if it.outlined and it.numbering != none {
          counter(heading).display(it.numbering)
          counter-suffix
          h(2pt)
        }
        it.body
        text-suffix
      
      }),
      v(heading_line_spacing),
      line(length: 100%, stroke: tud_heading_line_thin_stroke),
      v(10pt)
    )
  ]
}