import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = [
    "result"
  ]

  connect() {
    document.addEventListener("keydown", this.escapeHandler)

    useClickOutside(this, {
      element: this.resultTarget
    })
  }

  open() {
    this.resultTarget.classList.remove("hidden")
  }

  submit() {
    Turbo.cache.exemptPageFromPreview()

    this.element.requestSubmit()
  }

  escapeHandler = (event) => {
    if (event.key === "Escape") {
      this.close()
    }
  }

  close() {
    this.resultTarget.classList.add("hidden")
  }

  clickOutside(event) {
    this.close()
  }

  disconnect() {
    document.removeEventListener("keydown", this.escapeHandler)
  }
}
