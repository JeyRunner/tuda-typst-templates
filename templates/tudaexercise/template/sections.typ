// For now hardcoded value - should be half title rule height. Maybe change to state in the future however that will add a lot of computation complexity
#let tuda_section_line_height = 0.6pt

#let tuda-section-lines(above, below, body) = {
  block(
    width: 100%,
    inset: 0mm,
    outset: 0mm,
    above: 1.8em,
    below: 1em,
    {
      set block(spacing: 0.2em)
      line(length: 100%, stroke: tuda_section_line_height)
      body
      line(length: 100%, stroke: tuda_section_line_height)
    }
  )
}


// Creates a section similar to headers
// But does not add other text or a counter.
// ```
// #tuda-section("Lorem ipsum")
// 
// ```
#let tuda-section(title) = {
  tuda-section-lines(1.8em, 1.2em, text(title, font: "Roboto", weight: "bold", size: 11pt))
}

#let tuda-subsection(title) = {
  tuda-section-lines(0.9em, 0.6em, text(title, font: "Roboto", weight: "regular", size: 11pt))
}