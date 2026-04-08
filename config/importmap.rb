# pin "application" 預設會找 app/javascript/application.js
pin "application"

# 確保這三行正確指向 Rails 內建的 JS
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# 關鍵：自動關聯 controllers 資料夾
pin_all_from "app/javascript/controllers", under: "controllers"