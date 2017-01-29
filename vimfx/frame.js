function toggleFullScreen() {
  if (!content.document.fullscreenElement) {
      content.document.documentElement.requestFullscreen();
  } else {
    if (content.document.exitFullscreen) {
      content.document.exitFullscreen(); 
    }
  }
}

vimfx.listen('toggleFullScreen', () => {
	toggleFullScreen()
	console.log("hi there 2")
})
