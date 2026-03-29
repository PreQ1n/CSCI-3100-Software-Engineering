// app/javascript/controllers/slim_select_controller.js
import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  connect() {
    this.slim = new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: "Select Column", 
        showSearch: false, 
        searchHighlight: true
      }
    })
  }

  disconnect() {
    if (this.slim) {
      this.slim.destroy()
    }
  }
}