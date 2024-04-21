let Hooks = {}

Hooks.Copy = {
  mounted() {
    let { to } = this.el.dataset;
    this.el.addEventListener("click", (ev) => {
      ev.preventDefault()
      let text = document.querySelector(to).value
      navigator.clipboard.writeText(text).then().catch()
    })
  },
}

export default Hooks
