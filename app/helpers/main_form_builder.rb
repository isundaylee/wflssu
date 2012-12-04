class MainFormBuilder < ActionView::Helpers::FormBuilder
  
  def text_field(method, options = {})
    return wrap_field(super(method, options), options)
  end
  
  def text_area(method, options = {})
    return wrap_field(super(method, options), options)
  end
  
  def password_field(method, options = {})
    return wrap_field(super(method, options), options)
  end

  def submit(value = nil, options = {})
    return wrap_field(super(value, options.merge({class: 'btn btn-primary btn-large'})), options)
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    return wrap_field(super(method, collection, value_method, text_method, options, html_options))
  end

  private
  
    def wrap_field(field, options ={})
      html = '<div class="control-group">'
      html << '<div class="controls center">'
      html << field
      html << '</div>'
      html << '</div>'
      html.html_safe
    end
    
    def label_for(method, options = {})
      label(method, options[:label], {class: "control-label"})
    end
  
end

