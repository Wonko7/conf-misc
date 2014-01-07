# Section "ServerLayout"
# 	Identifier     "X.org Configured"
# 	Screen      0  "Screen0" 0 0
# 	InputDevice    "Mouse0" "CorePointer"
# 	InputDevice    "Keyboard0" "CoreKeyboard"
# EndSection

Section "Files"
	ModulePath   "/usr/lib64/xorg/modules"
	FontPath     "/usr/share/fonts/misc/"
	FontPath     "/usr/share/fonts/TTF/"
	FontPath     "/usr/share/fonts/OTF/"
	FontPath     "/usr/share/fonts/Type1/"
	FontPath     "/usr/share/fonts/100dpi/"
	FontPath     "/usr/share/fonts/75dpi/"
EndSection

Section "Module"
	Load  "record"
	Load  "extmod"
	Load  "dbe"
	Load  "glx"
EndSection

Section "InputDevice"
	Identifier  "Keyboard0"
	Driver      "kbd"
EndSection

# Section "InputDevice"
# 	Identifier  "Mouse0"
# 	Driver      "mouse"
# 	Option	    "Protocol" "auto"
# 	Option	    "Device" "/dev/input/mice"
# 	Option	    "ZAxisMapping" "4 5 6 7"
# #tapping
# 	Option          "FingerHigh"            "30"
# 	Option          "FingerLow"             "20"
# 	Option          "MaxTapTime"            "150"
# 	Option          "FastTaps"              "0"
# 	Option          "TapButton1"            "0"
# 	Option          "TapButton2"            "0"
# 	Option          "TapButton3"            "0"
# EndSection

## arch:
Section "ServerLayout"
	Identifier     "layout"
	InputDevice    "SynapticsTouchpad"  "SendCoreEvents"
	Option      "Xinerama" "on"
EndSection

Section "Module"
	Load "synaptics"
EndSection

Section "InputDevice"
	Identifier "SynapticsTouchpad"
	Driver     "synaptics"
	Option     "AlwaysCore" "true"
	Option     "Device" "/dev/input/mice"
	Option     "Protocol" "auto-dev"
	Option     "SHMConfig" "true"
	Option     "VertTwoFingerScroll" "true"
	Option     "HorizTwoFingerScroll" "true"
	#Option     "TapButton1" "1"
	Option     "TapButton2" "3"
	Option     "TapButton3" "2"
	Option     "ClickFinger1" "1"
	Option     "ClickFinger2" "3"
	Option     "ClickFinger3" "2"
EndSection

## arch

Section "Monitor"
	Identifier   "Monitor0"
	VendorName   "Monitor Vendor"
	ModelName    "Monitor Model"
EndSection

Section "Device"
	Identifier  "Card0"
	#Driver      "nvidia"
	Driver      "nv"
	BusID       "PCI:4:0:0"
	Option "AddARGBGLXVisuals" "true"
EndSection

Section "Screen"
	Identifier "Screen0"
	Device     "Card0"
	Monitor    "Monitor0"
	SubSection "Display"
		Viewport   0 0
		Depth     1
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     4
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     8
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     15
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     16
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     24
	EndSubSection
EndSection

Section "Extensions"
	Option "Composite" "Enable"
	Option "RENDER" "Enable"
	Option "AllowGLXWithComposite" "true"
EndSection
