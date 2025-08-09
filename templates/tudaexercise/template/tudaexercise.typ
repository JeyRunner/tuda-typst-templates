#import "common/tudacolors.typ": tuda_colors, text_colors
#import "common/props.typ": tud_exercise_page_margin, tud_header_line_height, tud_inner_page_margin_top, tud_title_logo_height
#import "common/headings.typ": tuda-section, tuda-subsection, tuda-subsection-unruled
#import "common/util.typ": check-font-exists
#import "common/addons/difficulty-points.typ": difficulty-stars
#import "common/colorutil.typ": calc-relative-luminance, calc-contrast
#import "common/format.typ": text-roboto
#import "title.typ": *

#let design-defaults = (
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
/// - exercise-type ("exercise", "submission"): The type of exercise. This modifies the subline 
///   (content below the header):
///    - `exercise` shows info-fields `term`, `date` and `sheet`
///    - `submission` additionally shows fields `group`, `tutor` and `lecturer` on the 
///       right-hand side
/// 
/// - language ("en", "de"): The language for dates and certain keywords
/// 
/// - margins (dictionary): The page margins, possible entries: `top`, `left`,
///   `bottom`, `right`
/// 
/// - headline (array): Currently not supported. Should be used to configure the headline.
/// 
/// - paper (str): The type of paper to be used. Currently only a4 is supported.
/// 
/// - logo (content): The tuda logo as an image to be used in the title.
/// 
/// - info (dictionary): Info about the document mostly used in the title.
/// 
///   The following items are used by the `exercise-type` `exercise`:
///   - `title`
///   - `subtitle`
///   - `author`
///
///   Additionally the following items are used by the `exercise-type` `submission`:
///   - `term`
///   - `date`
///   - `sheet`
///
///   For free customization of the subline (see `info-layout`) use key `custom-subline` and
///   pass any content (`[...]`) as value.
///   
///   Note: Items mapped to `none` are ignored aka. internally the dict is processed without
///   them. Furthermore items `term`, `date` and `sheet` will only show when using 
///   `exercise-type: "submission"`
/// 
/// - info-layout (dict, boolean): Defines the content's layout of the subline in the title
///   card.
///   By default the layout is defined in the following dict:
///     ```typst
///     (left: ("term", "date", "sheet", "group"),
///     right: ("tutor", "lecturer", "A Custom Key"))
///     ```
///   Left aligns left, and vice versa. The order of the keywords in the list, defines the 
///   order of the info displayed in the subline.
///   For complete customization set `info-layout: false` and define any content in the
///   `info` dict under the key `custom-subline`
/// 
/// - design (dictionary): Options for the design of the template. Possible entries: 
///   `accentcolor`, `colorback` and `darkmode`
/// 
/// - task-prefix (str,none): How the task numbers are prefixed. If unset, the tasks use the 
///   language default.
/// 
/// - show-title (bool): Whether to show a title or not
/// 
/// - subtask ("ruled", "plain"): How subtasks are shown
/// 
/// - body (content): 
#let tudaexercise(
  exercise-type: "exercise",

  language: "en",

  margins: tud_exercise_page_margin,

  headline: ("title", "name", "id"),

  paper: "a4",

  logo: none,

  info: (
    title: none,
    header_title: none,
    subtitle: none,
    author: none,
    term: none,
    date: none,
    sheet: none,
    group: none,
    tutor: none,
    lecturer: none,
  ),

  info-layout: (
    left: ("term", "date", "sheet", "group"),
    right: ("tutor", "lecturer")
  ),

  design: design-defaults,

  task-prefix: none,

  show-title: true,

  subtask: "ruled",

  body
) = {
  if paper != "a4" {
    panic("currently just a4 paper is supported")
  }

  let margins = tud_exercise_page_margin + margins
  let design = design-defaults + design
  let info = info.pairs().filter(x => x.at(1) != none).to-dict()

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
  
  let meta_document_title = if "subtitle" in info and "title" in info {
    [#info.subtitle #sym.dash.em #info.title]
  } else if "title" in info {
    info.title
  } else if "subtitle" in info {
    info.subtitle
  } else {
    none
  }

  set document(
    title: meta_document_title,
    author: if "author" in info {
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
    fill: text_color,
    lang: language,
  )

  let dict = get-locale-dict(language)

  set heading(numbering: (..numbers) => {
    if "sheet" in info {
      numbering("1.1a", info.sheet, ..numbers)
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
      let final-prefix = if (task-prefix != none) {
        task-prefix
      } else {
        dict.task + " "
      }
      tuda-section[#final-prefix#c: #it.body]
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
        info-layout,
        exercise-type,
        dict
        )
    }

    check-font-exists("Roboto")
    check-font-exists("XCharter")

    body
  }

}

#let tuda-gray-info(title: none, body) = context {
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
    #{if title != none [#text-roboto(strong(title)) \ ]}
    #body
  ])
}

