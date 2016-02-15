module Jekyll
  module Prerequisite

    def prerequisite(prerequisite_string)
      m = /(\/.*$)/.match(prerequisite_string)
      clean = prerequisite_string.gsub(m[1], "")
      "<a href=\"#{m[1]}\">#{clean.strip}</a>"
    end

  end
end

Liquid::Template.register_filter(Jekyll::Prerequisite)
