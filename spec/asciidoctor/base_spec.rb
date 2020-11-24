require "spec_helper"

RSpec.describe Asciidoctor::BIPM do
  it "processes a blank document" do
    input = <<~"INPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</bipm-standard>
    OUTPUT

    system "rm -f test.html"
    system "rm -f test.pdf"
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.pdf")).to be true
  end

  it "processes default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee-en: TC
      :committee-fr: CT
      :committee-acronym: TCA
      :committee-number: 1
      :committee-type: A
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-acronym: WGA
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: en
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :title-appendix-en: Main Title (SI)
      :title-appendix-fr: Chef Title (SI)
      :title-part-en: Part
      :title-part-fr: Partie
      :title-subpart-en: Subpart
      :title-subpart-fr: Subpartie
      :partnumber: 2
      :appendix-id: ABC
      :security: Client Confidential
      :comment-period-from: X
      :comment-period-to: Y
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
      :si-aspect: A_e_deltanu
      :meeting-note: Note
      :fullname: Andrew Yacoot
      :affiliation: NPL
      :fullname_2: Ulrich Kuetgens
      :affiliation_2: PTB
      :fullname_3: Enrico Massa
      :affiliation_3: INRIM
      :fullname_4: Ronald Dixson
      :affiliation_4: NIST
      :role_4: WG-N co-chair
      :fullname_5: Harald Bosse
      :affiliation_5: PTB
      :role_5: WG-N co-chair
      :fullname_6: Andrew Yacoot
      :affiliation_6: NPL
      :role_6: WG-N chair
      :supersedes-date: 2018-06-11
      :supersedes-draft: 1.0
      :supersedes-edition: 1.0
      :supersedes-date_2: 2019-06-11
      :supersedes-draft_2: 2.0
      :supersedes-edition_2: 2.0
      :supersedes-date_3: 2019-06-11
      :supersedes-draft_3: 3.0
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <?xml version="1.0" encoding="UTF-8"?>
<bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
<bibdata type="standard">
<title language='en' format='text/plain' type='main'>Main Title</title>
<title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
<title language='en' format='text/plain' type='appendix'>Main Title (SI)</title>
<title language='en' format='text/plain' type='part'>Part</title>
<title language='en' format='text/plain' type='subpart'>Subpart</title>
<title language='fr' format='text/plain' type='main'>Chef Title</title>
<title language='fr' format='text/plain' type='cover'>Chef Title (SI)</title>
<title language='fr' format='text/plain' type='appendix'>Chef Title (SI)</title>
<title language='fr' format='text/plain' type='part'>Partie</title>
<title language='fr' format='text/plain' type='subpart'>Subpartie</title>
  <docidentifier type="BIPM">#{Metanorma::BIPM.configuration.organization_name_short} 1000</docidentifier>
  <docnumber>1000</docnumber>
  <date type='implemented'>
  <on>D</on>
</date>
<date type='obsoleted'>
  <on>C</on>
</date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
    </organization>
  </contributor>
    <contributor>
    <role type='author'/>
    <person>
      <name>
        <completename>Andrew Yacoot</completename>
      </name>
      <affiliation>
        <organization>
          <name>NPL</name>
        </organization>
      </affiliation>
    </person>
  </contributor>
  <contributor>
    <role type='author'/>
    <person>
      <name>
        <completename>Ulrich Kuetgens</completename>
      </name>
      <affiliation>
        <organization>
          <name>PTB</name>
        </organization>
      </affiliation>
    </person>
  </contributor>
  <contributor>
    <role type='author'/>
    <person>
      <name>
        <completename>Enrico Massa</completename>
      </name>
      <affiliation>
        <organization>
          <name>INRIM</name>
        </organization>
      </affiliation>
    </person>
  </contributor>
  <contributor>
     <role type='editor'>WG-N co-chair</role>
    <person>
      <name>
        <completename>Ronald Dixson</completename>
      </name>
      <affiliation>
        <organization>
          <name>NIST</name>
        </organization>
      </affiliation>
    </person>
  </contributor>
  <contributor>
   <role type='editor'>WG-N co-chair</role>
    <person>
      <name>
        <completename>Harald Bosse</completename>
      </name>
      <affiliation>
        <organization>
          <name>PTB</name>
        </organization>
      </affiliation>
    </person>
  </contributor>
  <contributor>
   <role type='editor'>WG-N chair</role>
    <person>
      <name>
        <completename>Andrew Yacoot</completename>
      </name>
      <affiliation>
        <organization>
          <name>NPL</name>
        </organization>
      </affiliation>
    </person>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
    </organization>
  </contributor>
  <edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
  <language>en</language>
  <script>Latn</script>
  <status>
    <stage>working-draft</stage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
        <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
      </organization>
    </owner>
  </copyright>
  <relation type='supersedes'>
  <bibitem>
    <title>--</title>
    <docidentifier>A</docidentifier>
  </bibitem>
