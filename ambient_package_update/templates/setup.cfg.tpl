[metadata]
description-file = README.md
license-file = LICENSE.md

[coverage:run]
branch = True
parallel = True
source =
    {{ package_name }}
    tests

[coverage:paths]
source =
    {{ package_name }}
    .tox/**/site-packages

[coverage:report]
show_missing = True
