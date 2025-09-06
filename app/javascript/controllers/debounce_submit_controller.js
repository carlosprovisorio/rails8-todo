import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 250 } }

  connect() { this.timer = null }
  submit() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.element.requestSubmit()
    }, this.delayValue)
  }
}
