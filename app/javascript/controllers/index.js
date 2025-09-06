import { Application } from "@hotwired/stimulus"
import DebounceSubmitController from "./debounce_submit_controller"


// Controllers
import SortableController from "./sortable_controller"
import DatePickerController from "./date_picker_controller"
import ThemeController from "./theme_controller"

const application = Application.start()
application.register("debounce-submit", DebounceSubmitController)
application.register("sortable", SortableController)
application.register("date-picker", DatePickerController)
application.register("theme", ThemeController)

// For debugging in console
window.Stimulus = application
