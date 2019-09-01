
apk:
	flutter build apk --build-number=$(shell git rev-list --count HEAD)

deploy-apk:
	echo '{ "latestVersion": $(shell git rev-list --count HEAD) }' > build/app/outputs/apk/release/info.json
	mv build/app/outputs/apk/release/app-release.apk build/app/outputs/apk/release/gem.apk 
	cp now.json build/app/outputs/apk/release/
	now build/app/outputs/apk/release --target production

release-apk: apk deploy-apk
