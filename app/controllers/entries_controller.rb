class EntriesController < ApplicationController
  include EntriesHelper

  before_filter { entries_context }

  def index
  end

  def show
  end

  def next
    next_entry = @entries.select('entries.id')
      .where(
        '(entries.published = :published AND entries.id < :id) OR entries.published < :published',
        {published: @entry.published, id: @entry.id})
      .limit(1)
      .first
    redirect_to polymorphic_path([@parent, next_entry], @filters)
  end

  def previous
    next_entry = @entries.select('entries.id')
      .reverse_order
      .where(
        '(entries.published = :published AND entries.id > :id) OR entries.published > :published',
        {published: @entry.published, id: @entry.id})
      .limit(1)
      .first
    redirect_to polymorphic_path([@parent, next_entry], @filters)
  end

end
