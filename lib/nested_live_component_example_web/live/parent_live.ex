# adapted from this link: https://fullstackphoenix.com/tutorials/typeahead-with-liveview-and-tailwind

defmodule NestedLiveComponentExampleWeb.ParentLive do
  use NestedLiveComponentExampleWeb, :live_view

  alias NestedLiveComponentExampleWeb.AlphaComponent

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        parent_var1: ""
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="parent-view" class="w-400 bg-slate-100 p-4">
      <div class="text-xl font-bold pb-4">Parent Live View</div>
      <div class="text-blue-400">parent_var1: <%= @parent_var1 %></div>
      <div class="py-2">
        <.button phx-click="update-parent-view" phx-value-uval="updated value (from self)">
          Update Live View
        </.button>
      </div>
      <.live_component id="clc" module={AlphaComponent} />
    </div>
    """
  end

  def handle_event("update-parent-view", %{"uval" => uval}, socket) do
    {:noreply,
     assign(socket,
       parent_var1: uval
     )}
  end
end