/// Formats points for display in a task header.
///
/// - points (int, float): The number of points, can be an integer or a float.
/// - points-name-single (str): The singular form of the points name, default is auto and retrieved from the locale dictionary.
/// - points-name-plural (str): The plural form of the points name, default is auto and retrieved from the locale dictionary.
/// - pointssep (str): The separator between the points and the name, default is a space.
/// -> Returns: A string formatted as "points Punkte" or "points Punkt" depending on the value of points.
#let point-format(
  points: none,
  points-name-single: auto,
  points-name-plural: auto,
  pointssep: " ",
) = context {
  let ctxpoints-name-single = points-name-single
  let ctxpoints-name-plural = points-name-plural
  if points-name-single == auto or points-name-plural == auto {
    let dict = get-locale-dict(text.lang)
    if points-name-single == auto {
      ctxpoints-name-single = dict.point_singular
    }
    if points-name-plural == auto {
      ctxpoints-name-plural = dict.point_plural
    }
  }
  assert.ne(points, none, message: "points must be provided")
  assert(type(points) in (float, int), message: "points must be a number, got " + str(type(points)))
  str(points)
  pointssep
  if points == 1 {
    ctxpoints-name-single
  } else {
    ctxpoints-name-plural
  }
}

/// Formats the difficulty of a task for display in a task header.
///
/// - difficulty (int, float): The difficulty of the task, must be between 0 and `max-difficulty`.
/// - max-difficulty (int): The maximum difficulty, default is 5.
/// - difficulty-name (str, auto): The name of the difficulty, prefix for the stars, default is auto and retrieved from the locale dictionary.
/// - difficulty-sep (str): The separator between the difficulty name and the stars, default is ": ".
/// - out-of-sep (str): The separator between the difficulty and the maximum difficulty, default is "/".
/// - otherargs: Throwaway unneeded args used for different implementations of the difficulty format function.
/// -> Returns: A string formatted as "difficulty: difficulty/max-difficulty".
#let difficulty-format(
  difficulty,
  max-difficulty: 5,
  difficulty-name: auto,
  difficulty-sep: ": ",
  out-of-sep: "/",
  ..otherargs,
) = context {
  let ctxdifficulty-name = if difficulty-name == auto {
    get-locale-dict(text.lang).difficulty
  } else {
    difficulty-name
  }
  if ctxdifficulty-name != none {
    ctxdifficulty-name + difficulty-sep
  }
  str(difficulty) + out-of-sep + str(max-difficulty)
}

/// A header for tasks that includes points and difficulty information.
///
/// - points (int, float, none): The number of points the task is worth, optional.
/// - difficulty (int, float, none): The difficulty of the task, optional.
/// - max-difficulty (int): The maximum difficulty of the task, default is 5.
/// - hspace (length): The horizontal space between the title and the points/difficulty, default is 1fr.
/// - details-seperator (str): The separator between the points and difficulty information, default is ", ".
/// - star-fill (color): The fill color of the stars, default is the accent color from the context.
/// - points-function (function): The function to format the points, default is `point-format`.
/// - difficulty-function (function): The function to format the difficulty, default is `difficulty-stars`.
/// -> Returns: A string with the points and difficulty information formatted as "points Punkte, difficulty-stars(difficulty, max_difficulty: max-difficulty)".
#let task-points-header(
  points: none,
  difficulty: none,
  max-difficulty: 5,
  hspace: 1fr,
  details-seperator: ", ",
  star-fill: auto,
  points-function: point-format,
  difficulty-function: difficulty-stars,
) = context {
  assert(points != none or difficulty != none, message: "Either points or difficulty must be provided")
  if hspace != none {
    h(hspace)
  }
  let ctxstar-fill = star-fill
  if star-fill == auto {
    ctxstar-fill = s.get().accent_color
  }
  let details = ()
  if points != none {
    details.push(points-function(points: points))
  }
  if difficulty != none {
    details.push(difficulty-function(difficulty, max-difficulty: max-difficulty,fill:ctxstar-fill))
  }
  if details.len() > 0 {
    details.join(details-seperator)
  }
}

/// A wrapper command to create a section (a task in the context of this template) with a title and optional points and difficulty information. See `task-points-header` for the details.
///
/// - title (content): The title of the task.
/// - points (int): The number of points the task is worth, optional.
/// - difficuty (float): The difficulty of the task, optional.
/// - otherargs: Additional arguments to pass to the `task-points-header` function.
/// -> Returns: A heading with the title and optional points and difficulty information.
#let task(
  title: none,
  points: none,
  difficulty: none,
  ..otherargs,
) = {
  if otherargs.pos().len() > 0 and title == none {
    title = otherargs.at(0)
  }
  heading({
    title
    if points != none or difficulty != none {
      task-points-header(
        points: points,
        difficulty: difficulty,
        ..otherargs.named(),
      )
    }
  })
}

/// A wrapper command to create a subtask (a subtask in the context of this template) with a title and optional points and difficulty information. See `task-points-header` for the details.
///
/// - title (content): The title of the subtask.
/// - points (int): The number of points the subtask is worth, optional.
/// - difficulty (float): The difficulty of the subtask, optional.
/// - otherargs: Additional arguments to pass to the `task-points-header` function.
/// -> Returns: A heading with the title and optional points and difficulty information.
#let subtask(
  title: none,
  points: none,
  difficulty: none,
  ..otherargs,
) = {
  if otherargs.pos().len() > 0 and title == none {
    title = otherargs.at(0)
  }
  heading(
    {
      title
      if points != none or difficulty != none {
        task-points-header(
          points: points,
          difficulty: difficulty,
          ..otherargs.named(),
        )
      }
    },
    level: 2,
  )
}