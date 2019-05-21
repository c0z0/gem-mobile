apk:
	flutter build apk

deploy-apk:
	cp build/app/outputs/apk/release/app-release.apk build/app/outputs/apk/release/gem.apk 
	cp now.json build/app/outputs/apk/release/
	now build/app/outputs/apk/release --target production

release-apk: apk deploy-apk