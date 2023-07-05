const hover_hook = {
  mounted() {
    const somevalue = this.el.getAttribute("data-somevalue");

    const dataTargetComponent = this.el.getAttribute("data-target-component");
    const targetComponent = dataTargetComponent
      ? `#${dataTargetComponent}`
      : this.el;

    this.el.addEventListener("mouseenter", (e) => {
      this.pushEventTo(targetComponent, "mouseenter", {
        somevalue,
      });
    });
    this.el.addEventListener("mouseleave", (e) => {
      this.pushEventTo(targetComponent, "mouseleave", {
        somevalue,
      });
    });
  },
};

let Hooks = {
  Hover: hover_hook,
};

export default Hooks;
