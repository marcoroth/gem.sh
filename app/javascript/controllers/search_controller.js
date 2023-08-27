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
    this.backdropElement.classList.remove("hidden")
    this.element.querySelector("input").focus()
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
    this.backdropElement.classList.add("hidden")
  }

  clickOutside(event) {
    this.close()
  }

  disconnect() {
    document.removeEventListener("keydown", this.escapeHandler)
  }

  get backdropElement() {
    return this.resultTarget.closest("[role=dialog]")
  }
}
