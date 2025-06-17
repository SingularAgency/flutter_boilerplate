# Build commands
build_prod_ios:
		make clean && flutter build ipa lib/main_production.dart --flavor production --dart-define-from-file api-keys.prod.json --no-tree-shake-icons --export-method=ad-hoc
build_prod:
		make clean && flutter build apk lib/main_production.dart --flavor production --dart-define-from-file api-keys.prod.json --no-tree-shake-icons --release
build_dev:
		make clean && flutter build apk lib/main_development.dart --flavor development --dart-define-from-file api-keys.dev.json --no-tree-shake-icons --release
build_stg:
		make clean && flutter build apk lib/main_staging.dart --flavor staging --dart-define-from-file api-keys.stg.json --no-tree-shake-icons --release

build_qa_android:
		make clean && flutter build apk lib/main_production.dart --flavor production --dart-define-from-file api-keys.stg.json --release --no-tree-shake-icons 

build_qa_ios:
		make clean && flutter build ipa lib/main_production.dart --flavor production --dart-define-from-file api-keys.stg.json --profile --no-tree-shake-icons --export-method=ad-hoc


# Run commands
run_prod:
		make clean && flutter run lib/main_production.dart --flavor production --dart-define-from-file api-keys.prod.json
run_dev:
		make clean && flutter run lib/main_development.dart --flavor development --dart-define-from-file api-keys.dev.json
run_stg:
		make clean && flutter run lib/main_staging.dart --flavor staging --dart-define-from-file api-keys.stg.json --no-tree-shake-icons

# Flutter commands
clean:
		flutter clean && flutter pub get
delete_cache:
		flutter pub cache clean
repair_cache:
		flutter pub cache repair


# Shorebird commands
release_android: 
		make generate_env_prod && shorebird release android --flutter-version=3.27.1 --target ./lib/main_production.dart --verbose -- --dart-define-from-file api-keys.prod.json --flavor production --no-tree-shake-icons
patch_android: 
		make generate_env_prod && shorebird patch android --target ./lib/main_production.dart --release-version 4.5.0+312 -- --dart-define-from-file api-keys.prod.json --flavor production --no-tree-shake-icons

release_ios:
		make generate_env_prod && shorebird release ios --flutter-version=3.27.1 --flavor production --target ./lib/main_production.dart --verbose -- --flavor production --dart-define-from-file api-keys.prod.json --no-tree-shake-icons
patch_ios:
		make generate_env_prod && shorebird patch ios --flavor production --target ./lib/main_production.dart --release-version 4.5.0+312 -- --flavor production --dart-define-from-file api-keys.prod.json --no-tree-shake-icons
preview: 
		shorebird preview --app-id 9b76aa8d-abcb-4ea1-ae7d-638fe933e0a7 --release-version 3.0.6+234

# Distribute app to firebase app distribution
distribute_osmo_android:
		firebase appdistribution:distribute build/app/outputs/flutter-apk/app-production-release.apk --app 1:713873945833:android:4517c2bcb8e121809e2c78  --groups "osmo-team" --release-notes-file "release-notes.txt"
distribute_osmo_ios:
		firebase appdistribution:distribute "build/ios/ipa/Osmo Wallet.ipa" --app 1:713873945833:ios:0ba1b9398815eac69e2c78  --groups "internal-testers,osmo-team,segundo-aniversario-osmo" --release-notes-file "release-notes.txt"


distribute_android:
		firebase appdistribution:distribute build/app/outputs/flutter-apk/app-production-release.apk --app 1:713873945833:android:4517c2bcb8e121809e2c78  --groups "qa" --release-notes-file "release-notes.txt"
distribute_ios:
		firebase appdistribution:distribute "build/ios/ipa/Osmo Wallet.ipa" --app 1:713873945833:ios:0ba1b9398815eac69e2c78  --groups "qa" --release-notes-file "release-notes.txt"

# Generate json serialization
generate:
		dart run build_runner build --delete-conflicting-outputs

# Generate env api keys
generate_env_dev:
		op inject -i env_development.tpl -o api-keys.dev.json
generate_env_stg:
		op inject -i env_staging.tpl -o api-keys.stg.json
generate_env_prod:
		op inject -i env_production.tpl -o api-keys.prod.json



# Build and upload
qa_android:
		make build_qa_android && make distribute_android
qa_ios:
		make build_qa_ios && make distribute_ios

osmo_android:
		make build_prod && make distribute_osmo_android
osmo_ios:
		make build_prod_ios && make distribute_osmo_ios

osmo: 
		make osmo_android && make osmo_ios