#import "@local/athena-tu-darmstadt-exercise:0.2.0": (
  subtask, task, text-roboto, title-sub, tuda-gray-info, tuda-section, tuda-subsection, tudaexercise, task-points-header, point-format, difficulty-format, tuda-difficulty-stars,
)

#show: tudaexercise.with(
  exercise-type: "exercise", // Choose between 'exercise' and 'submission'
  language: "en",
  info: (
    title: "Usage of TUDaExercise",
    subtitle: "A small guide.",
    author: (("Andreas", "129219"), "Dennis"),
    term: "Summer semester 2042",
    date: datetime.today(),
    sheet: 5,
    group: 1,
    tutor: "Dr. John Smith",
    lecturer: "Prof. Dr. Jane Doe",
    // Add custom key values pairs like this:
    // "A Custom Key": "A Custom Value"
  ),
  // If you want to include custom keys in the info, uncomment the info-layout as shown below and expand it with the key of your key-value pair.
  // info-layout: (
  //   left: ("term", "date", "sheet", "group"),
  //   right: ("tutor", "lecturer", "A Custom Key")
  // ),

  logo: image("logos/tuda_logo_replace.svg"),
  design: (
    accentcolor: "0b",
    colorback: true,
    darkmode: false,
  ),
  task-prefix: none,
)

#set enum(spacing: 1em, numbering: "1.", indent: 5pt)
#set list(marker: [--], indent: 5pt, spacing: 1em)

= Most basic usage

The easiest way is by using `typst init` like on this templates universe page. But here is everything broken down:

== Add to typst
+ Import the package: `#import "@preview/athena-tu-darmstadt-exercise:0.1.0": *`

+ Apply the template using `#show: tudaexercise.with(<options>)`

== Fonts
The template requires the following fonts: Roboto and XCharter. Typst right now does not allow fonts to be installed as packages. So you will either need to install them locally or configure Typst and co. to use the fonts.

#tuda-gray-info(title: "For more info:")[
  https://github.com/JeyRunner/tuda-typst-templates?tab=readme-ov-file#logo-and-font-setup
]

== Logo
Similarly as the logo is protected and Typst does not have a folder for global resources you will need to setup the logo manually. You will need to download the logo and convert it into a svg. Then pass the `logo: image(<path to logo>)` option to this package. The height of the logo will automatically be set to 22mm.

= Configuring the title
All options of the title can be controlled using the `info` dictionary:

```typst
info: (
  exercise-type: "exercise", // You can choose between 'exercise' and 'submission'
  title: "The big title",
  subtitle: "The smaller title below",
  author: "The author",
  // author: ("Author 1", "Author 2"), // can also be an array of authors
  // author: (("Author 1", "123456"), "Author 2"), // or the matriculation number can be provided
  term: "The current term aka. semester",
  date: "The current date",
  // date: datetime.today(), // can also be a datetime object
  sheet: 0, // The current sheetnumber

  // submission extras:
  group: "05", // the lecture group you are in
  tutor: "John", // the tutor of your group
  lecturer: "Karpfen", // the lecturer of the module that this assignment is for
  // "A Custom Key": "A Custom Value" // Adding a custom key values pair
)
```
The options can also be left empty. Then their corresponding item will not appear.

If you add a custom key, want to modify what is displayed or where it is displayed in the space below the title, include the parameter `info-layout` like shown in the example below:
```typst
#show: tudaexercise.with(
  // [...]
  info: (
    // [...]
    "A Custom Key": "A Custom Value" // Adding a custom key values pair
  )
  // If you want to include custom keys in the info, uncomment the info-layout as shown below and expand it with the key of your key-value pair.
  info-layout: (
    left: ("term", "date", "sheet", "group"),
    right: ("tutor", "lecturer", "A Custom Key")
  ),
  // [...]
)
```
Note that the value of the key-value-pair can also be any conent (e.g. an image: `"My Custom Key": [#image("path/to/image.png")]`). Only the keys specified in `info-layout` will show up in the info box.

If you do not want to have a title card you can also set `show-title` to `false`.

= Design

You can control the design using the following options of the `design` dictionary:

```
design: (
  accentcolor: "0b", // either be color code of the TUDa coloring scheme or a typst color object
  colorback: true, // whether the title should have the accent color as background,
  darkmode: false, // If you like a dark background
)
```

Furthermore using the `tud_design` state you get a dictionary with the following colors used by the template: ` text_color, background_color, accent_color, text_on_accent_color`.

Note that changing any of the state's values will have no effect on the template. See the state as read-only.

If you do not like lines around subtasks you can pass `subtask: "plain"` to not show the lines.

= More options

