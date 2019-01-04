# wp-just-an-admin-button

Replaces the administration toolbar with a button leading to the administration section.

## Docker development

For developing, you can use `docker-compose`:

1. Go to `cd ./docker` asuming you are in the repository's root folder;
2. `docker-compose up`;
3. Access the site at: `http://localhost:8080`;
4. Install the wordpress instance which will be available for you from that point on.

Docker setup is a work in progress, as only basic stuff was necessary for the WP installation. Any contribution is welcome.

## Automation

The deployment process should be automatic. Check out `./docker/build/`.