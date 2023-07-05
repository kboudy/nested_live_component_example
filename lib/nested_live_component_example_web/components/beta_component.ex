defmodule NestedLiveComponentExampleWeb.BetaComponent do
  use NestedLiveComponentExampleWeb, :live_component

  def mount(socket) do
    socket = assign(socket, msg: "")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="beta-component" class="p-4 m-2 bg-slate-400">
      <div class="text-xl font-bold pb-4">"Beta" Live Component</div>

      <div
        id="hover-detection"
        phx-hook="Hover"
        data-somevalue="I'm some value on the hovered dom element"
        data-target-component="alpha-component"
        class="bg-indigo-400 cursor-pointer my-2"
      >
        Hover me to see message, emitted from the "Alpha" (parent of this) live component, in your console (JS hook example)
      </div>
      <div
        id="hover-detection"
        phx-hook="Hover"
        data-somevalue="I'm some value on the hovered dom element"
        class="bg-pink-400 cursor-pointer my-2"
      >
        Hover me to see message, emitted from this "Beta" component, in your console (JS hook example)
      </div>

      <div :if={@msg != ""} class="text-yellow-300 font-bold">
        msg (from Alpha): <%= @msg %>
      </div>
    </div>
    """
  end

  def handle_event("update-beta-component", %{"uval" => uval}, socket) do
    {:noreply,
     assign(socket,
       beta_var1: uval
     )}
  end

  def handle_event("mouseenter", %{"somevalue" => somevalue}, socket) do
    IO.puts("[IO.puts from Beta component] mouseenter: #{somevalue}")

    {
      :noreply,
      socket
    }
  end

  def handle_event("mouseleave", %{"somevalue" => somevalue}, socket) do
    IO.puts("[IO.puts from Beta component] mouseleave: #{somevalue}")

    {
      :noreply,
      socket
    }
  end

  def update(%{action: {:msg, msg}}, socket) do
    {:ok, assign(socket, msg: msg)}
  end

  # because we implemented the update function for receiving "action" above, we need to implement the generic update function below
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
