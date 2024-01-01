// imports
#import "@preview/cetz:0.1.2": canvas, plot
#import "@preview/glossarium:0.2.5": make-glossary, print-glossary, gls, glspl 
#import "@preview/mitex:0.1.0": *
#show: make-glossary


#import "templates/tudapub/tudapub.typ": tudapub
#import "templates/tudapub/tudacolors.typ": tuda_colors


// setup the template
#show: tudapub.with(
  title: [
    TUDa Thesis 
    With Typst
  ],
  author: "Albert Author",
  logo_sub_content_text: [
    field of study: \
    Some Field of Study \
    \
    Institute ABC
  ],

  accentcolor: "9c",

  // change the pagemargins with
  // margin: (
  //  top: 15mm,
  //  left: 15mm,
  //  right: 15mm,
  //  bottom: 15mm - 1mm
  // )
)




// test content
= The First Chapter
This is some example text that is not very long but needs to fill some space.

== Demo Paragraphs
Here is some demo text. #lorem(50)

#lorem(110)

#lorem(60)


== Some Basic Elements
This text contains two#footnote[The number two can also be written as 2.] footnotes#footnote[This is a first footnote. \ It has a second line.].

=== Figures
The following @fig_test represents a demo Figure. 
#figure(
  rect(inset: 20pt, fill: gray)[
    Here should be an Image
  ],
  caption: [The figure caption.]
) <fig_test>

We can also make tables, as in @fig_tab_test.
#figure(
  table(
    columns: 2,
    [A], [B],
    [1], [2]
  ),
  caption: [This is the table title.]
) <fig_tab_test>
The text continues normally after the Figures.


#pagebreak()
== Test Coding
Let's autogenerate some stuff:
//#let x = (1, 2, 3)
#let x = range(0, 3)
#for (i, el) in x.map(el => el*2).enumerate() [
  - Element Nr. #i has value #el 
    #circle(fill: color.linear-rgb(100, 100, el*20), width: 12pt)
    //$circle$
]

== Lists
This is a list:
 + an item
 + another item

This is another list
 - an item
 - another item
 - yet another item


#pagebreak()


== Let's do some math
Bla _blub_ *bold*.
Math: $x + y (a+b)/2$.


$
"Align:"& \
        & x+y^2    && != 27 sum_(n=0)^N e^(i dot pi dot n) \
        & "s.t. "  && b c
        \
        \
        & mat(
            1,3 ;
            3, 4
          )^T
          && = 
          alpha 
          mat(
            x ,y ;
            x_2, y_2
          )^T
          \
          \
          & underbrace( cal(B) >= B , "This is fancy!")
$
$ 
x &= y^2 + 12  & "(This does A)"
$
$ 
y &= z \/ 2  =  z / 2 & "(This does B)"
$ <eq.last>
In @eq.last we can see cool stuff.


=== Math in Latex
This is possible with the package #link("https://github.com/mitex-rs/mitex")[mitex]:
You can include the package at the beginning of your document via 
//```typst
#raw(lang: "typst", "#import \"@preview/mitex:0.1.0\": *")
//```
.
Usage:
#block(breakable: false)[
  #table(
    columns: 2,
    ```latex
    mitex(`
    \begin{pmatrix}
      \dot{r}_x + \omega r_x - \omega p_x \\ 
      \dot{r}_x - \omega r_x + \omega p_x
    \end{pmatrix}
    =
    \begin{pmatrix}
      +\omega \xi_x - \omega p_x \\ 
      -\omega s_x + \omega p_x
    \end{pmatrix}
    `)
    ```,

    mitex(`
        \begin{pmatrix}
            \dot{r}_x + \omega r_x - \omega p_x \\ 
            \dot{r}_x - \omega r_x + \omega p_x
        \end{pmatrix}
        =
        \begin{pmatrix}
            +\omega \xi_x - \omega p_x \\ 
            -\omega s_x + \omega p_x
        \end{pmatrix}
    `)
  )
]

=== #strike[Ajust Equation spacing]
To reduce the spacing above and below block equations use:
```typst
#show math.equation: set block(spacing: 0.1em) // does not work!
```
#table(
  columns: 2,
  [With default spacing], [With reduced spacing],
  [
    This is Text.
    $
    x^2 = y^2
    $
    This is Text.
  ],
  [
    #show math.equation: set block(spacing: 0.5em)
    This is Text.
    $
    x^2 = y^2
    $
    This is Text.
  ]
)


== Another Section
Some graphics: \
#box(stroke: black, inset: 5mm)[
  test in a box
  #circle(width: 2.2cm, inset: 2mm)[
    And in the circle
  ]
]

Some more text here. #lorem(20)
In @fig.myfig we can see things.

#figure(
  [
    #rect(inset: 20.9pt)[Dummy Test]
  ],
  caption: [
    This is a figure
  ]
)<fig.myfig>


#lorem(100)





= Colors
The list of colors:
#grid(
  columns: auto,
  rows: auto,
  for (key, color) in tuda_colors {
    box(
      inset: 3pt,
      width: 100% / 3,
      box(
        height: auto,
        inset: 4pt,
        outset: 0pt,
        width: 100%,
        fill: rgb(color)
      )[
        #set align(center)
        #key
      ]
    )
  }
)



 


= Glossary
#print-glossary((
  // minimal term
  (key: "kuleuven", short: "KU Leuven"),
  // a term with a long form
  (key: "unamur", short: "UNamur", long: "Université de Namur"),
  // no long form here
  (key: "kdecom", short: "KDE Community", desc:"An international team developing and distributing Open Source software."),
  // a full term with description containing markup
  (
    key: "oidc", 
    short: "OIDC", 
    long: "OpenID Connect", 
    desc: [OpenID is an open standard and decentralized authentication protocol promoted by the non-profit
     #link("https://en.wikipedia.org/wiki/OpenID#OpenID_Foundation")[OpenID Foundation].]),
),
  show-all: true
)