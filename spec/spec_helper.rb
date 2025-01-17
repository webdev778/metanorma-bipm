require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "metanorma"
require "metanorma-bipm"
require "metanorma/bipm"
require "asciidoctor/bipm"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "rexml/document"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    Dir.mktmpdir("rspec-") do |dir|
      Dir.chdir(dir) { example.run }
    end
  end
end

def metadata(hash)
  Hash[hash.sort].delete_if { |_, v| v.nil? || v.respond_to?(:empty?) && v.empty? }
end

def strip_guid(html)
  html
    .gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(html)
  HTMLEntities.new.encode(html, :hexadecimal)
    .gsub(/&#x3e;/, ">")
    .gsub(/&#xa;/, "\n")
    .gsub(/&#x22;/, '"')
    .gsub(/&#x3c;/, "<")
    .gsub(/&#x26;/, "&")
    .gsub(/&#x27;/, "'")
    .gsub(/\\u(....)/) { "&#x#{$1.downcase};" }
end

def xmlpp(xml)
  s = ""
  f = REXML::Formatters::Pretty.new(2)
  f.compact = true
  f.write(REXML::Document.new(xml), s)
  s
end

ASCIIDOC_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

VALIDATING_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

HDR

def boilerplate(lang)
  HTMLEntities.new.decode(
    File.read(boilerplate_filepath(lang), encoding: "utf-8")
    .gsub(/\{\{ agency \}\}/, "BIPM")
    .gsub(/\{\{ docyear \}\}/, Date.today.year.to_s)
    .gsub(/\{% if unpublished %\}.*\{% endif %\}/m, "")
    .gsub(/(?<=\p{Alnum})'(?=\p{Alpha})/, "’")
    .gsub(/<p /, "<p id='_' ")
    .gsub(/<p>/, "<p id='_'>")
    .gsub(/<quote /, "<quote id='_' ")
    .gsub(/<quote>/, "<quote id='_'>"),
  ).gsub(/’/, "\&#8217;").gsub(/©/, "&#169;")
end

def boilerplate_filepath(lang)
  file = case lang
         when "jcgm"
           "boilerplate-jcgm-en.xml"
         when "en", "fr"
           "boilerplate-#{lang}.xml"
         end

  File.join(File.dirname(__FILE__), "..", "lib", "asciidoctor", "bipm", file)
end

BLANK_HDR = <<~"HDR".freeze
    <?xml version="1.0" encoding="UTF-8"?>
    <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::BIPM::VERSION}" type="semantic">
    <bibdata type="standard">
      <docidentifier type="BIPM">BIPM </docidentifier>
      <contributor>
        <role type="author"/>
        <organization>
          <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
          <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
        </organization>
      </contributor>
      <contributor>
        <role type="publisher"/>
        <organization>
          <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
          <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
        </organization>
      </contributor>
      <language>en</language>
      <script>Latn</script>
      <status>
        <stage>in-force</stage>
      </status>
      <copyright>
        <from>#{Time.new.year}</from>
        <owner>
          <organization>
            <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
            <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
          </organization>
        </owner>
      </copyright>
      <ext>
        <doctype>brochure</doctype>
      </ext>
    </bibdata>
  #{boilerplate('en')}
HDR

HTML_HDR = <<~"HDR".freeze
  <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
    <div class="title-section">
      <p>&#160;</p>
    </div>
    <br/>
    <div class="prefatory-section">
      <p>&#160;</p>
    </div>
    <br/>
    <div class="main-section">
HDR

def mock_pdf
  allow(::Mn2pdf).to receive(:convert) do |url, output,|
    FileUtils.cp(url.gsub(/"/, ""), output.gsub(/"/, ""))
  end
end
