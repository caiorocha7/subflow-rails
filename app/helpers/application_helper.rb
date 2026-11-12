module ApplicationHelper
  def money(cents) = number_to_currency(cents.to_i / 100.0, unit: "R$ ", separator: ",", delimiter: ".")
  def status_badge(status) = content_tag(:span, status.to_s.humanize, class: "badge badge-#{status}")
end
