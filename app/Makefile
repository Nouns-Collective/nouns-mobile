install: install_xcodegen open_project install_text_macros

install_xcodegen:
	swift run xcodegen --use-cache

install_text_macros:
	cp IDETemplateMacros.plist Nouns.xcodeproj/xcshareddata/

open_project:
	open Nouns.xcodeproj