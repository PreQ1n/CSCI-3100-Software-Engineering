import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect(){
    console.log("Search controller 已成功連接！")
  }

  search() {
    console.log('Test!')
    clearTimeout(this.timeout)

    // Set a new timer to submit after 300ms of no typing
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}