module ApplicationHelper
  NAV_ITEMS = [ [ "Visão geral", :root_path, "home" ], [ "Clientes", :customers_path, "users" ], [ "Planos", :plans_path, "layers" ], [ "Assinaturas", :subscriptions_path, "repeat" ], [ "Cobranças", :invoices_path, "receipt" ], [ "Eventos", :audit_events_path, "clock" ], [ "Configurações", :settings_path, "settings" ] ].freeze

  def money(cents) = number_to_currency(cents.to_i / 100.0, unit: "R$ ", separator: ",", delimiter: ".")
  def status_badge(status) = content_tag(:span, status.to_s.humanize, class: "status-badge status-#{status}")

  def nav_icon(name)
    paths = { "home" => "M3 12l9-8 9 8v8a1 1 0 01-1 1h-5v-6H9v6H4a1 1 0 01-1-1v-8z", "users" => "M16 21v-2a4 4 0 00-4-4H6a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8zm13 10v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75", "layers" => "M12 2L2 7l10 5 10-5-10-5zm-10 9l10 5 10-5M2 17l10 5 10-5", "repeat" => "M17 2l4 4-4 4M3 11V9a3 3 0 013-3h15M7 22l-4-4 4-4m14-1v2a3 3 0 01-3 3H3", "receipt" => "M4 2v20l3-2 2 2 3-2 3 2 2-2 3 2V2l-3 2-2-2-3 2-3-2-2 2-3-2zM8 9h8M8 13h8", "clock" => "M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z", "settings" => "M12 15.5a3.5 3.5 0 100-7 3.5 3.5 0 000 7zM19.4 15a1.65 1.65 0 00.33 1.82l.06.06-2 2-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V20h-3v-.09a1.65 1.65 0 00-1-1.51 1.65 1.65 0 00-1.82.33l-.06.06-2-2 .06-.06A1.65 1.65 0 007.4 15a1.65 1.65 0 00-1.51-1H5.8v-3h.09a1.65 1.65 0 001.51-1 1.65 1.65 0 00-.33-1.82L7 8.12l2-2 .06.06a1.65 1.65 0 001.82.33 1.65 1.65 0 001-1.51V4.9h3V5a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06 2 2-.06.06A1.65 1.65 0 0019.4 10c.15.61.69 1 1.31 1h.09v3h-.09c-.62 0-1.16.39-1.31 1z" }
    tag.svg(viewBox: "0 0 24 24", fill: "none", stroke: "currentColor", "stroke-width": 1.8, "aria-hidden": true, class: "icon") { tag.path(d: paths.fetch(name), "stroke-linecap": "round", "stroke-linejoin": "round") }
  end

  def navigation_links
    NAV_ITEMS.map { |label, path_helper, icon| path = public_send(path_helper); link_to(path, class: "nav-link #{current_page?(path) ? 'is-active' : ''}") { safe_join([ nav_icon(icon), tag.span(label) ]) } }.join.html_safe
  end
end
