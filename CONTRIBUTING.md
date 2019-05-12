## Contributing

### Updating dev-setup.sh

If you update [bootstrap.sh](bootstrap.sh) you will need to update the links in the [README.md](README.md) and [CONTRIBUTING.md](CONTRIBUTING.md) (for the convenience of the next person).

To update the links:
1. Commit the changes to `bootstrap.sh`.
1. Run this to update `README.md` and `CONTRIBUTING.md`:
   ```bash
   sed -i "" "s/60d36a30887d7ad3200bf02a55ab68e125731709/$(git rev-parse HEAD)/g" README.md CONTRIBUTING.md
   ```
   (TODO: adapt for other operating systems)
