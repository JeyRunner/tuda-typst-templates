#import "common/tudacolors.typ": tuda_colors, text_colors
#import "common/props.typ": tud_exercise_page_margin, tud_header_line_height, tud_inner_page_margin_top, tud_title_logo_height
#import "common/headings.typ": tuda-section, tuda-subsection, tuda-subsection-unruled
#import "common/util.typ": check-font-exists
#import "common/colorutil.typ": calc-relative-luminance, calc-contrast
#import "common/dictutil.typ": overwrite-dict
#import "title.typ": *
#import "locales.typ": *
#import "@preview/cetz:0.4.0"

#let design_defaults = (
  accentcolor: "0b",
  colorback: true,
  darkmode: false
)

#let s = state("tud_design")

/// The heart of this template.
/// Usage:
/// ```
/// #show: tudaexercise.with(<options>)
/// ```
/// 
/// - language ("eng", "ger"): The language for dates and certain keywords
/// - margins (dictionary): The page margins, possible entries: `top`, `left`, `bottom`, `right`
/// - headline (array): Currently not supported. Should be used to configure the headline.
/// - paper (str): The type of paper to be used. Currently only a4 is supported.
/// - logo (content): The tuda logo as an image to be used in the title.
/// - info (dictionary): Info about the document mostly used in the title.
/// - design (dictionary): Options for the design of the template. Possible entries: `accentcolor`, `colorback` and `darkmode`
/// - task-prefix (str): How the task numbers are prefixed. If unset, the tasks use the language default.
/// - show_title (bool): Whether to show a title or not
/// - subtask ("ruled", "plain"): How subtasks are shown
/// - body (content): 
#let tudaexercise(
  language: "eng",

  margins: tud_exercise_page_margin,

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
    groupnumber: none,
    tutor: none,
    lecturer: none,
  ),

  design: design_defaults,

  task-prefix: none,

  show-title: true,

  subtask: "ruled",

  body
) = {
  if paper != "a4" {
    panic("currently just a4 paper is supported")
  }

  let margins = overwrite-dict(margins, tud_exercise_page_margin)
  let design = overwrite-dict(design, design_defaults)
  let info = overwrite-dict(info, (
    title: none,
    header_title: none,
    subtitle: none,
    author: none,
    term: none,
    date: none,
    sheetnumber: none,
    groupnumber: none,
    tutor: none,
    lecturer: none,
  ))

  let text_color = if design.darkmode {
    white
  } else {
    black
  }

  let background_color = if design.darkmode {
    rgb(29,31,33)
  } else {
    white
  }

  let accent_color = if type(design.accentcolor) == color {
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
  
  s.update((
    text_color: text_color,
    background_color: background_color,
    accent_color: accent_color,
    text_on_accent_color: text_on_accent_color,
    darkmode: design.darkmode,
  ))

  set line(stroke: text_color)

  let ruled_subtask = if subtask == "ruled" {
    true
  } else if subtask == "plain" {
    false
  } else {
    panic("Only 'ruled' and 'plain' are supported subtask options")
  }
  
  let meta_document_title = if info.subtitle != none and info.title != none {
    [#info.subtitle #sym.dash.em #info.title]
  } else if info.title != none {
    info.title
  } else if info.subtitle != none {
    info.subtitle
  } else {
    none
  }

  set document(
    title: meta_document_title,
    author: if info.author != none {
      if type(info.author) == array {
        let authors = info.author.map(
          it => if type(it) == array {
            it.at(0)
          } else {
            it
          }
        )
        authors
      } else {
        info.author
      }
    } else {
      ()
    }
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
    spacing: 91%, // to make it look like the latex template,
    fill: text_color
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
      tuda-section(if (task-prefix != none) {task-prefix} else {dict.task + " "} + c + ": " + it.body)
    } else if it.level == 2 {
      if ruled_subtask {
        tuda-subsection(c + ") " + it.body)
      } else {
        tuda-subsection-unruled(c + ") " + it.body)
      }
    } else {
      it
    }
  }

  let identbar = rect(
    fill: accent_color,
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
      fill: background_color
    )

    if show-title {
      tuda-make-title(
        tud_inner_page_margin_top, 
        tud_header_line_height,
        accent_color,
        text_on_accent_color,
        text_color,
        design.colorback,
        logo, 
        tud_title_logo_height, 
        info,
        dict
        )
    }

    check-font-exists("Roboto")
    check-font-exists("XCharter")

    body
  }

}

#let tuda-gray-info(body) = context {
  let darkmode = s.get().darkmode
  let background = if(darkmode == false) {rgb("#f0f0f0")} else {rgb("#3F4647")}
  rect(
    fill: background,
    // inset: 1em,
    inset: (
      left: 8pt,
      y: 2mm,
    ),
    radius: 3pt,
    width: 100%,
    stroke: (left: 5pt + gray),
  [
    #body
  ])
}

