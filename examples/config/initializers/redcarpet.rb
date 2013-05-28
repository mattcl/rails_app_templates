class FoundationRenderer < Redcarpet::Render::HTML
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def block_code(code, language)
    content_tag :pre do
      content_tag :code, code, :data => { :language => language }
    end
  end

  def header(text, header_level)
    case header_level
    when 1
      content_tag :h1, text.html_safe
    when 2
      content_tag :h3, text.html_safe, :class => 'subheader'
    when 3
      content_tag :h4, text.html_safe, :class => 'subheader'
    else
      content_tag "h#{header_level}", text.html_safe
    end
  end

  def block_quote(quote)
    content_tag :div, quote.html_safe, :class => 'panel'
  end
end

module ActionView
  module Template::Handlers
    class Markdown
      class_attribute :default_format
      self.default_format = Mime::HTML

      def call(template)
        options = {
          :autolink => true,
          :space_after_headers => true,
          :no_intra_emphasis => true,
          :fenced_code_blocks => true,
          :lax_html_blocks => true,
          :strikethrough => true,
          :superscript => true
        }
        markdown = Redcarpet::Markdown.new(FoundationRenderer, options)
        markdown.render(template.source).html_safe.inspect
      end
    end
  end
end

ActionView::Template.register_template_handler(:md, ActionView::Template::Handlers::Markdown.new)
ActionView::Template.register_template_handler(:mdown, ActionView::Template::Handlers::Markdown.new)
ActionView::Template.register_template_handler(:markdown, ActionView::Template::Handlers::Markdown.new)
