import { Controller } from "@hotwired/stimulus"

// Controls the data-bs-theme on navbar/body via a cookie for persistence
export default class extends Controller {
  connect() {
    // Ensure body also reflects theme (navbar uses data-bs-theme inline)
    const theme = this.getTheme()
    document.documentElement.setAttribute("data-bs-theme", theme)
  }

  toggle(event) {
    event.preventDefault()
    const next = this.getTheme() === "light" ? "dark" : "light"
    this.setTheme(next)
    // Update <html> and let navbar use its inline ERB on next render
    document.documentElement.setAttribute("data-bs-theme", next)
    // Optional: show a quick Turbo-friendly flash (for now console)
    console.log(`Theme set to ${next}`)
  }

  getTheme() {
    return (document.cookie.match(/(?:^|; )theme=([^;]*)/)?.[1]) || "light"
  }

  setTheme(value) {
    document.cookie = `theme=${value}; path=/; max-age=${60 * 60 * 24 * 365}`
  }
}
