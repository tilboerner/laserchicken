module ApplicationHelper

  def establish_context
    @appname = Rails.application.class.parent_name
    @parent = get_parent_or_nil
    @model = get_model_or_nil
    @filters = get_filters
    @page = params[:page] && params[:page].to_i || 1
    @breadcrumbs = [['Home', app_path(:root)]]

    if @parent
      @title = @parent.title
      @breadcrumbs << [@parent.class.name.pluralize.capitalize, app_path(@parent.class)]
      @breadcrumbs << [@title, app_path(@parent)]
    else
      classname = params[:controller].classify
      @title = classname.pluralize
      begin
        @breadcrumbs << [@title, app_path(params[:controller])]
      rescue
      end
    end
    if @model
      instance_variable_set('@' + @model.class.name.downcase, @model)
      crumb_name = @model.respond_to?(:title) ? @model.title : @model.class.name
      @breadcrumbs << [crumb_name, app_path(@model)]
    end
  end


  def breadcrumbs()
    crumbs_except_current = @breadcrumbs.take(@breadcrumbs.size - 1)
    for (name, target) in crumbs_except_current do
      content_for :breadcrumbs do
        content_tag 'li' do
          link_to(name, target) + content_tag('span', '>', class: 'divider')
        end
      end
    end
    # current = @breadcrumbs.last
    # content_for :breadcrumbs do
    #   content_tag 'li' do
    #     link_to current[0], current[1], class: 'active'
    #   end
    # end
  end

  def app_path(target)
    polymorphic_path(target, @filters)
  end

  def link_to_filter(filter, word)
    classes = [:action]
    if @filters.include? filter or (filter.nil? and @filters.empty?)
      classes << [:active, :disabled]
    end
    newfilters = @filters.except(:unseen, :starred)
    newfilters.merge!({:"#{filter}" => true}) unless filter == nil
    link_to word, newfilters, class: classes
  end

  def link_to_next
    link_to ">>", app_path([:next, @parent, @model]), rel: 'next', class: :action
  end

  def link_to_previous
    link_to "<<", app_path([:previous, @parent, @model]), rel: 'prev', class: :action
  end

  def entry_filter_actions
      content_tag 'div', class: 'action-group' do
        link_to_filter(:unseen, 'new') +
        link_to_filter(nil, 'all') +
        link_to_filter(:starred, 'stars')
      end
  end

  def redirect_303(target)
    redirect_to target, status: :see_other
  end

  def redirect_back_or_rescue(rescuepath = nil)
    redirect_303 :back
  rescue ActionController::RedirectBackError
    redirect_303(rescuepath || app_path(:root))
  end

  def get_model_errors(model = nil)
    model = @model if model.nil?
    model.nil? ? model : model.errors.full_messages.to_sentence
  end

private

  def get_filters
    params.slice(:unseen, :starred)
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
