require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"
require_relative "base_convert"

module IsoDoc
  module BIPM
    class HtmlConvert < IsoDoc::Generic::HtmlConvert
      def middle(isoxml, out)
        super
        doccontrol isoxml, out
      end

      def doccontrol(isoxml, out)
        c = isoxml.at(ns("//doccontrol")) or return
        out.div **attr_code(class: "doccontrol") do |div|
          clause_parse_title(c, div, c.at(ns("./title")), out)
          c.children.reject { |c1| c1.name == "title" }.each do |c1|
            parse(c1, div)
          end
        end
      end

      def counter_reset(node)
        s = node["start"]
        return nil unless s && !s.empty? && !s.to_i.zero?

        "counter-reset: #{node['type']} #{s.to_i - 1};"
      end

      def ol_attrs(node)
        klass, style = if node["type"] == "roman" &&
            !node.at("./ancestor::xmlns:ol[@type = 'roman']") ||
            node["type"] == "alphabet" &&
                !node.at("./ancestor::xmlns:ol[@type = 'alphabet']")
                         [node["type"], counter_reset(node)]
                       end
        super.merge(attr_code(type: ol_style((node["type"] || "arabic").to_sym),
                              start: node["start"]), style: style, class: klass)
      end

      include BaseConvert
      include Init
    end
  end
end
