pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# 補回這一行
pin "slim-select", to: "https://unpkg.com/slim-select@2.8.2/dist/slimselect.es.js"
