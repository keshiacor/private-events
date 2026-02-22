// app/javascript/controllers/toast_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add("fade-out");

      setTimeout(() => {
        this.element.remove();
      }, 300);
    }, 3000); // disappears after 3 seconds
  }
}
