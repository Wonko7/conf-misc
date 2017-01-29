
let {commands} = vimfx.modes.normal

vimfx.addCommand({
  name: 'search_tabs',
  description: 'Search tabs',
  category: 'tabs',
  order: commands.focus_location_bar.order + 1,
}, (args) => {
  let {vim} = args
  let {gURLBar} = vim.window
  gURLBar.value = ''
  commands.focus_location_bar.run(args)
  // Change the `*` on the text line to a `%` to search tabs instead of bookmarks.
  gURLBar.value = '% '
  gURLBar.onInput(new vim.window.KeyboardEvent('input'))
})

vimfx.addCommand({
  name: 'zoom_reset',
  description: 'Zoom reset',
}, ({vim}) => {
  vim.window.FullZoom.reset()
})

vimfx.addCommand({
  name: 'zoom_in',
  description: 'Zoom in',
}, ({vim}) => {
  vim.window.FullZoom.enlarge()
})

vimfx.addCommand({
  name: 'zoom_out',
  description: 'Zoom out',
}, ({vim}) => {
  vim.window.FullZoom.reduce()
})

vimfx.addCommand({
  name: 'fullscreen_toggle',
  description: 'Fullscreen toggle',
}, ({vim}) => {
	// the .send *should* be used, but the webextension api doesn't do real fullscreen.
	//vimfx.send(vim, 'toggleFullScreen')
	vim.window.fullScreen = !vim.window.fullScreen
})



let prefs = {
  "hints.chars": "hutenosagpyf mk",
  "mode.normal.history_back": ",",
  "mode.normal.history_forward": ".",
  "mode.normal.stop": "c",
  "mode.normal.scroll_left": "<",
  "mode.normal.scroll_right": ">",
  "mode.normal.scroll_half_page_down": "",
  "mode.normal.scroll_half_page_up": "",
  "mode.normal.tab_select_previous": "h",
  "mode.normal.tab_select_next": "l",
  "mode.normal.tab_select_most_recent": "<c-space>",
  "mode.normal.tab_close": "d",
  "mode.normal.tab_restore": "u",
  "mode.normal.follow_copy": ";y",
  "custom.mode.normal.zoom_in": "zi",
  "custom.mode.normal.zoom_out": "zo",
  "custom.mode.normal.zoom_reset": "zz",
  "custom.mode.normal.search_tabs": "b",
  "custom.mode.normal.fullscreen_toggle": "<backspace>"
}

Object.entries(prefs).forEach(([pref, value]) => vimfx.set(pref, value))

// for safekeeping, vimium's:
//
// # Insert your preferred key mappings here.
// unmapAll
// map h previousTab
// map l nextTab
// map b Vomnibar.activateTabSelection
// map u restoreTab
// map d removeTab
// map , goBack
// map . goForward
//
// map j scrollDown
// map k scrollUp
// map gg scrollToTop
// map G scrollToBottom
// map r reload
// map p openCopiedUrlInCurrentTab
// map P openCopiedUrlInNewTab
// map yy copyCurrentUrl
// map i enterInsertMode
// map v enterVisualMode
// map gi focusInput
// map f LinkHints.activateMode
// map F LinkHints.activateModeToOpenInNewTab
//
// map o Vomnibar.activate
// map O Vomnibar.activateInNewTab
// map t createTab
//
// map <c-space> visitPreviousTab
// map g^ firstTab
// map g$ lastTab