</relation>
<relation type='supersededBy'>
  <bibitem>
    <title>--</title>
    <docidentifier>B</docidentifier>
  </bibitem>
</relation>
<relation type='supersedes'>
  <bibitem>
    <date type='published'>2018-06-11</date>
    <edition>1.0</edition>
    <version>
      <draft>1.0</draft>
    </version>
  </bibitem>
</relation>
<relation type='supersedes'>
  <bibitem>
    <date type='published'>2019-06-11</date>
    <edition>2.0</edition>
    <version>
      <draft>2.0</draft>
    </version>
  </bibitem>
</relation>
<relation type='supersedes'>
  <bibitem>
    <date type='circulated'>2019-06-11</date>
    <version>
      <draft>3.0</draft>
    </version>
  </bibitem>
</relation>
<ext>
  <doctype>brochure</doctype>
  <editorialgroup>
  <committee acronym="TCA">
  <variant language='en' script='Latn'>TC</variant>
  <variant language='fr' script='Latn'>CT</variant>
</committee>
    <workgroup acronym="WGA">WG</workgroup>
  </editorialgroup>
  <comment-period>
  <from>X</from>
  <to>Y</to>
</comment-period>
<si-aspect>A_e_deltanu</si-aspect>
<meeting-note>Note</meeting-note>
<structuredidentifier>
  <docnumber>1000</docnumber>
  <part>2</part>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
    #{boilerplate("en").gsub(/2020/, "2001")}
<sections/>
</bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "processes default metadata in French" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee-en: TC
      :committee-fr: CT
      :committee-number: 1
      :committee-type: A
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: fr
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :partnumber: 2.1
      :security: Client Confidential
      :appendix-id: ABC
      :comment-period-from: X
      :comment-period-to: Y
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <?xml version="1.0" encoding="UTF-8"?>
<bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
<bibdata type="standard">
<title language='en' format='text/plain' type='main'>Main Title</title>
<title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
<title language='fr' format='text/plain' type='main'>Chef Title</title>
<title language='fr' format='text/plain' type='cover'>Chef Title (SI)</title>
  <docidentifier type="BIPM">#{Metanorma::BIPM.configuration.organization_name_short} 1000</docidentifier>
  <docnumber>1000</docnumber>
  <date type='implemented'>
  <on>D</on>
</date>
<date type='obsoleted'>
  <on>C</on>
</date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
    </organization>
  </contributor>
  <edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
  <language>fr</language>
  <script>Latn</script>
  <status>
    <stage>working-draft</stage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
        <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
      </organization>
    </owner>
  </copyright>
  <relation type='supersedes'>
  <bibitem>
    <title>--</title>
    <docidentifier>A</docidentifier>
  </bibitem>
</relation>
<relation type='supersededBy'>
  <bibitem>
    <title>--</title>
    <docidentifier>B</docidentifier>
  </bibitem>
</relation>
<ext>
  <doctype>brochure</doctype>
  <editorialgroup>
  <committee>
  <variant language='en' script='Latn'>TC</variant>
  <variant language='fr' script='Latn'>CT</variant>
</committee>
    <workgroup>WG</workgroup>
  </editorialgroup>
  <comment-period>
  <from>X</from>
  <to>Y</to>
