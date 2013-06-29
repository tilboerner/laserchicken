module ApplicationHelper

  def establish_context
    @navpath = [['Home', root_path]]
    @parent = get_parent_or_nil
    @model = get_model_or_nil

    if @parent
      @title = @parent.title
      @navpath << [@parent.class.name.pluralize.capitalize, url_for(@parent.class)]
      @navpath << [@title, url_for(@parent)]
    else
      classname = params[:controller].classify
      @title = classname.pluralize
      begin
        @navpath << [@title, url_for(controller: params[:controller])]
      rescue ActionController::UrlGenerationError
      end
    end
    if @model
      instance_variable_set('@' + @model.class.name.downcase, @model)
      @navpath << [@model.title, url_for(@model)]
    end
  end


private

  def get_parent_or_nil
    parent_key = params.keys.find { |x| x =~ /_id$/ }
    @parent_key = parent_key
    return unless parent_key
    parentclass = parent_key.slice(0, parent_key.size - 3).classify.constantize
    parentclass.find(params[parent_key])
  end

  def get_model_or_nil
    return unless params.include? :id
    classname = params[:controller].classify
    modelclass = classname.constantize
    modelclass.find(params[:id])
  end

end
