import { application } from "../config/stimulus"
import controllers from "./**/*_controller.js"

controllers.forEach(controller => {
  application.register(controller.name, controller.module.default)
})