</comment-period>
<structuredidentifier>
  <docnumber>1000</docnumber>
  <part>2.1</part>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
    #{boilerplate("fr").gsub(/2020/, "2001")}
<sections/>
</bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end


  it "processes figures" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[id]]
      .Figure 1
      ....
      This is a literal

      Amen
      ....
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
       <sections>
                <figure id="id">
         <name>Figure 1</name>
         <pre id="_">This is a literal

       Amen</pre>
       </figure>
       </sections>
       </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
             <preface><foreword id="_" obligation="informative">
         <title>Foreword</title>
         <p id="_">This is a preamble</p>
       </foreword></preface><sections>
       <clause id='_' obligation='normative'>
         <title>Section 1</title>
       </clause></sections>
       </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "uses pagenumber and nosee xrefs" do
        input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[a]]
      == Section 1
      <<a>>
      <<a,pagenumber%>>
      <<a,nosee%>>
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
         <sections>
           <clause id='a' obligation='normative'>
             <title>Section 1</title>
             <p id='_'>
               <xref target='a'/>
               <xref target='a' pagenumber='true'/>
               <xref target='a' nosee='true'/>
             </p>
           </clause>
         </sections>
       </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Times New Roman;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Times New Roman;]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :no-pdf:
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "SimHei", sans-serif;]m)
  end

  it "uses specified fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :no-pdf:
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end

  it "has unnumbered clauses" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :bipm, header_footer: true)))).to be_equivalent_to <<~"OUTPUT"
    #{ASCIIDOC_BLANK_HDR}

    [%unnumbered]
    == Clause

    [appendix%unnumbered]
    == Appendix
    INPUT
    #{BLANK_HDR}
     <sections>
   <clause id='_' unnumbered='true' obligation='normative'>
     <title>Clause</title>
   </clause>
 </sections>
 <annex id='_' obligation='normative' unnumbered="true">
   <title>Appendix</title>
 </annex>
</bipm-standard>
    OUTPUT
  end

  it "processes the start attribute on ordered lists" do
        expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :bipm, header_footer: true)))).to be_equivalent_to <<~"OUTPUT"
    #{ASCIIDOC_BLANK_HDR}

    [keep-with-next=true,keep-lines-together=true,start=4]
    [loweralpha]
    . First
    . Second
    INPUT
    #{BLANK_HDR}
 <sections>
  <ol keep-with-next='true' keep-lines-together='true' id='_' type='alphabet' start='4'>
    <li>
      <p id='_'>First</p>
    </li>
    <li>
      <p id='_'>Second</p>
    </li>
  </ol>
