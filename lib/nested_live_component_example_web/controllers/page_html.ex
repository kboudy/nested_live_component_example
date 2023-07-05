defmodule NestedLiveComponentExampleWeb.PageHTML do
  use NestedLiveComponentExampleWeb, :html

  embed_templates "page_html/*"
end
