## Installation

- Install the package via pip:

  `pip install {{ package_name }}`

  or via pipenv:

  `pipenv install {{ package_name }}`

- Add module to `INSTALLED_APPS` within the main django `settings.py`:

```python
INSTALLED_APPS = (
    # ...
    "{{ module_name }}",
)
```

{% if has_migrations %}
- Apply migrations by running:

  `python ./manage.py migrate`
{% endif %}
