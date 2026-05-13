# Dependabot Helm OCI prerelease-tag issue repro

## Issue

Dependabot Helm OCI version selection may treat prerelease-style OCI tags as valid stable update targets.

Historically, tags with semver-like prerelease metadata after the patch version could be included in latest-version selection, for example branch or build-derived tags. This can cause Dependabot to propose a non-stable target when updating a stable chart dependency.

## Expected behavior

Before comparing versions and selecting the latest candidate, Helm OCI tag filtering should exclude prerelease-style tags, aligning behavior with npm prerelease handling.

## Regression examples

The issue is reproduced with tags such as:

- `3.44.1-1.g585bce1`
- `3.44.1-2.g585bce1`
- `2.0.4-qcg2060solacelabels.146.sha.7ac1266`

## Why this matters

Filtering these tags prevents Dependabot from treating build-derived prerelease variants as stable release candidates and improves consistency across ecosystems.
