VERSION=$(shell grep -E '"version":.*?[^\\]",' package.json | sed 's/[^0-9\.]//g')
DEV_ANALYTICS=$(shell grep -E '"dev_analytics":.*?[^\\]",' package.json | sed 's/.*:[^\s][^.*]//g' | sed s/\",//g)
PROD_ANALYTICS=$(shell grep -E '"prod_analytics":.*?[^\\]",' package.json | sed 's/.*:[^\s][^.*]//g' | sed s/\",//g)

build:
	rm -fr build
	mkdir -p build
	coffee -c --map extension/scripts/
	cp -r extension/* build
	cake concat:templates
	cp node_modules/chrome-bootstrap/chrome-bootstrap.css build/styles/
	cp node_modules/backbone/backbone.js build/scripts/frameworks/
	cp node_modules/underscore/underscore.js build/scripts/frameworks/
	cp node_modules/mustache/mustache.js build/scripts/frameworks/
	cp node_modules/moment/moment.js build/scripts/frameworks/
	cake build:assets:dev
	sed -i '' 's/\$$VERSION\$$/${VERSION}/g' build/manifest.json
	sed -i '' 's/\$$ANALYTICS_ID\$$/${DEV_ANALYTICS}/g' build/scripts/frameworks/analytics.js

release: build
	cp extension/scripts/frameworks/analytics.js build/scripts/frameworks/
	sed -i '' 's/\$$ANALYTICS_ID\$$/${PROD_ANALYTICS}/g' build/scripts/frameworks/analytics.js
	cake build:assets:prod
	./node_modules/uglify-js/bin/uglifyjs build/scripts.js -o build/scripts.js
	rm -f extension.zip

	# Do not exclude the scripts/ directory because some scripts
	# are sourced on the background page in the manifest
	zip -r extension.zip build -x '*.coffee' '*.map' '*styles/*' '*templates/*'

	# reset the build directory to dev state
	make build

.PHONY: build package
