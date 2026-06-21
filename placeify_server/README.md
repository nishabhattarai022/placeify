# placeify_server

This is the starting point for your Serverpod server.

Then start Postgres and Redis:

    docker compose up --build --detach

Apply migrations and start the Serverpod server (first run or after pulling schema changes):

    dart bin/main.dart --apply-migrations

For later runs when the schema is already up to date:

    dart bin/main.dart

### App database tables

| Table | Purpose |
|-------|---------|
| `user` | Placeify profile linked to auth |
| `vendor` | Vendor shops |
| `product` | Marketplace catalog (vendor uploads) |
| `category` | Product categories |
| `cart` / `cart_item` | Shopping cart |
| `order` / `order_item` | Checkout orders |
| `wishlist_item` | Saved products |
| `review` | Product reviews |
| `ar_session` | AR preview sessions |
| `notification_preference` | User notification settings |
| `customization_request` | Custom furniture requests |

Auth and Serverpod internal tables are created automatically with migrations.

When you are finished, shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis:

    docker compose stop
