module ApplicationHelper

  def markdown(text)
    options = {
      :autolink => true, 
      :space_after_headers => true,
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :hard_wrap => true,
      :strikethrough =>true
    }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    code = "<div class=\"markdown\">" + markdown.render(h(text)) + "</div>"
    code.html_safe
  end

end
