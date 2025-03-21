{% macro learn_variables() %}
    -- Jinja variable
    {% set your_name_jinja = "Omar" %}
    {{ log ("Hello " ~ your_name_jinja, info=True) }}

    --dbt variable
    {{ log("Hello dbt user " ~ var("user_name", "...NO USERNAME IS SET ?!") ~ "!", info=True) }}

{% endmacro %}

