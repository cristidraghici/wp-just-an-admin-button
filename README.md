# wp-just-an-admin-button

> Replaces the administration toolbar with a button leading to the administration section

## Installation

Note: Installing from github.com, **could result in an error** when trying to activate the plugin. This happens because the plugin is designed to be installed from WP plugin repository and not by downloading it from github. 

The fix: just go to plugins in the admin dashboard and activate/update the plugin.

## Docker development

For developing, you can use `docker-compose`:

1. `docker-compose up`;
2. Access the site at: `http://localhost:8080`;
3. Install the wordpress instance which will be available for you from that point on.

Only basic stuff was necessary for the WP installation.

## Git Hooks

This project uses git hooks to enforce semantic versioning for tags (e.g., `v1.2.3`). To enable these hooks locally, run:

```bash
git config core.hooksPath .githooks
```
