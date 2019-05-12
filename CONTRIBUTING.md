## Contributing

### Updating dev-setup.sh

If you update [bootstrap.sh](bootstrap.sh) you will need to update the links in the [README.md](README.md) and [CONTRIBUTING.md](CONTRIBUTING.md) (for the convenience of the next person).

To update the links:
1. Commit the changes to `bootstrap.sh`.
1. Run this to update `README.md` and `CONTRIBUTING.md`:
   ```bash
   sed -i "" "s/2c011cf63d9c178b93eedf8fd14fdf492f5d0d2e/$(git rev-parse HEAD)/g" README.md CONTRIBUTING.md
   ```
   (TODO: adapt for other operating systems)
