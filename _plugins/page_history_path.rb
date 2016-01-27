module Jekyll
  module PageHistoryPath
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
    def page_history_path(path)
      m = /docs.the-startup-stack.com\/(.*)/.match(path)
      "https://github.com/the-startup-stack/docs/commits/master/#{m[1]}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::PageHistoryPath)
