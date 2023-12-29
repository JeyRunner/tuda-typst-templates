#let natural-image(..args) = style(styles => {
  let (width, height) = measure(image(..args), styles)
  image(..args, width: width, height: height)
})




#let get-spacing-zero-if-first-on-page(default_spacing, heading_location, content_page_margin_full_top, enable: true) = {
    // get previous element
    //let elems = query(
    //  selector(heading).before(loc, inclusive: false),
    //  loc
    //)
    //[#elems]
    if not enable {
      return (default_spacing, false)
    }

    // check if heading is first element on page
    // note: this is a hack
    let heading_is_first_el_on_page = heading_location.position().y <= content_page_margin_full_top

    // change heading margin depending if its the first on the page
    if heading_is_first_el_on_page {
      return (0mm, true)
    }
    else {
      return (default_spacing, false)
    }
}