</sections>
</bipm-standard>
    OUTPUT
  end

  it "processes sections" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :bipm, header_footer: true)))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      #{ASCIIDOC_BLANK_HDR}
      .Foreword

      Text

      [abstract]
      == Abstract

      Text

      == Introduction

      === Introduction Subsection

      == Acknowledgements

      [.preface]
      == Dedication

      == Scope

      Text

      == Normative References

      [heading=Terms and definitions]
      == Photometric units

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.nonterm]
      === Introduction

      ==== Intro 1

      === Intro 2

      [.nonterm]
      ==== Intro 3

      === Intro 4

      ==== Intro 5

      ===== Term1

      === Normal Terms

      ==== Term2

      === Symbols and Abbreviated Terms

      [.nonterm]
      ==== General

      ==== Symbols

      == Abbreviated Terms

      == Clause 4
      === Introduction

      === Clause 4.2

      == Terms and Definitions

      [appendix]
      == Annex

      === Annex A.1

      == Bibliography

      === Bibliography Subsection
    INPUT
    #{BLANK_HDR.sub(%r{</script>}, "</script><abstract><p>Text</p></abstract>")}
  <preface>
    <abstract id='_'>
      <title>Abstract</title>
      <p id='_'>Text</p>
    </abstract>
    <foreword id='_' obligation='informative'>
      <title>Foreword</title>
      <p id='_'>Text</p>
    </foreword>
    <clause id='_' obligation='informative'>
      <title>Dedication</title>
    </clause>
    <acknowledgements id='_' obligation='informative'>
      <title>Acknowledgements</title>
    </acknowledgements>
  </preface>
  <sections>
    <clause id='_' obligation='normative'>
      <title>Introduction</title>
      <clause id='_' obligation='normative'>
        <title>Introduction Subsection</title>
      </clause>
    </clause>
    <clause id='_' type='scope' obligation='normative'>
      <title>Scope</title>
      <p id='_'>Text</p>
    </clause>
    <terms id='_' obligation='normative'>
      <title>Photometric units</title>
      <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
      <term id='_'>
        <preferred>Term1</preferred>
      </term>
    </terms>
    <clause id='_' obligation='normative'>
      <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
      <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
      <clause id='_' obligation='normative'>
        <title>Introduction</title>
        <clause id='_' obligation='normative'>
          <title>Intro 1</title>
        </clause>
      </clause>
      <terms id='_' obligation='normative'>
        <title>Intro 2</title>
        <clause id='_' obligation='normative'>
          <title>Intro 3</title>
        </clause>
      </terms>
      <clause id='_' obligation='normative'>
        <title>Intro 4</title>
        <terms id='_' obligation='normative'>
          <title>Intro 5</title>
          <term id='_'>
            <preferred>Term1</preferred>
          </term>
        </terms>
      </clause>
      <terms id='_' obligation='normative'>
        <title>Normal Terms</title>
        <term id='_'>
          <preferred>Term2</preferred>
        </term>
      </terms>
      <definitions id='_' obligation='normative'>
        <title>Symbols and Abbreviated Terms</title>
        <clause id='_' obligation='normative'>
          <title>General</title>
        </clause>
        <definitions id='_' type='symbols' obligation='normative'>
          <title>Symbols</title>
        </definitions>
      </definitions>
    </clause>
    <definitions id='_' type='abbreviated_terms' obligation='normative'>
      <title>Abbreviated Terms</title>
    </definitions>
    <clause id='_' obligation='normative'>
      <title>Clause 4</title>
      <clause id='_' obligation='normative'>
        <title>Introduction</title>
      </clause>
      <clause id='_' obligation='normative'>
        <title>Clause 4.2</title>
      </clause>
    </clause>
    <clause id='_' obligation='normative'>
      <title>Terms and Definitions</title>
    </clause>
  </sections>
  <annex id='_' obligation='normative'>
    <title>Annex</title>
    <clause id='_' obligation='normative'>
      <title>Annex A.1</title>
    </clause>
  </annex>
  <bibliography>
    <references id='_' normative='true' obligation='informative'>
      <title>Normative references</title>
      <p id='_'>There are no normative references in this document.</p>
    </references>
    <clause id='_' obligation='informative'>
      <title>References</title>
      <references id='_' normative='false' obligation='informative'>
        <title>Bibliography Subsection</title>
      </references>
    </clause>
  </bibliography>
</bipm-standard>
OUTPUT
  end

  it "customises italicisation of MathML" do
input = <<~INPUT
= Document title
Author
:stem:

[stem]
++++
<math xmlns='http://www.w3.org/1998/Math/MathML'>
  <mi>A</mi>
  <mo>+</mo>
  <mi>a</mi>
  <mo>+</mo>
  <mi>Α</mi>
  <mo>+</mo>
  <mi>α</mi>
  <mo>+</mo>
  <mi>AB</mi>
</math>
++++
INPUT

expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to xmlpp(<<~"OUTPUT")
#{BLANK_HDR}
<sections>
           <formula id='_'>
             <stem type='MathML'>
               <math xmlns='http://www.w3.org/1998/Math/MathML'>
                 <mi mathvariant='normal'>A</mi>
                 <mo>+</mo>
                 <mi>a</mi>
                 <mo>+</mo>
                 <mi mathvariant='normal'>Α</mi>
                 <mo>+</mo>
                 <mi mathvariant='normal'>α</mi>
                 <mo>+</mo>
                 <mi>AB</mi>
               </math>
             </stem>
           </formula>
         </sections>
</bipm-standard>
OUTPUT
  end

end

