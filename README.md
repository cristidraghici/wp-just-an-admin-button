# wp-just-an-admin-button

Replaces the administration toolbar with a button leading to the administration section.

Current version: ..1.2.1

Note: Installing from github.com, **could result in an error** when trying to activate the plugin. This happens because the plugin is designed to be installed from WP plugin repository and not by downloading it from github. The fix: just go to plugins in the admin dashboard and activate/update the plugin.

## Releasing a new version

Use `./cli.sh release <patch|minor|major>` to automatically create a tag for the repo and add it in the readme.txt and the main plugin file.

Publishing to the Wordpress plugin repository will be done by `./cli.sh publish`.

## .env

- copy `.env.example` to `.env`;
- `WP_ORG_USERNAME` can be manually added `WP_ORG_PASSWORD`, if not stored in the automation system credentials management;

## Docker development

For developing, you can use `docker-compose`:

1. Go to `cd ./docker` asuming you are in the repository's root folder;
2. `docker-compose up`;
3. Access the site at: `http://localhost:8080`;
4. Install the wordpress instance which will be available for you from that point on.

Docker setup is a work in progress, as only basic stuff was necessary for the WP installation. Any contribution is welcome.

## Submodules

Add a new submodule:

- `git submodule add git@github.com:franiglesias/versiontag.git lib/versiontag`

Install and update:

- `git submodule init`
- `git submodule update --merge --remote`
- `git submodule foreach git pull origin master`

## Automation

The deployment process should be automatic. Check out `./docker/build/`.
