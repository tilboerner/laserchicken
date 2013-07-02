class EntriesController < ApplicationController
  include EntriesHelper

  before_filter { entries_context }

  def index
  end

  def show
    unless session.delete(:keep_unread) == @entry.id
      @entry.userstate(current_user).update(seen: true)
      session[:keep_unread] = @entry.id
    end
  end

  def next
    next_entry = @entries.select('entries.id')
      .where(
        '(entries.published = :published AND entries.id < :id) OR entries.published < :published',
        {published: @entry.published, id: @entry.id})
      .limit(1)
      .first
    redirect_to polymorphic_path([@parent, next_entry], @filters)
  rescue ArgumentError
    redirect_to root_path(@filters)
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
  rescue ArgumentError
    redirect_to root_path(@filters)
  end

end
