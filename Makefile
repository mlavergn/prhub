###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

###############################################

ifeq ($(shell test -f /Applications/Xcode.app), true)
SDK_PATH := /Applications/Xcode.app/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
else
SDK_PATH := $(shell xcrun --sdk macosx --show-sdk-path)
endif

SDK_TRIPLE := arm64-apple-macosx

env:
	@echo ${SDK_PATH}
	@echo ${SDK_TRIPLE}

open:
	open Package.swift

st:
	open -a SourceTree .

clean:
	swift package clean
	swift package purge-cache
	swift package reset
	rm -rf .build

list:
	xcodebuild -list

build:
	swift build -v -c release --sdk ${SDK_PATH} --triple ${SDK_TRIPLE}

run:
	swift run -v -c release --sdk ${SDK_PATH} --triple ${SDK_TRIPLE} 

install: build
	cp .build/release/prhub /usr/local/bin

archive:
	swift package archive-source
