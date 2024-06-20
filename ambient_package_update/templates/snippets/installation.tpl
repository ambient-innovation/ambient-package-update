## Installation

- Install the package via pip:

  `pip install {{ package_name|replace("_", "-") }}`

  or via pipenv:

  `pipenv install {{ package_name|replace("_", "-") }}`

- Add module to `INSTALLED_APPS` within the main django `settings.py`:

    ````
    INSTALLED_APPS = (
        ...
        '{{ package_name }}',
    )
     ````

{% if has_migrations %}
- Apply migrations by running:

  `python ./manage.py migrate`
{% endif %}
