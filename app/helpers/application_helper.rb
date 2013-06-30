module ApplicationHelper

  def establish_context
    @navpath = [['Home', root_path]]
    @parent = get_parent_or_nil
    @model = get_model_or_nil
    @page = get_page_or_first

    if @parent
      @title = @parent.title
      @navpath << [@parent.class.name.pluralize.capitalize, url_for(@parent.class)]
      @navpath << [@title, url_for(@parent)]
    else
      @title = 'Entries'
      begin
        @navpath << [@title, url_for(Entry)]
      rescue ActionController::UrlGenerationError
      end
    end
    if @model
      instance_variable_set('@' + @model.class.name.downcase, @model)
      @navpath << [@model.title, url_for(@model)]
    end
  end


  def breadcrumbs()
    crumbs_except_current = @navpath.take(@navpath.size - 1)
    for (name, target) in crumbs_except_current do
      content_for :breadcrumbs do
        content_tag 'li' do
          link_to(name, target) + content_tag('span', '>', class: 'divider')
        end
      end
    end
    # current = @navpath.last
    # content_for :breadcrumbs do
    #   content_tag 'li' do
    #     link_to current[0], current[1], class: 'active'
    #   end
    # end
  end

private

  def get_page_or_first
    Page.find(params[:page] || 1)
  end

  def get_parent_or_nil
    parent_key = params.keys.find { |x| x =~ /_id$/ }
    return unless parent_key
    parentclass = parent_key.slice(0, parent_key.size - 3).classify.constantize
    parentclass.find(params[parent_key])
  rescue ActiveRecord::RecordNotFound
  end

  def get_model_or_nil
    return unless params.include? :id
    classname = params[:controller].classify
    modelclass = classname.constantize
    modelclass.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  end

end
