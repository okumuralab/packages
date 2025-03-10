// CONSTANTS:

#let heading-fonts = ("League Spartan", "Arial", "Liberation Sans")
#let normal-fonts = ("Source Serif", "Source Serif 4", "Georgia")


// TOOLS:

#let insa-translate(translations, key, lang, placeholders: (:)) = {
  let key-translations = translations.at(key)
  let string
  if lang in key-translations {
    string = key-translations.at(lang)
  } else {
    string = key-translations.at("fr")
  }
  for (p-key, p-val) in placeholders.pairs() {
    string = string.replace("{" + p-key + "}", p-val)
  }
  string
}


// FULL DOCUMENT:

#let insa-document(
  cover-type,
  cover-top-left: [],
  cover-middle-left: [],
  cover-bottom-right: [],
  back-cover: [],
  page-header: none,
  page-footer: none,
  include-back-cover: true,
  insa: "rennes",
  lang: "fr",
  metadata-title: none,
  metadata-authors: (),
  metadata-date: auto,
  doc
) = {
  set document(author: metadata-authors, date: metadata-date, title: metadata-title)

  set text(lang: lang, font: heading-fonts)
  set page("a4", margin: 0cm)

  set par(justify: false) // only for the cover

  let back-page

  let supported-insas = ("rennes", "hdf", "cvl")
  assert(supported-insas.contains(insa), message: "Only INSAs " + supported-insas.join(" ") + " are supported for now.")

  if cover-type == "light" {
    back-page = page(footer: none, header: none, margin: 0cm, image("assets/"+insa+"/back-cover2.png", width: 101%))

    // image
    place(image("assets/"+insa+"/front-cover1.png", width: 100%))

    // top-left
    place(
      dx: 2.5cm,
      dy: 6.5cm,
      block(
        width: 9.5cm,
        text(size: 18pt, cover-top-left)
      )
    )

    // middle-left
    place(
      dx: 2.5cm,
      dy: 13.7cm,
      block(
        width: 6.5cm,
        height: 7cm,
        align(horizon, text(size: 16pt, cover-middle-left))
      )
    )

    // bottom-right
    place(
      dx: 9.5cm,
      dy: 25.5cm,
      box(
        width: 8.5cm,
        text(size: 24pt, cover-bottom-right)
      )
    )

    if back-cover != [] {
      panic("back-cover has content but is incompatible with this cover-type")
    }

  } else if cover-type == "colored" {
    back-page = page(footer: none, header: none, margin: 0cm, image("assets/"+insa+"/back-cover2.png", width: 101%))

    // image
    place(image("assets/"+insa+"/front-cover3.png", width: 100%))

    // top-left
    place(
      dx: 2.5cm,
      dy: 7.5cm,
      block(
        width: 9.5cm,
        text(size: 20pt, fill: white, cover-top-left)
      )
    )

    if cover-middle-left != [] {
      panic("cover-middle-left has content but is incompatible with this cover-type")
    }
    if cover-bottom-right != [] {
      panic("cover-bottom-right has content but is incompatible with this cover-type")
    }
    if back-cover != [] {
      panic("back-cover has content but is incompatible with this cover-type")
    }

  } else if cover-type == "pfe" {
    back-page = page(footer: none, header: none, margin: 0cm)[
      #place(image("assets/"+insa+"/back-cover1.png", width: 100%))
      #place(dx: 1cm, dy: 1.2cm, block(width: 18.5cm, height: 19.6cm, back-cover))
    ]

    // image
    place(image("assets/"+insa+"/front-cover2.png", width: 100%))

    // top-left
    place(
      dx: 2.5cm,
      dy: 6.5cm,
      block(
        width: 9.5cm,
        text(size: 18pt, cover-top-left)
      )
    )

    // middle-left
    place(
      dx: 2.5cm,
      dy: 13.7cm,
      block(
        width: 9.5cm,
        height: 14cm,
        align(horizon, text(size: 16pt, cover-middle-left))
      )
    )

    // bottom-right
    place(
      dx: 12.3cm,
      dy: 25.5cm,
      box(
        width: 7.5cm,
        text(size: 20pt, cover-bottom-right)
      )
    )

  } else {
    panic("Unknown cover-type: only 'light', 'colored' and 'pfe' available.")
  }

  
  counter(page).update(0)
  set page(
    "a4",
    margin: (x: 1.75cm, y: 2.5cm),
    footer: context {
      place(
        right + bottom,
        dx: page.margin.at("right") - 0.6cm,
        dy: -0.6cm,
        box(width: 2.34cm, height: 2.34cm, image("assets/footer.png"))
      )
      if counter(page).get().at(0) > 0 {
        place(
          right + bottom,
          dx: page.margin.at("right") - 0.6cm,
          dy: -0.6cm,
          box(width: 1.15cm, height: 1.15cm, align(center + horizon, text(fill: white, size: 14pt, font: heading-fonts, weight: "bold", counter(page).display())))
        )
      }
      page-footer
    },
    header: {
      if page-header == none {
        image("assets/"+insa+"/logo.png", width: 4.68cm)
      } else if page-header != [] {
        page-header
        line(length: 100%)
      }
    }
  )
  show heading: set text(font: heading-fonts, weight: "bold")
  set text(font: normal-fonts, weight: "regular")
  set par(justify: true, first-line-indent: 1em)
  set figure(numbering: "1")
  set outline(indent: auto)
  show figure.where(kind: image): set figure(supplement: "Figure") // par défaut, Typst affiche "Fig."
  show figure.caption: it => [
    #text(weight: "bold")[
      #it.supplement
      #context it.counter.display(it.numbering) :
    ]
    #it.body
  ]
  
  doc

  if (include-back-cover) {
    back-page
  }
}


