#let font_size(..p) = 10pt * calc.pow(1.125, p.at(0, default: 0))
#let yaml = yaml(sys.inputs.at("loc", default: "./templates/example.yaml"))
#let doc = (
  heading_spacing_above: 20pt,
  heading_spacing_below: 10pt,
  leading: 6pt,
)

#set page(paper: "a4", margin: (x: 1.5cm, y: 2cm))
#set text(font: "new computer modern", font_size())
#set par(leading: doc.leading, spacing: 8pt)
#set grid(row-gutter: doc.leading)
#set list(marker: align(horizon, text("\u{f054}", size: 7pt)))
#show link: c => text(c, weight: "bold")

#let section(name, opt: none, content) = {
  block(
    inset: (bottom: 8pt),
    stroke: (bottom: stroke(0.7pt)),
    width: 100%,
    above: doc.heading_spacing_above,
    below: doc.heading_spacing_below,
    heading(text(name, weight: "bold", font_size(1))),
  )

  block(inset: (x: 1%), content)
}

#let split(..items) = block(below: doc.heading_spacing_below, above: doc.heading_spacing_above, grid(
  columns: (1fr, 1fr),
  column-gutter: 50pt,
  ..items,
))


#block()[
  #let header_informations = [
    #text(yaml.header.name, font_size(6), weight: "bold") \
    #text(yaml.header.title, font_size(3)) \

    #for (key, value) in yaml.header.contact {
      let display_contact(icon, content) = {
        box(inset: (left: 1pt))[
          #icon
          #h(6pt, weak: true)
          #content
        ]
      }

      let format_value(..template) = {
        if template.at(0, default: none) != none {
          let display = template.at(0).replace("{}", value)
          link(template.at(1, default: "https://www.{}").replace("{}", display), display)
        } else {
          value
        }
      }

      let matches(expected, icon, ..content) = {
        if key == expected {
          display_contact(icon, format_value(..content))
        }
      }

      matches("github", "\u{f09b}", "github.com/{}")
      matches("linkedin", "\u{f08c}", "linkedin.com/in/{}")
      matches("email", "\u{f0e0}", "{}", "mailto:{}")
      matches("phone", "\u{f3cf}")
      matches("location", "\u{f3c5}")

      if key == "other" {
        for (icon, value, ..rest) in value {
          let url = rest.at("url", default: none)

          display_contact(icon, if url != none { link(url, value) } else { value })
        }
      }

      h(15pt)
    }
  ]

  #grid(
    columns: (3fr, 1fr),
    header_informations,
    if "image" in yaml.header {
      grid.cell(align: right, layout(size => {
        let size = calc.min(measure(width: size.width * 3, header_informations).height, size.width)
        block(
          image(yaml.header.image, height: 100%, width: 100%),
          radius: 50%,
          clip: true,
          height: size,
          width: size,
        )
      }))
    },
  )

  #if "intro" in yaml.header {
    v(15pt, weak: true)
    yaml.header.intro
  }
]

#section("SKILLS", grid(
  columns: 2,
  column-gutter: 15pt,
  ..yaml
    .skills
    .pairs()
    .map(c => (grid.cell(text(c.at(0), weight: "bold"), align: right), c.at(1).join(", ")))
    .flatten(),
))


#section("WORK EXPERIENCE", context {
  let dates_width = calc.min(
    100pt,
    calc.max(..yaml.experience.map(c => (c.date_from, c.date_to)).flatten().map(c => measure(c).width)) + 6pt,
  )

  for (title, company, date_from, date_to, description, ..rest) in yaml.experience {
    let skills = rest.at("skills", default: none)

    block(below: 10pt, grid(
      columns: (dates_width, auto),
      align: right,
      grid.cell([#date_to \ #date_from], inset: (right: 6pt)),
      grid.cell(align: left, stroke: (left: 0.8pt), inset: (left: 6pt))[
        #text(title, weight: "bold") \
        #company
        #block(list(..description), inset: (left: 8pt))
        #set par(leading: 3pt)
        #v(4.5pt, weak: true)
        // #if skills != none {
        //   skills.sorted().map(s => box(s, stroke: 0.6pt + gray, inset: (y: 2.5pt, x: 4pt), radius: 25%)).join(h(2pt))
        // }
      ],
    ))
  }
})

#section("EDUCATION", grid(
  columns: 2,
  column-gutter: 15pt,
  ..for (title, place, date_from, date_to) in yaml.education {
    (
      text(date_from + " - " + date_to, weight: "bold"),
      [#text(title, weight: "bold") \ #place],
    )
  }
))

#section("LANGUAGES", grid(
  columns: 2,
  column-gutter: 15pt,
  ..yaml.languages.pairs().map(c => (text(c.at(0), weight: "bold"), c.at(1))).flatten()
))