The leftover options are:
- `language` to control the language of certain keywords (can either be `"de"` or `"en"`)
- `margins` which is a dictionary controlling the page margins
- `paper` which currently only supports `"a4"`
- `headline` which currently is unsupported.


= Creating tasks

Creating tasks is fairly easy. You simply write
```
= Title of your task
```
Similarly subtasks are created using
```
== Title of your subtask
```

If you dislike the default task prefix, you can also set your own by changing the `taks-prefix` field of the template.

= Tasks with points and difficulty #task-points-header(points:5,difficulty: 2.65)
== Task point header #task-points-header(points: 2)
If you want to add points and difficulty to your tasks, you can use the `task-points-header` function. This will add a header to the task with the points and difficulty.
You can pass the following parameters:
- `points` (int or float): The amount of points of the task
- `difficulty` (int or float): The difficulty rating the task, must be a number between 0 and `max-difficulty`
- `max-difficulty` (int): The maximum difficulty, default is 5
- `hspace` (length): The horizontal space between the task title and the points, default is 1em
- `details-seperator` (string): The string that separates the task title from the points
  header, default is `", "`
- `star-fill` (color): The fill color of the stars, default is the currentaccent color
- `points-function` (function): The function to format the points, default is `point-format`
- `difficulty-function` (function): The function to format the difficulty, default is `tuda-difficulty-stars`, but you can also pass `difficulty-format` to use a more simple text representation of the difficulty (or even a custom function). See @task-and-subtask-commands to see `difficulty-format` in action.

For example you can writethe following command to recreate the header of this task:
```typst
= Tasks with points and difficulty #task-points-header(points: 5, difficulty: 2.65)
== Task point header #task-points-header(points: 2)
```

== Task and subtask commands #task-points-header(points: 1, difficulty: 1, difficulty-function: difficulty-format)<task-and-subtask-commands>
Instead of the normal section and subsection commands you can also use the `task` and `subtask` functions to create tasks and subtasks with points and difficulty:
```typst
#task(points: 5, difficulty: 3.69)[Tasks with *points* and _difficulty_]
// you can also just pass the points and omit the title if desired
#subtask(points: 2)
```
They take the same parameters as the `task-points-header` function, but additionally you can pass a `title` parameter to set the title of the task or subtask.
== Advanced task header styling (#task-points-header(
  points: 2,
  difficulty: 1.5,
  max-difficulty: 3,
  details-seperator: " | ",
  hspace: none,
  star-fill: blue,
  points-function: point-format.with(
    points-name-single: "Bonus point",
    points-name-plural: "Bonus points",
  ),
  difficulty-function: tuda-difficulty-stars.with(
    difficulty-name: "Effort",
    edges: 6,
    rotation: 45deg,
    baseline: 2pt,
  ),
))
As mentioned above, you can overwrite the point- and difficulty functions of the `task-points-header` function. This allows you to customize the header even further. For example, you can change the number of edges of the stars, the rotation of the stars, or the fill color of the stars:
```typst
== Advanced task header styling (#task-points-header(points: 2, difficulty: 1.5, max-difficulty: 3, details-seperator: " | ", hspace: none, star-fill: blue, points-function: point-format.with(points-name-single: "Bonus point", points-name-plural: "Bonus points", baseline: 2pt), difficulty-function: tuda-difficulty-stars.with(difficulty-name: "Effort", edges: 6, rotation: 45deg)))
```
#tuda-gray-info(title: "Note:")[
  Passing all these parameters everytime is a bit cumbersome, but since typst #link("https://github.com/typst/typst/issues/147")[does not yet support user-defined elements], this is the only way to archieve this without relying on states. You can create your own function to simplify this if you want to: ```typst
  #let custom-tph = task-points-header.with(points-function: point-format.with(points-name-single: "Bonus point", points-name-plural: "Bonus points"), difficulty-function: difficulty-format)
  ```
]

#pagebreak()

#tuda-subsection("Sections")

If you want to create an unnumbered section you can use the `tuda-section` or `tuda-subsection` functions accordingly. Simply pass the section title as a string.
```
#tuda-subsection("Sections")
```

= Currently not supported features from the LaTeX template and the why

+ Points -- This would require a state and make declaring tasks far more complex than just using headings. Though technically the points can also be written manually into the task title.

+ Solutions -- Enabling whether solutions should be shown or not from within the template would again require a state and is thus rather costly. However you can implement them rather easily as from outside the template a boolean will already do.

+ Headline -- The core problem here comes from how Typst's page margins and context work. There would be a workaround of just placing the title card over the headline of the first page but that is rather hacky. Thus sadly this also can't be implemented manually.
