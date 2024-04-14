import "../vendor/alpinejs"

let dark

// On page load or when changing themes, best to add inline in `head` to avoid FOUC
if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
  document.documentElement.classList.add('dark')
  dark = true
} else {
  document.documentElement.classList.remove('dark')
  dark = false
}

// set up dark mode toggle
function setDarkMode(on) {
  if (on) {
    localStorage.theme = 'dark'
    document.documentElement.classList.add('dark')
  } else {
    // darkModeToggleInput.checked = false
    localStorage.theme = 'light'
    document.documentElement.classList.remove('dark')
  }
}

Alpine.magic("clipboard", () => subject => {
  navigator.clipboard.writeText(subject)
})

window.setDarkMode = setDarkMode
window.dark= dark
