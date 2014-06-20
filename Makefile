SCRIPTS_DIR = Scripts
SCRIPT_CHECK_BUILD_SETTINGS = $(SCRIPTS_DIR)/check_no_xcode_build_settings.sh

proj:
	@echo "\n\033[04m+ checking project settings\033[0m"
	@mdfind -onlyin . trams -name .xcodeproj | xargs $(SCRIPT_CHECK_BUILD_SETTINGS)

update:
	@echo "\n\033[04m+ updating git submodules\033[0m"
	xcrun git submodule sync
	xcrun git submodule update --init --recursive
	