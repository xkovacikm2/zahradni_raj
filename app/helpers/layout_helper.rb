module LayoutHelper
  def current_url_or_sub_url?(url, exact_match = false)
    return false if url == '#'

    uri, current_uri = [url, current_url].map do |url|
      URI.parse(url)
    end

    return false if uri.is_a?(URI::MailTo) || (!uri.host.nil? && uri.host != current_uri.host)

    normalized_path, normalized_current_path = [uri, current_uri].map do |uri|
      uri.path.sub(%r(/\z), '')
    end

    if normalized_path.empty?
      normalized_current_path.empty?
    else
      regular_expression = exact_match ? %r(\A#{Regexp.escape(normalized_path)}\z) : %r(\A#{Regexp.escape(normalized_path)}(/.+)?\z)
      normalized_current_path =~ regular_expression
    end
  end

  def current_url
    request.original_url
  end

  def navbar_item(name = nil, path = nil, icon = nil, arrow = nil, c_class = nil)
    path ||= '#'
    item_class = current_url_or_sub_url?(path) ? 'active' : ''
    item_class += " #{c_class}" unless c_class.nil?
    arrow = '<span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>'.html_safe unless arrow.nil?

    "<li class=\"#{item_class}\">#{icon_link_to icon, "<span>#{name}</span>#{arrow.to_s}", path, fixed: true}</li>".html_safe
  end
end