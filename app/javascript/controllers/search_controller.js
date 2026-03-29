import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    // Clear the previous timer
    clearTimeout(this.timeout)

    // Set a new timer to submit after 300ms of no typing
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}