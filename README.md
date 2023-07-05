# NestedLiveComponentExample

notes & examples on the various ways of sending data between a live view & its nested live components

to reduce confusion between the relative terms "parent" and "child" among the nested live components, this example consists of

- A Live View, which contains:
  - A Live Component I'm calling `Alpha`, which contains:
    - A Live Component I'm calling `Beta`

![Alt text](/readme_images/screenshot.png)

## Sending a click event from a live view to itself

- the most basic example: the [phx-click](lib/nested_live_component_example_web/live/parent_live.ex#L23) event is sent to the live view itself
  - which then [handles the event & updates its own state](lib/nested_live_component_example_web/live/parent_live.ex#L32)
- this simplicity is possible because the live view is the default target for itself & the nested components, since they all share the same process id

## Sending a click event to the parent live view

- just as simple as the first example, since the desired destination (parent live view) is still the default target
- Alpha's [phx-click](lib/nested_live_component_example_web/components/alpha_component.ex#L23) event is identical to the first example

## Sending a click event from a live component to itself

- the only difference here is the addition of [phx-target={@myself}](lib/nested_live_component_example_web/components/alpha_component.ex#L31)

## Sending a message from one live component to another

- it starts as the above example, adding [phx-target={@myself}](lib/nested_live_component_example_web/components/alpha_component.ex#L37)
- but the [handle_event](lib/nested_live_component_example_web/components/alpha_component.ex#L53)'s only purpose is to relay the message to the Beta component via [send_update](lib/nested_live_component_example_web/components/alpha_component.ex#L55), where it is [received by Beta](lib/nested_live_component_example_web/components/beta_component.ex#L66)
  - note that `send_update` takes the **component** as the first argument, **live component id** (not its DOM id) as the second,

## Sending a hook event from js to a specific live component

- normally, you'd use [pushEvent](https://hexdocs.pm/phoenix_live_view/js-interop.html) in javascript to send an event to the live view
- since we're targeting a live component, we use `pushEventTo`
  - `pushEventTo` adds a `selectorOrTarget` argument, which allows you to send the event to a specific live component
    - to send it to the **same** live component that set up the hook, you can use `this.el` for the `selectorOrTarget` argument. _(I discovered that it in [this github issue](https://github.com/phoenixframework/phoenix_live_view/issues/1396))_
    - to send it to a **different** live component, use the live component's DOM id _(I use the outermost DOM id, but it can actually be any DOM id within the live component)_
    - as an example of a hook that can handle a dynamic parent: [here](assets/js/hooks/index.js#L6), my hook is looking for the presence of a `data-target-component` attribute on the element. if it doesn't exists, it targets `this.el`
