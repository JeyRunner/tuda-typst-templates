#import "tudaexercise.typ": tudaexercise, tuda-section

#show: tudaexercise.with(
  locale: "ger",
  info: (
    title: "Example",
    header_title: "Example2",
    subtitle: "Example3",
    author: "Me",
    term: "WS 1",
    date: datetime.today(),
    sheetnumber: 0
  ),
  logo_path: "../../../assets/logos/tuda_logo.svg"
)

= Hallo
#lorem(100)

= BC

== Inline math

Math inside of text $x <= 10$.

== Block math

$
  forall x. forall y. forall z. R x y and R y z arrow.r.double R x z
  
$

#tuda-section("Test Section")


#pagebreak()
Abc
