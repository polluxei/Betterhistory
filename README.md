Better History [![Build Status](https://travis-ci.org/roykolak/better-history.png)](https://travis-ci.org/roykolak/better-history)
=================

Chrome is an excellent browser. However browsing your history kinda stinks. Let's make it better friend.

Stack
----------------

* [Coffeescript](http://coffeescript.org/) for javascript
* [Jasmine](http://pivotal.github.com/jasmine/) for specs
* [Mustache](http://mustache.github.com/) for templating
* [Chrome bootstrap](https://github.com/roykolak/chrome-bootstrap) for styles
* [Node.js](https://github.com/joyent/node) for development

Setup
-----------------

Better History uses Node.js for development setup, compiling, and running specs. You'll need to run the command below to install the the dev environment.

    $ npm install

To generate coffeescript, templates, and package files, run the following.

    $ npm start

This will create a `build/` directory containing an installable Better History extension. Install this directory as an extension in Chrome; you will need to enable developer mode on the extension page to install local extensions.

Once installed, make changes to the `extension/` directory and then run `npm start` to update the `build/` directory. When the `build/` directory is installed as an extension, you will see your updates automatically. Be aware that when updating the `extensions/_locales/` directory, you may need to disable and enable the extension or reload it from Chrome's installed extensions page.

To run jasmine specs, use the following command

    $ npm test
