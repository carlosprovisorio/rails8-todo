import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["weekly", "monthly"]

  connect() {
    this.element.addEventListener("change", (e) => {
      if (e.target.tagName === "SELECT") this.toggle(e.target.value)
    })
    // Initialize on connect
    const selected = this.element.querySelector("select")?.value || ""
    this.toggle(selected)
  }

  toggle(type) {
    const showWeekly = type === "weekly"
    const showMonthly = type === "monthly"
    this.weeklyTargets.forEach(el => el.hidden = !showWeekly)
    this.monthlyTargets.forEach(el => el.hidden = !showMonthly)
  }
}
