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

```yaml
version: '3.3'

services:
  rake:
    image: technekes:standalone-migrations
    volumes:
      - ./db:/usr/src/app/db
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

## Multi-database support

The `standalone_migrations` gem supports migrating multiple databases, see:
https://www.rubydoc.info/gems/standalone_migrations/5.2.6#Multiple_database_support

To use this feature, add your `.database_name.standalone_migrations` config files
to this directory: `db/config`  
Configuration there will be copied `ONBUILD` so that the gem can find them at runtime.

## SQLMigrationHelper

This project includes a module that simplifies creating pure SQL migrations rather than the traditional model backed migrations. To take advantage of this feature include the module in a migration file:

```ruby
class CreateFooBars < ActiveRecord::Migration[5.1]
  include SQLMigrationHelper
end
```

Then add a file that matches the name of the migration at `./db/migrate/sql/`:

```sql
/* ./db/migrate/sql/create_foo_bars.sql */

--# :down
DROP TABLE IF EXISTS public.foo_bars;
--#

--# :up
CREATE TABLE public.foo_bars
(
   id            text NOT NULL
  ,key           text NOT NULL
  ,name          text NOT NULL
);
--#
```

Notice the tokens that divide the script into `up` and `down` sections, these are required for the module to function.
