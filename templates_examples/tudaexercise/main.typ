
#import "@local/athena-tu-darmstadt-exercise:0.1.0": *

#show: tuda-exercise.with(
  title: [
    TUDaThesis
  ],
  exercise-number: 5,
  author: "Albert Author",
  accentcolor: "9c",
  language: "eng",
)






// test content
= First Chapter
A first demo chapter.


== Some Basic Elements
This text contains two#footnote[The number two can also be written as 2.] footnotes#footnote[This is a first footnote. \ It has a second line.].

== Figures
The following @fig_test represents a demo Figure. 
#figure(
  rect(inset: 20pt, fill: gray)[
    Image
  ],
  caption: [The figure caption.]
) <fig_test>


