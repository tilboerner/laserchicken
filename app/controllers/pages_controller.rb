class PagesController < ApplicationController
  include EntriesHelper

  def show
    if @parent
      render template: polymorphic_path(@parent)
    else
      entries_context
      render template: 'entries/index'
    end
  end

  def next
    redirect_to [@parent, @model, @page.next]
  end

  def previous
    redirect_to [@parent, @model, @page.previous]
  end

end
