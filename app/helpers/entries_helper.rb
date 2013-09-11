module EntriesHelper

  def entries_context
    @entries = @parent ? @parent.entries : Entry.subscribed_by(current_user)
    if @filters[:unseen]
      @entries = @entries.unseen_by(current_user)
    end
    if @filters[:starred]
      @entries = @entries.starred_by(current_user)
    end
  end

  def read_unread_link(entry, options = {})
    user_state = entry.userstate(current_user)
    options[:active] = true if user_state.seen
    state_word = user_state.seen ?  '☑' : '☐'  # '☑' : '☐' | '✔' '✓' : '✅'
    classes = ([:action] << options.slice(:disabled, :active).keys).join ' '
    link_to(
      state_word,
      user_state_path(entry.id, user_state: {seen: !user_state.seen}),
      method: :put,
      class: classes,
      data: {:type => 'read_unread'})
  end

  def star_unstar_link(entry, options = {})
    user_state = entry.userstate(current_user)
    options[:active] = true if user_state.starred
    state_word = user_state.starred ?  '★' : '☆' # '★' : '☆'
    classes = ([:action] << options.slice(:disabled, :active).keys).join ' '
    link_to(
      state_word,
      user_state_path(entry.id, user_state: {starred: !user_state.starred}),
      method: :put,
      class: classes,
      data: {:type => 'star_unstar'})
  end

  def mark_all_seen_action(basepath, options={})
    path = [:see_all] + basepath
    text = options[:text] || 'mark all as seen'
    title = 'mark all as seen'
    classes = [:action] + (options[:classes] || [])
    link_to "#{text}", app_path(path), method: :put, class: classes, title: title, data: {:type => 'mark_all_seen'}
  end

  def guess_a_parent_for(entry)
    return @parent if @parent
    if current_user and entry.subscribed_by?(current_user)
      entry.feed.subscriptions.where(user: current_user).first
    else
      return entry.feed
    end
  end

end
