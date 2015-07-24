# Title: Image tag with caption for Jekyll
# Description: Easily output images with captions

module Jekyll

  class CaptionImageTag < Liquid::Tag
    @img = nil
    @title = nil
    @class = ''
    @width = ''
    @height = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ /(\S.*\s+)?(https?:\/\/|\/)(\S+)(\s+\d+\s+\d+)?(\s+.+)?/i
        @img = $2 + $3
        if $5
          @title = $5.strip
        end
        if $4 =~ /\s*(\d+)\s+(\d+)/
          @width = $1
          @height = $2
        end
      end
      super
    end

    def render(context)
      output = super
      if @img
         "<div class='imgcap'>" +
           "<span class='caption-wrapper'>" +
             "<img src='#{@img}' title='#{@title}' width='#{@width}' >" +
           "</span>" +
         "</div>"
      else
        "Error processing input, expected syntax: {% imgcap /url/to/image [width height] [title text] %}"
      end
    end
  end
end

Liquid::Template.register_tag('imgcap', Jekyll::CaptionImageTag)
