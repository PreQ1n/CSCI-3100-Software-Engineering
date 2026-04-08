import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("Search controller connected!")
  }
  
  search() {
    console.log('Test!')
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 200)
  }
}