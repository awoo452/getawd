import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { src: String }

  connect() {
    if (this.element.complete && this.element.naturalWidth === 0) {
      this.swap({ target: this.element })
    }
  }

  swap(event) {
    const fallback = this.srcValue
    if (!fallback) return

    const img = event.target
    if (img.dataset.fallbackApplied === "true") return

    img.dataset.fallbackApplied = "true"
    img.src = fallback
  }
}
