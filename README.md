# Standalone Migrations

Exposes the `standalone_migrations` gem via an Alpine based Docker image

# Usage

The image sets the entrypoint as "rake" so you can run commands from there (assumes a running instance of postgres at `db:5432`):

```sh
docker run \
  --rm \
  -e "DATABASE_URL=postgresql://postgres@db:5432/foo?pool=5" \
  technekes/standalone-migrations -T
```

**Bonus**: To simplify things you can add a simple service to your `docker-compose.yml`

```sh
version: '3.3'

services:
  rake:
    image: technekes:standalone-migrations
    volumes:
      - .:/usr/src/app
    links:
      - db
    environment:
      - DATABASE_URL: postgresql://postgres@db:5432/foo?pool=5
```

Now simply reference the service:

```sh
> docker-compose run --rm rake -T
Starting migrations_db_1 ... done
rake about                           # List versions of all Rails frameworks and the environment
rake app:template                    # Applies the template supplied by LOCATION=(/path/to/template) ...
rake app:update                      # Update configs and some other initially generated files (or us...
rake db:create                       # Creates the database from DATABASE_URL or config/database.yml ...
...
```
