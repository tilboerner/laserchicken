module EntriesHelper

  def read_unread_link(entry)
    user_state = entry.userstate(current_user)
    state_word = user_state.seen ? '☑' : '☐'
    link_to(
      state_word,
      user_state_path(entry.id, user_state: {seen: !user_state.seen}),
      method: :put)
  end

end
