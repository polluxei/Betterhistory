VERSION=$(shell grep -E '"version":.*?[^\\]",' package.json | sed 's/[^0-9\.]//g')

build:
	rm -fr build
	mkdir -p build
	coffee -c --map extension/scripts/
	cp -r extension/* build
	cake concat:templates
	cp node_modules/chrome-bootstrap/chrome-bootstrap.css build/styles/
	cake build:assets:dev
	sed -i '' 's/\$$VERSION\$$/${VERSION}/g' build/manifest.json

release: build
	cake build:assets:prod
	./node_modules/uglify-js/bin/uglifyjs build/scripts.js -o build/scripts.js
	rm -f extension.zip

	# Do not exclude the scripts/ directory because some scripts
	# are sourced on the background page in the manifest
	zip -r extension.zip build -x '*.coffee' '*.map' '*styles/*' '*templates/*'

	# reset the build directory to dev state
	make build

.PHONY: build package
