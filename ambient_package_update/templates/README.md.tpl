{% include "snippets/badges.tpl" %}
{{ readme_content.tagline }}
{% include "snippets/links.tpl" %}

{% include readme_content.content_template|default("snippets/empty.tpl") %}
{% include readme_content.installation_template|default("snippets/empty.tpl") %}
{% include readme_content.contribute_template|default("snippets/empty.tpl") %}
{% include readme_content.publish_template|default("snippets/empty.tpl") %}
{% include readme_content.maintenance_template|default("snippets/empty.tpl") %}