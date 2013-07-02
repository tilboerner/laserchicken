module ApplicationHelper

  def establish_context
    @parent = get_parent_or_nil
    @model = get_model_or_nil
    @filters = get_filters
    @page = params[:page] && params[:page].to_i || 1
    @navpath = [['Home', polymorphic_path(:root, @filters)]]

    if @parent
      @title = @parent.title
      @navpath << [@parent.class.name.pluralize.capitalize, polymorphic_path(@parent.class, @filters)]
      @navpath << [@title, polymorphic_path(@parent, @filters)]
    else
      classname = params[:controller].classify
      @title = classname.pluralize
      begin
        @navpath << [@title, polymorphic_path(params[:controller], @filters)]
      rescue
      end
    end
    if @model
      instance_variable_set('@' + @model.class.name.downcase, @model)
      @navpath << [@model.title, polymorphic_path(@model, @filters)]
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
    link_to ">>", polymorphic_path([:next, @parent, @model], @filters), rel: 'prev', class: :action
  end

  def link_to_previous
    link_to "<<", polymorphic_path([:previous, @parent, @model], @filters), rel: 'prev', class: :action
  end


private

  def get_filters
    params.except(:action, :controller, :page).reject { |k| k =~ /id$/ }
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
