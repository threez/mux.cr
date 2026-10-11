# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Upgraded `ameba` dev dependency from `~> 1.0.0` to `~> 1.7.0` and fixed all
  resulting lint violations.
- Standardized CI: split `.github/workflows/ci.yml` into separate `lint` and
  `test` jobs, bumped `actions/checkout` to `v4`, and added shard caching.
- Updated `.github/workflows/pages.yml` to `actions/upload-pages-artifact@v3`
  and `actions/deploy-pages@v4`.
- Added `version`, `tag`, `fmtcheck`, and `clean` targets to the `Makefile` to
  support the standard release process.
