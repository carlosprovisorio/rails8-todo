// Boot Turbo
import "@hotwired/turbo-rails"

// Start ActiveStorage (for direct_uploads)
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

// Stimulus controllers (explicit registration)
import "./controllers"

// Bootstrap JS (includes Collapse for hamburger)
import "bootstrap"

// Nothing else to export; defer script is set in the layout.
export {}
