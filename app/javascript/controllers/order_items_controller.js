import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "row"]

  connect() {
    this.index = this.rowTargets.length
  }

  add(event) {
    event.preventDefault()

    const template = this.rowTargets[0].outerHTML
      .replace(/\[0\]/g, `[${this.index}]`)
      .replace(/_0_/g, `_${this.index}_`)
    
    const newRow = document.createElement("tr")
    newRow.innerHTML = template
    this.containerTarget.appendChild(newRow)
    this.index++
  }

  remove(event) {
    event.preventDefault()
    const row = event.target.closest("tr")
    if (row) row.remove()
  }
}
