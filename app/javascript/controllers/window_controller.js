import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  mouseDown(event) {
    this.dragging = true;
    this.mousePos = [event.screenX, event.screenY]
  }

  mouseUp(event) {
    this.dragging = false;
  }

  mouseMove(event) {
    if (this.dragging) {
      let [oldX, oldY] = this.mousePos;

      let diffX = event.screenX - oldX;
      let diffY = event.screenY - oldY;

      let { x, y } = this.element.getBoundingClientRect();

      x += diffX;
      y += diffY;

      this.element.style.top = `${y}px`;
      this.element.style.left = `${x}px`;

      this.mousePos = [event.screenX, event.screenY]
    }
  }
}
