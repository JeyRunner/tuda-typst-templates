// imports
#import "@preview/cetz:0.1.2": canvas, plot
#import "@preview/glossarium:0.2.5": make-glossary, print-glossary, gls, glspl 
#import "@preview/mitex:0.1.0": *
#show: make-glossary


#import "templates/tudapub/tudapub.typ": tudapub
#import "templates/tudapub/tudacolors.typ": tuda_colors


// setup
// #set page(width: 20cm, height:auto)
// #set heading(numbering: "1.")
// #set par(justify: true)


#show: tudapub.with(
  title: [
    TUDa Thesis
  ],
  author: "Albert Authors",
  logo_sub_content_text: [
    field of study: \
    Some Field of Study \
    \
    Institute ABC
  ],

  accentcolor: "9c"
)




// test content

= The First Chapter
This is some example text that is not very long, but needs to fill some space.

This starts a new paragraph. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words. Test words.

== Subheading
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor inci-
didunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque doleamus
animo, cum corpore dolemus, fieri tamen permagna accessio potest, si aliquod aeternum
et infinitum impendere malum nobis opinemur. Quod idem licet transferre in voluptatem,
ut postea variari voluptas distinguique possit, augeri amplificarique non possit. At etiam
Athenis, ut e patre audiebam facete et urbane Stoicos irridente, statua est in quo a nobis
philosophia defensa et collaudata est, cum id, quod maxime placeat, facere possimus,
omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam
et aut officiis debitis aut rerum necessitatibus saepe eveniet, ut et voluptates repudiandae
sint et molestiae non recusandae. Itaque earum rerum defuturum, quas natura non de-
pravata desiderat. Et quem ad me accedis, saluto: 'chaere,' inquam, 'Tite!' lictores, turma
omnis chorusque: 'chaere, Tite!' hinc hostis mi Albucius, hinc inimicus. Sed iure Mucius.
Ego autem mirari satis non queo unde hoc sit tam insolens domesticarum rerum fastid-
ium. Non est omnino hic docendi locus; sed ita prorsus existimo, neque eum Torquatum,
qui hoc primus cognomen invenerit, aut torquem illum hosti detraxisse, ut aliquam ex
eo est consecutus? – Laudem et caritatem, quae sunt vitae sine metu degendae praesidia
firmissima. – Filium morte multavit. – Si sine causa, nollem me ab eo delectari, quod
ista Platonis, Aristoteli, Theophrasti orationis ornamenta neglexerit. Nam illud quidem
physici, credere aliquid esse minimum, quod profecto numquam putavisset, si a Polyaeno,
familiari suo, geometrica discere maluisset quam illum etiam ipsum dedocere. 







== Test Coding
Lets autogenerate some stuff:
//#let x = (1, 2, 3)
#let x = range(0, 3)
#for (i, el) in x.map(el => el*2).enumerate() [
  - Element Nr. #i has value #el 
    #circle(fill: color.linear-rgb(100, 100, el*20), width: 12pt)
    //$circle$
]

== Subheading
Test #lorem(51)


This is a list:
 + an item
 + another item

=== Subsubheading


#lorem(584)
#pagebreak()
== Another Subsection
=== Subsub
#pagebreak()


== Lets do some math
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
This is possible with the packge #link("https://github.com/mitex-rs/mitex")[mitex]:
You can include the package in the beginning of your document via 
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
To reduce the spacing above and below block eqautions use:
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
  test in box
  #circle(width: 2.2cm, inset: 2mm)[
    And in the circle
  ]
]

Some more text here. #lorem(20)
In @fig.myfig we can seee stuff.

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