#let textsf(body) = text(
  font: "Roboto",
  fallback: false,
  body,
)


/// Draws a star at the given position with the given number of edges, size, stroke width, fill color and rotation. Usage:
/// ```example
/// #cetz.canvas({
///  #draw-star((0,0),fill: red})
/// })
/// ```
///
/// - pos (position): The position where the star should be drawn.
/// - edges (int): The number of edges of the star. Default is 5.
/// - size (length): The size of the star. Default is 1cm.
/// - stroke (length): The stroke width of the star. Default is 1.5pt.
/// - fill (color): The fill color of the star. Default is red.
/// - rotation (angle): The rotation of the star in degrees. Default is 90deg.
/// -> Returns: A star shape.
#let draw-star(pos, edges: 5, size: 1cm, stroke: 1.5pt, fill: red, rotation: 90deg) = {
  let inner_size = size / 2 - stroke * 2
  let outer_r = inner_size
  let inner_r = inner_size * 0.4
  let points = ()
  for idx in range(edges * 2) {
    let angle = idx * (360deg / (edges * 2)) + rotation
    let radius = if calc.rem(idx, 2) == 0 { outer_r } else { inner_r }
    points.push((
      pos.at(0) + radius.cm() * calc.cos(angle),
      pos.at(1) + radius.cm() * calc.sin(angle),
    ))
  }
  cetz.draw.line(
    ..points,
    close: true,
    stroke: stroke,
    fill: fill,
  )
}

/// Draws a number of stars to represent the difficulty of a task.
///
/// - difficulty (float): The difficulty of the task, must be between 0 and `max_difficulty`.
/// - max_difficulty (int): The maximum difficulty, default is 5.
/// - fill (color): The fill color of the stars, default is `rgb(tuda_colors.at("3b"))`.
/// - size (length): The size of the stars, default is 1.2em.
/// - spacing (length): The spacing between the stars, default is 2pt.
/// - stroke (length): The stroke width of the stars, default is .8pt.
/// -> Returns: A canvas with the stars drawn on it.
#let difficulty-stars(difficulty, max_difficulty: 5, fill: rgb(tuda_colors.at("3b")), size: 1.2em, spacing: 2pt, stroke: .8pt) = context {
  if (type(difficulty) != float) {
    panic("difficulty must be a number")
  }
  if (difficulty < 0 or difficulty > max_difficulty) {
    panic("difficulty must be between 0 and " + str(max_difficulty))
  }
  let remaining_difficulty = difficulty
  return cetz.canvas(baseline: (0,.3em), for d in range(max_difficulty) {
    let fill_percentage = if remaining_difficulty > 0 {
      100% * calc.min(1, remaining_difficulty)
    } else {
      0%
    }
    draw-star((d * (size.to-absolute().cm() + spacing.cm() - 2 *stroke.cm()), 0), size: size.to-absolute(), fill: if fill_percentage
      > 0% {
      gradient.linear(
        (fill, 0%),
        (fill, fill_percentage),
        (rgb("#00000000"), fill_percentage),
        (rgb("#00000000"), 100%),
        angle: 0deg,
      )
    } else {
      rgb("#00000000")
    }, stroke: stroke.to-absolute())
    remaining_difficulty -= 1
  })
}

/// A task is a paragraph with a numbering and an indent. The numbering is either the task prefix or the default numbering.
/// - title (content): The title of the task.
/// - points (int): The number of points the task is worth, optional.
/// - difficulty (float): The difficulty of the task, optional.
/// - maxdifficulty (int): The maximum difficulty, default is 5.
#let task(
  title: content,
  points: none,
  difficulty: none,
  maxdifficulty: 5, // default maximum difficulty
) = {
  heading(
    {
      title
      h(1fr) // move remaining text to the right
      if(points != none or difficulty != none) {
        let details = ()
        if(points != none) {
          details.push([#points Punkte])
        }
        if(difficulty != none) {
          details.push([#difficulty-stars(difficulty,max_difficulty: maxdifficulty)])
        }
        details.join(", ")
      }
    },
  )
}

/// A subtask is a heading with a numbering and an indent. The numbering is either the task prefix or the default numbering.
///
/// - title (content): The title of the subtask.
/// - points (int): The number of points the subtask is worth, optional.
/// - difficulty (float): The difficulty of the subtask, optional.
/// - maxdifficulty (int): The maximum difficulty, default is 5.
#let subtask(
  title: content,
  points: none,
  difficulty: none,
  maxdifficulty: 5, // default maximum difficulty
) = {
  heading(
    {
      title
      h(1fr) // move remaining text to the right
      if(points != none or difficulty != none) {
        let details = ()
        if(points != none) {
          details.push([#points Punkte])
        }
        if(difficulty != none) {
          details.push([#difficulty-stars(difficulty, max_difficulty: maxdifficulty)])
        }
        details.join(", ")
      }
    },
    level: 2,
  )
}