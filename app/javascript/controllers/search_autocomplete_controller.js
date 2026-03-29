import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("focus", () => {
      this.element.dispatchEvent(new Event("input"))
    })
  }
}