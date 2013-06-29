class EntriesController < ApplicationController

  def index
    local_context
  end

  def show
    local_context
  end

  def next
    local_context
    next_entry = @entries.select('entries.id').where('entries.published < ?', @entry.published).order('published DESC').limit(1).first
    unless params[:unseen]
      redirect_to [@parent, next_entry]
    else
      redirect_to polymorphic_path([@parent, next_entry], unseen: true)
    end
  end

  def previous
    local_context
    next_entry = @entries.select('entries.id').where('entries.published > ?', @entry.published).order('published ASC').limit(1).first
    unless params[:unseen]
      redirect_to [@parent, next_entry]
    else
      redirect_to polymorphic_path([@parent, next_entry], unseen: true)
    end
  end

private

  def local_context
    @entries = @parent ? @parent.entries : Entry.subscribed_by(current_user)
    if params[:unseen]
      @entries = @entries.unseen_by(current_user)
    end
  end

end
