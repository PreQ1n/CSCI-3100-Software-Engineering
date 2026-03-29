import { Application } from "@hotwired/stimulus"

import "slim-select/dist/slimselect.css"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
