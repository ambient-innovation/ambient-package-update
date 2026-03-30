## Releasing a new version

Releases are fully automated. Push a version tag and the pipeline will build, sign with
[Sigstore](https://www.sigstore.dev/), publish to PyPI via
[Trusted Publishing](https://docs.pypi.org/trusted-publishers/), and create a GitHub Release —
no API tokens needed.

```bash
git tag v<version>          # e.g. git tag v1.2.3
git push origin v<version>
```

Tags **must** start with `v`. Tags without the prefix won't trigger the pipeline.

### First-time setup

Before the pipeline can run for the first time, an admin must:

1. **Create GitHub Environment `pypi`**
   - Go to *Settings → Environments → New environment*, name it exactly `pypi`
   - Under *Deployment branches and tags*, add a tag rule with pattern `v*`
   - Optionally add required reviewers for a manual approval gate

2. **Configure PyPI Trusted Publisher**
   - Go to *PyPI → Project settings → Publishing → Add a new publisher*
   - Fill in: Owner `{{ github_package_group }}`, Repository `{{ github_package_name }}`,
     Workflow `release.yml`, Environment `pypi`

### Publish to ReadTheDocs.io

- Fetch the latest changes in GitHub mirror and push them
- Trigger new build at ReadTheDocs.io (follow instructions in admin panel at RTD) if the GitHub webhook is not yet set
  up.
