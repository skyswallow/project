module IncomingPagesHelper  

  def sort_td_class_helper(param)
    result = 'class="sortup"' if params[:sort] == param
    result = 'class="sortdown"' if params[:sort] == param + "_reverse"
    return result
  end


  def sort_link_helper(text, param)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
      :url => {:params => params.merge({:sort => key, :page => nil})}
    }
    html_options = {
      :title => "单击排序",
      :href => url_for(:params => params.merge({:sort => key, :page => nil}))
    }
    link_to(text, options, html_options)
  end

  def selected_option(num1, num2)
    num1.to_i == num2.to_i ? "style='font-weight: bold'" :""
  end
end
