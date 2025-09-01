#import "format.typ": *

#let tudapub-get-thesis-statement-pursuant(
  date: none,
  author: none,
  location: none,
  include-english-translation: false,
  signature: none,
) = [
  #set page(
    // Original margins are (left: 3cm, right 2cm, top: 2.5cm, bottom: 2.3cm)
    margin: (x: 25mm, top: 25mm, bottom: 23mm),
    footer: [
      #grid(
        rows: auto,
        line(length: 100%, stroke: 0.6pt),
        v(2.5mm),
        text(
          font: "Roboto",
          size: 10pt, // Originally 8pt
          lang: "de",
        )[Erklärung zur Abschlussarbeit #h(1fr) Dezernat II -- Studium und Lehre, Hochschulrecht #h(1fr) Stand 28.04.2023],
        // Originally 'Vorlage "Erklärung zur Abschlussarbeit"'
      )
    ],
  )
  #set heading(outlined: false)
  #set par(justify: false)

  #block(breakable: false)[
    *Erklärung zur Abschlussarbeit gemäß § 22 Abs. 7 APB TU Darmstadt*

    Hiermit erkläre ich, #author, dass ich die vorliegende Arbeit gemäß § 22 Abs. 7 APB TU Darmstadt selbstständig, ohne Hilfe Dritter und nur mit den angegebenen Quellen und Hilfsmitteln angefertigt habe. Ich habe mit Ausnahme der zitierten Literatur und anderer in der Arbeit genannter Quellen keine fremden Hilfsmittel benutzt. Die von mir bei der Anfertigung dieser wissenschaftlichen Arbeit wörtlich oder inhaltlich benutzte Literatur und alle anderen Quellen habe ich im Text deutlich gekennzeichnet und gesondert aufgeführt. Dies gilt auch für Quellen oder Hilfsmittel aus dem Internet.

    Diese Arbeit hat in gleicher oder ähnlicher Form noch keiner Prüfungsbehörde vorgelegen.

    Mir ist bekannt, dass im Falle eines Plagiats (§38 Abs.2 APB) ein Täuschungsversuch vorliegt, der dazu führt, dass die Arbeit mit 5,0 bewertet und damit ein Prüfungsversuch verbraucht wird. Abschlussarbeiten dürfen nur einmal wiederholt werden.

    Bei einer Thesis des Fachbereichs Architektur entspricht die eingereichte elektronische Fassung dem vorgestellten Modell und den vorgelegten Plänen.
  ]

  #block(breakable: false)[
    #if include-english-translation [
      // Not sure what the exact spacing is, but this looks quite similar
      #v(1em)
      #line(length: 100%, stroke: 0.6pt)
      #v(1em)

      *English translation for information purposes  only:*

      *Thesis Statement pursuant to § 22 paragraph 7 of APB TU Darmstadt*

      I herewith formally declare that I, #author, have written the submitted thesis independently pursuant to § 22 paragraph 7 of APB TU Darmstadt without any outside support and using only the quoted literature and other sources. I did not use any outside support except for the quoted literature and other sources mentioned in the paper. I have clearly marked and separately listed in the text the literature used literally or in terms of content and all other sources I used for the preparation of this academic work. This also applies to sources or aids from the Internet.

      This thesis has not been handed in or published before in the same or similar form.

      I am aware, that in case of an attempt at deception based on plagiarism (§38 Abs. 2 APB), the thesis would be graded with 5,0 and counted as one failed examination attempt. The thesis may only be repeated once.

      For a thesis of the Department of Architecture, the submitted electronic version corresponds to the presented model and the submitted architectural plans.
    ]

    #v(1em)
    #line(length: 100%, stroke: 0.6pt)
    #v(1em)

    #v(1.4cm)

    #table(
      columns: (1fr, auto),
      inset: 0pt,
      stroke: none,
      align: horizon,
      [
        #location,
        #format-date(date, "de")
      ],
      align(right)[
        #stack(
          [
            #set image(width: 4.5cm, height: 1cm, fit: "contain")
            #place(center + bottom)[#signature]
          ],
          line(length: 5cm, stroke: 0.3pt),
          v(2mm),
          align(center)[
            #author
          ],
        )
      ],
    )
  ]
]
