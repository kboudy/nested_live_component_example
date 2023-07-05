defmodule NestedLiveComponentExampleWeb.AlphaComponent do
  use NestedLiveComponentExampleWeb, :live_component

  alias NestedLiveComponentExampleWeb.BetaComponent

  def mount(socket) do
    socket = assign(socket, alpha_var1: "", msg: "")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="alpha-component" class="p-4 m-2 bg-slate-300">
      <div class="text-xl font-bold pb-4">"Alpha" Live Component</div>
      <div class="text-blue-600">
        alpha_var1: <%= @alpha_var1 %>
      </div>
      <div :if={@msg != ""} class="text-green-600 font-bold">
        msg (from Alpha): <%= @msg %>
      </div>
      <div class="py-2">
        <.button phx-click="update-parent-view" phx-value-uval="updated value (from Alpha component)">
          Update Parent Live View
        </.button>
      </div>
      <div class="py-2">
        <.button
          phx-click="update-alpha-component"
          phx-value-uval="updated value"
          phx-target={@myself}
        >
          Update Alpha Component (@myself)
        </.button>
      </div>
      <div class="py-2">
        <.button phx-click="send-message-down" phx-value-msg="hey son!" phx-target={@myself}>
          Send message down to Beta component
        </.button>
      </div>
      <.live_component id="glc" module={BetaComponent} />
    </div>
    """
  end

  def handle_event("update-alpha-component", %{"uval" => uval}, socket) do
    {:noreply,
     assign(socket,
       alpha_var1: uval
     )}
  end

  def handle_event("send-message-down", %{"msg" => msg}, socket) do
    # note that this "id" below is not the dom id, but the live_component id assigned above
    send_update(BetaComponent, id: "glc", action: {:msg, msg})
    {:noreply, socket}
  end

  def handle_event("mouseenter", %{"somevalue" => somevalue}, socket) do
    IO.puts("[IO.puts from Alpha component] mouseenter: #{somevalue}")

    {
      :noreply,
      socket
    }
  end

  def handle_event("mouseleave", %{"somevalue" => somevalue}, socket) do
    IO.puts("[IO.puts from Alpha component] mouseleave: #{somevalue}")

    {
      :noreply,
      socket
    }
  end
end
