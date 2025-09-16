# BMAD Image Builder

Automated container builder that tracks upstream BMAD-METHOD and publishes containers to GitHub Container Registry.

## What This Does

- Watches https://github.com/bmad-code-org/BMAD-METHOD for new semver tags
- Builds Node.js Alpine containers with BMAD installed
- Publishes to `ghcr.io/jeremylongshore/bmad` with semver tags
- Runs daily at 08:23 UTC to check for updates

## Container Interface

```bash
# Simple CLI wrapper for BMAD functionality
docker run --rm -v "$PWD":/work -w /work \
  ghcr.io/jeremylongshore/bmad:latest \
  bmad generate --input project-brief.md --out docs/
```

## Automation

- **Daily builds**: Scheduled workflow checks for new upstream tags
- **Manual builds**: Can be triggered with specific refs
- **Multi-tag publishing**: Creates `X.Y.Z`, `X.Y`, and `latest` tags
- **Immutable digests**: Each build has unique SHA256 digest

## Consuming Projects

This builder is designed to work with Renovate automation in consuming repositories:

1. Consumer pins to specific semver tag in `.bmad-version`
2. Renovate detects new tags and opens PRs
3. Consumer CI validates new container version
4. Auto-merge if CI passes

See: https://github.com/jeremylongshore/vibe-prd