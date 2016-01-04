module Jekyll
  module PagePathFilter
    #
    # Filters the basic path from the file path
    # This is used in order to make sure we can point to the right file on Github
    #
    # path - string representing path eg: /Users/your_user/Code/open_source/the-startup-stack.com/_bootstrapping/install-chef-server.md
    #
    # Examples
    #   github_path("/Users/your_user/Code/open_source/the-startup-stack.com/_bootstrapping/install-chef-server.md")
    #
    # Returns
    #   "_bootstrapping/install-chef-server.md"
    #
    def github_path(path)
      m = /the-startup-stack.com\/(.*)/.match(path)
      new_path = "https://github.com/the-startup-stack/docs/#{m[1]}"
      new_path
    end
  end
end

Liquid::Template.register_filter(Jekyll::PagePathFilter)
