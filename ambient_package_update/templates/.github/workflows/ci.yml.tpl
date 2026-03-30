name: Unit tests

on:
  push:
    branches:
    - {{ main_branch }}
  pull_request:

jobs:
  ci:
    uses: ./.github/workflows/quality-gate.yml