// REPORT DOCUMENT:

#let insa-report(
  id: 1,
  pre-title: none,
  title : none,
  authors: [],
  date: none,
  insa: "rennes",
  lang: "fr",
  doc,
) = insa-document(
  "light",
  cover-middle-left: authors,
  cover-top-left: [
    #set text(size: 28pt, weight: "bold")
    #if pre-title != none [
      #pre-title #sym.hyph
    ]
    TP #id\
    #set text(size: 22pt, weight: "medium")
    #smallcaps(title)
  ],
  page-header: [
    TP #id #sym.hyph #smallcaps(title)
    #h(1fr)
    #if type(date) == datetime {
      date.display("[day]/[month]/[year]")
     } else {
      date
     }
  ],
  include-back-cover: false,
  lang: lang,
  insa: insa,
  metadata-title: title,
  metadata-date: if type(date) == datetime {date} else {auto},
  {
    set math.equation(numbering: "(1)")
    set text(hyphenate: false)
    set heading(numbering: "I.1.")
    set par(first-line-indent: 0em)
    show heading.where(level: 1): it => {
      set text(18pt)
      upper(it)
      // Do not use the `smallcaps` function until Typst implements a fallback in the case the font does not provide smcp capability.
    }
    show raw.where(block: true): it => block(stroke: 0.5pt + black, inset: 5pt, width: 100%, it)
    show raw.line: it => if it.count > 1{
      text(fill: luma(150), str(it.number)) + h(2em) + it.body
    } else {it}
    doc
  }
)


// STAGE DOCUMENT:

#let insa-stage-translations = (
  "title": ("fr": "Stage présenté par", "en": "Internship presented by"),
  "student": ("fr": "Élève-ingénieur{gender-suffix} de l'INSA Rennes", "en": "INSA Rennes Engineering Student"),
  "department": ("fr": "Spécialité {department}", "en": "Department {department}"),
  "location": ("fr": "Lieu du Stage", "en": "Stage Location"),
  "company-tutor": ("fr": "Maître de Stage", "en": "Training supervisor"),
  "insa-tutor": ("fr": "Correspondant{gender-suffix} pédagogique INSA", "en": "Academic supervisor (INSA)"),
  "thanks-heading": ("fr": "Remerciements", "en": "Special Thanks")
)

#let insa-stage-translate(key, lang, placeholders: (:)) = insa-translate(insa-stage-translations, key, lang, placeholders: placeholders)

#let insa-stage(
  name,
  department,
  year,
  title,
  company,
  company-logo,
  company-tutor,
  insa-tutor,
  insa-tutor-suffix: "",
  summary-french,
  summary-english,
  student-suffix: "",
  thanks-page: none,
  omit-outline: false, // can be used to have more control over how the outline is shown
  insa: "rennes",
  lang: "fr",
  doc
) = insa-document(
  "pfe",
  cover-top-left: [
    #text(size: 17pt, font: normal-fonts, insa-stage-translate("title", lang))\
    #text(size: 21pt, font: heading-fonts, weight: "bold", name)\
    #text(size: 17pt, font: normal-fonts)[
      #insa-stage-translate("student", lang, placeholders: ("gender-suffix": student-suffix))\
      #insa-stage-translate("department", lang, placeholders: ("department": department))\
      #year
    ]
  ],
  cover-middle-left: [
    #text(size: 17pt, upper(title))

    #set text(size: 15pt, font: normal-fonts)
    *#insa-stage-translate("location", lang)*\
    #company

    *#insa-stage-translate("company-tutor", lang)*\
    #company-tutor

    *#insa-stage-translate("insa-tutor", lang, placeholders: ("gender-suffix": insa-tutor-suffix))*\
    #insa-tutor
  ],
  cover-bottom-right: company-logo,
  insa : insa,
  page-header: [],
  back-cover: {
    set text(font: normal-fonts, size: 14pt)
    place(dx: -.2cm, dy: 3.5cm, block(width: 8.9cm, height: 16cm, summary-french))
    place(dx: 9.2cm, block(width: 9.3cm, height: 16cm, inset: 0.2cm, summary-english))
  },
  lang: lang,
  metadata-title: title,
  metadata-authors: (name,),
  {
    set heading(numbering: "1.1    ")
    show heading.where(level: 1): it => text(size: 18pt, upper(it))
    show heading.where(level: 2): set text(size: 16pt)
    show heading.where(level: 3): set text(size: 15pt)
    show heading.where(level: 4): set text(size: 14pt)
    
    if thanks-page != none and thanks-page != [] {
      counter(page).update(0)
      heading(insa-stage-translate("thanks-heading", lang), numbering: none, outlined: false)
      thanks-page
      pagebreak()
    }

    if not omit-outline {
      counter(page).update(0)
      show outline: set heading(outlined: false)
      outline()
      pagebreak()
    }
    doc
  }
)
