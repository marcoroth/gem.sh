import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  change(event) {
    Turbo.visit(event.target.value)
  }
}
