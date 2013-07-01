module EntriesHelper

  def read_unread_link(entry, options = {})
    user_state = entry.userstate(current_user)
    options[:active] = true if user_state.seen
    state_word = user_state.seen ?  '☑' : '☐'  # '☑' : '☐' | '✔' '✓' : '✅'
    classes = ([:action] << options.slice(:disabled, :active).keys).join ' '
    link_to(
      state_word,
      user_state_path(entry.id, user_state: {seen: !user_state.seen}),
      method: :put,
      class: classes)
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
      class: classes)
  end

end
