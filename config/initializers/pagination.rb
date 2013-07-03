WillPaginate::ViewHelpers.pagination_options.merge!({
  :class => 'pagination',
  :previous_label =>  nil,
  :next_label => nil,
  :inner_window => 1, # links around the current page
  :outer_window => 1, # links around beginning and end
  :link_separator => ' ', # single space is friendly to spiders and non-graphic browsers
  :param_name => :page,
  :params => nil,
  :page_links => true,
  :container => true
})
