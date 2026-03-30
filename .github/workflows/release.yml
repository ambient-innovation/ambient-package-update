name: Release

on:
  workflow_run:
    workflows: ["Unit tests"]
    types: [completed]

# Restrictive default — each job declares only what it needs
permissions:
  contents: read

jobs:
  build:
    # Only release when CI passed on a version tag. We use head_branch which holds the tag name
    # for tag-triggered runs (e.g. "v1.2.3"). The startsWith + contains heuristic approximates
    # a version tag: starts with "v" and contains a dot. It is not bullet-proof — a branch named
    # "v2.0-feature" would also match — but covers the common case without regex support.
    if: >-
      github.event.workflow_run.conclusion == 'success' &&
      startsWith(github.event.workflow_run.head_branch, 'v') &&
      contains(github.event.workflow_run.head_branch, '.')
    name: Build distribution packages
    runs-on: ubuntu-24.04
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v6

      - name: Set up Python 3.13
        uses: actions/setup-python@v6
        with:
          python-version: "3.13"

      - name: Install uv
        uses: astral-sh/setup-uv@v8.0.0

      - name: Build packages
        run: uv build

      - name: Upload distribution packages
        uses: actions/upload-artifact@v7
        with:
          name: dist
          path: dist/
          if-no-files-found: error

  sign:
    name: Sign distribution packages
    runs-on: ubuntu-24.04
    needs: build
    permissions:
      id-token: write  # required for Sigstore OIDC signing
      contents: read
    steps:
      - name: Download distribution packages
        uses: actions/download-artifact@v8
        with:
          name: dist
          path: dist/

      - name: Sign packages with Sigstore
        uses: sigstore/gh-action-sigstore-python@v3.3.0
        with:
          inputs: >-
            ./dist/*.tar.gz
            ./dist/*.whl

      - name: Upload signed distribution packages
        uses: actions/upload-artifact@v7
        with:
          name: dist-signed
          path: dist/
          if-no-files-found: error

  github-release:
    name: Create GitHub Release
    runs-on: ubuntu-24.04
    needs: sign
    permissions:
      contents: write  # required to create GitHub releases
    steps:
      - name: Download signed distribution packages
        uses: actions/download-artifact@v8
        with:
          name: dist-signed
          path: dist/

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          files: dist/**
          fail_on_unmatched_files: true

  publish-pypi:
    name: Publish to PyPI
    runs-on: ubuntu-24.04
    needs: sign
    environment: pypi
    permissions:
      id-token: write  # required for PyPI Trusted Publisher OIDC auth
      contents: read
    steps:
      - name: Download signed distribution packages
        uses: actions/download-artifact@v8
        with:
          name: dist-signed
          path: dist/

      - name: Remove Sigstore bundles (PyPI only accepts .whl and .tar.gz)
        run: rm dist/*.sigstore.json

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
        # Sigstore attestations are generated and uploaded to PyPI automatically
        # when using Trusted Publishing — no extra configuration needed.
