class EntriesController < ApplicationController
  include EntriesHelper

  before_filter { entries_context }

  def index
  end

  def show
  end

  def next
    next_entry = @entries.select('entries.id').where('entries.published < ?', @entry.published).order('published DESC').limit(1).first
    redirect_to polymorphic_path([@parent, next_entry], @filters)
  end

  def previous
    next_entry = @entries.select('entries.id').where('entries.published > ?', @entry.published).order('published ASC').limit(1).first
    redirect_to polymorphic_path([@parent, next_entry], @filters)
  end

end
