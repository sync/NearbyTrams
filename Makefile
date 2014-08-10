SCRIPTS_DIR = Scripts
SCRIPT_CHECK_BUILD_SETTINGS = $(SCRIPTS_DIR)/check_no_xcode_build_settings.sh

default: proj test

proj:
	@echo "\n\033[04m+ checking project settings\033[0m"
	@mdfind -onlyin . trams -name .xcodeproj | xargs $(SCRIPT_CHECK_BUILD_SETTINGS)

update:
	@echo "\n\033[04m+ updating git submodules\033[0m"
	xcrun git submodule sync
	xcrun git submodule update --init --recursive

clean:
	@echo "\n\033[04m+ clean\033[0m"
	rm -rf ~/Library/Developer/Xcode/DerivedData/NearbyTrams*/Build
	
test: test-network-kit test-storage-kit test-trams-kit

test-storage-kit: 
	xcodebuild -scheme NearbyTramsStorageKit -project NearbyTramsStorageKit.xcodeproj build test | xcpretty

test-network-kit: 
	xcodebuild -scheme NearbyTramsNetworkKit -project NearbyTramsNetworkKit.xcodeproj build test | xcpretty

test-trams-kit: 
	xcodebuild -scheme NearbyTramsKit -project NearbyTramsKit.xcodeproj build test | xcpretty
