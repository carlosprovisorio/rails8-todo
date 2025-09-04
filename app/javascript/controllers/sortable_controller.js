import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// data-controller="sortable" data-sortable-url-value="/lists/reorder"
export default class extends Controller {
  static values = { url: String }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      handle: "[data-drag-handle]",
      draggable: "turbo-frame, .list-group-item", // <-- important for Turbo frames
      onEnd: () => this.reorder()
    })
  }

  reorder() {
    const ids = Array.from(this.element.querySelectorAll("[data-id]")).map(el => el.dataset.id)
    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
      },
      body: JSON.stringify({ ids })
    })
  }

  disconnect() { this.sortable?.destroy() }
}
