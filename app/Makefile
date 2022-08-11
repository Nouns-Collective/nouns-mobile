install: install_xcodegen open_project install_text_macros
install_ci: install_xcodegen

install_xcodegen:
	swift run xcodegen 

install_text_macros:
	cp IDETemplateMacros.plist Nouns.xcodeproj/xcshareddata/

open_project:
	open Nouns.xcodeproj