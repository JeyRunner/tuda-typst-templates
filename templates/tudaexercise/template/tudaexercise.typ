#import "common/tudacolors.typ": tuda_colors, text_colors
#import "common/props.typ": tud_exercise_page_margin, tud_header_line_height, tud_inner_page_margin_top, tud_title_logo_height
#import "common/headings.typ": tuda-section, tuda-subsection, tuda-subsection-unruled
#import "common/util.typ": check-font-exists
#import "common/addons.typ": difficulty-stars
#import "common/colorutil.typ": calc-relative-luminance, calc-contrast
#import "common/format.typ": text-roboto
#import "title.typ": *
#import "locales.typ": *
#import "title-sub.typ" as title-sub

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
/// - language ("eng", "ger"): The language for dates and certain keywords
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
///   By default accepts the following items:
///   - `title`
///   - `subtitle`
///   - `author` 
///   
///   Additionally the following items are used by the `exercise` `title-sub`:
///   - `term`
///   - `date`
///   - `sheet`
///   
///   Other `title-sub`s may use more options, which can be added here. See the documentation
///   of the `title-sub` for corresponding items.
///   
///   Note: Items mapped to `none` are ignored aka. internally the dict is processed without
///   them.
/// 
/// - title-sub (content, function, none): The content of the subline in the title card.
///   By default the `title-sub.exercise` style.
/// 
///   See the `title-sub` export for functions to insert here or if you do not find something
///   fitting to your needs you can also pass raw content and completely customize it yourself.
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
  language: "eng",

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

  title-sub: title-sub.exercise(),

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
    language: language,
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
    fill: text_color
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
        title-sub,
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

#let textsf(body) = text(
  font: "Roboto",
  fallback: false,
  body,
)

/// Formats points for display in a task header.
///
/// - points (int, float): The number of points, can be an integer or a float.
/// - pointsnamesingle (str): The singular form of the points name, default is auto and retrieved from the locale dictionary.
/// - pointsnameplural (str): The plural form of the points name, default is auto and retrieved from the locale dictionary.
/// - pointssep (str): The separator between the points and the name, default is a space.
/// -> Returns: A string formatted as "points Punkte" or "points Punkt" depending on the value of points.
#let pointformat(
  points: none,
  pointsnamesingle: auto,
  pointsnameplural: auto,
  pointssep: " ",
) = context {
  let ctxpointsnamesingle = pointsnamesingle
  let ctxpointsnameplural = pointsnameplural
  if (pointsnamesingle == auto or pointsnameplural == auto) {
    let dict = get-locale-dict(s.get().language)
    if (pointsnamesingle == auto) {
      ctxpointsnamesingle = dict.point_singular
    }
    if (pointsnameplural == auto) {
      ctxpointsnameplural = dict.point_plural
    }
  }
  assert(points != none, message: "points must be provided")
  assert(type(points) == int or type(points) == float, message: "points must be a number, got " + str(type(points)))
  str(points)
  pointssep
  if (points == 1) {
    ctxpointsnamesingle
  } else {
    ctxpointsnameplural
  }
}

/// Formats the difficulty of a task for display in a task header.
///
/// - difficulty (int, float): The difficulty of the task, must be between 0 and `maxdifficulty`.
/// - maxdifficulty (int): The maximum difficulty, default is 5.
/// - difficultyname (str, auto): The name of the difficulty, prefix for the stars, default is auto and retrieved from the locale dictionary.
/// - difficultysep (str): The separator between the difficulty name and the stars, default is ": ".
/// - outofsep (str): The separator between the difficulty and the maximum difficulty, default is "/".
/// - otherargs: Throwaway unneeded args used for different implementations of the difficulty format function.
/// -> Returns: A string formatted as "difficulty: difficulty/maxdifficulty".
#let difficultyformat(
  difficulty,
  maxdifficulty: 5,
  difficultyname: auto,
  difficultysep: ": ",
  outofsep: "/",
  ..otherargs,
) = context {
  let ctxdifficultyname = difficultyname
  if(difficultyname == auto) {
    ctxdifficultyname = get-locale-dict(s.get().language).difficulty
  }
  if(ctxdifficultyname != none) {
    ctxdifficultyname + difficultysep
  }
  str(difficulty) + outofsep + str(maxdifficulty)
}

/// A header for tasks that includes points and difficulty information.
///
/// - points (int, float, none): The number of points the task is worth, optional.
/// - difficulty (int, float, none): The difficulty of the task, optional.
/// - maxdifficulty (int): The maximum difficulty of the task, default is 5.
/// - hspace (length): The horizontal space between the title and the points/difficulty, default is 1fr.
/// - detailsseperator (str): The separator between the points and difficulty information, default is ", ".
/// - starfill (color): The fill color of the stars, default is the accent color from the context.
/// - pointsfunction (function): The function to format the points, default is `pointformat`.
/// - difficultyfunction (function): The function to format the difficulty, default is `difficulty-stars`.
/// -> Returns: A string with the points and difficulty information formatted as "points Punkte, difficulty-stars(difficulty, max_difficulty: maxdifficulty)".
#let task-points-header(
  points: none,
  difficulty: none,
  maxdifficulty: 5,
  hspace: 1fr,
  detailsseperator: ", ",
  starfill: auto,
  pointsfunction: pointformat,
  difficultyfunction: difficulty-stars,
) = context {
  assert(points != none or difficulty != none, message: "Either points or difficulty must be provided")
  if(hspace != none) {
    h(hspace)
  }
  let ctxstarfill = starfill
  if(starfill == auto) {
    ctxstarfill = s.get().accent_color
  }
  let details = ()
  if(points != none) {
    details.push(pointsfunction(points: points))
  }
  if(difficulty != none) {
    details.push(difficultyfunction(difficulty, maxdifficulty: maxdifficulty,fill:ctxstarfill))
  }
  if(details.len() > 0) {
    details.join(detailsseperator)
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
  heading({
    title
    if (points != none or difficulty != none) {
      task-points-header(
        points: points,
        difficulty: difficulty,
        ..otherargs
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
  heading(
    {
      title
      if (points != none or difficulty != none) {
        task-points-header(
          points: points,
          difficulty: difficulty,
          ..otherargs
        )
      }
    },
    level: 2,
  )
}