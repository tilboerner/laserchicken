class EntriesController < ApplicationController
  include EntriesHelper

  before_filter { entries_context }

  def index
  end

  def show
  end

  def next
    next_entry = @entries.select('entries.id').where('entries.published < ?', @entry.published).order('published DESC').limit(1).first
    unless params[:unseen]
      redirect_to [@parent, next_entry]
    else
      redirect_to polymorphic_path([@parent, next_entry], unseen: true)
    end
  end

  def previous
    next_entry = @entries.select('entries.id').where('entries.published > ?', @entry.published).order('published ASC').limit(1).first
    unless params[:unseen]
      redirect_to [@parent, next_entry]
    else
      redirect_to polymorphic_path([@parent, next_entry], unseen: true)
    end
  end

end
