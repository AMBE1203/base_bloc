ifeq ($(OS),Windows_NT)
    BUILD_CMD=.\build_and_run_app.bat
else
    BUILD_CMD=./build_and_run_app.sh
endif

# Define the Dart script
DART_SCRIPT = tools/generate_bloc_files.dart

# Define the template directory
TEMPLATE_DIR = tools/templates

# Check if the template files exist
check_templates:
	@if [ ! -f $(TEMPLATE_DIR)/template_bloc.txt ]; then echo "template_bloc.txt not found!"; exit 1; fi
	@if [ ! -f $(TEMPLATE_DIR)/template_state.txt ]; then echo "template_state.txt not found!"; exit 1; fi
	@if [ ! -f $(TEMPLATE_DIR)/template_event.txt ]; then echo "template_event.txt not found!"; exit 1; fi
	@if [ ! -f $(TEMPLATE_DIR)/template_router.txt ]; then echo "template_router.txt not found!"; exit 1; fi
	@if [ ! -f $(TEMPLATE_DIR)/template_page.txt ]; then echo "template_page.txt not found!"; exit 1; fi
	@if [ ! -f $(TEMPLATE_DIR)/index.txt ]; then echo "index.txt not found!"; exit 1; fi

# Define a rule to run the Dart script
generate_bloc:
	@dart $(DART_SCRIPT) $(SCREEN_NAME)

# Define a rule to prompt for the screen name and run the Dart script
prompt_and_generate: check_templates
	@read -p "Enter ScreenName: " screenName; \
	$(MAKE) generate_bloc SCREEN_NAME=$$screenName

# Define a default target
.PHONY: default
gen_bloc: prompt_and_generate

test:
	flutter test

upgrade:
	flutter pub upgrade

clean:
	flutter clean

get:
	flutter pub get

gen_env:
	dart run tools/gen_env.dart


gen:
	dart pub global activate flutter_gen
	dart pub global run flutter_gen:flutter_gen_command -c pubspec.yaml
	dart run build_runner build --delete-conflicting-outputs


run_dev:
	cd tools && $(BUILD_CMD) dev run


run_stg:
	cd tools && $(BUILD_CMD) stg run

run_prod:
	cd tools && $(BUILD_CMD) prod run

build_dev_apk:
	cd tools && $(BUILD_CMD) dev build apk

build_stg_apk:
	cd tools && $(BUILD_CMD) stg build apk

build_prod_apk:
	cd tools && $(BUILD_CMD) prod build apk

build_dev_bundle:
	cd tools && $(BUILD_CMD) dev build appbundle

build_stg_bundle:
	cd tools && $(BUILD_CMD) stg build appbundle

build_prod_bundle:
	cd tools && $(BUILD_CMD) prod build appbundle

build_dev_ios:
	cd tools && $(BUILD_CMD) dev build ios


build_stg_ios:
	cd tools && $(BUILD_CMD) stg build ios

build_prod_ios:
	cd tools && $(BUILD_CMD) prod build ios

build_dev_ipa:
	cd tools && $(BUILD_CMD) dev build ipa --export-options-plist=ios/exportOptions/devOptions.plist

build_stg_ipa:
	cd tools && $(BUILD_CMD) stg build ipa --export-options-plist=ios/exportOptions/stgOptions.plist

build_prod_ipa:
	cd tools && $(BUILD_CMD) prod build ipa --export-options-plist=ios/exportOptions/prodOptions.plist

build_clean_ios:
	rm -rf build/ios
	cd tools && $(BUILD_CMD) prod build ipa --export-options-plist=ios/exportOptions/prodOptions.plist
build_clean_android:
	rm -rf build/android
	cd tools && $(BUILD_CMD) prod build apk

dart_fix:
	dart fix --apply
