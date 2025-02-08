{% macro investment_categorize(column_name) %}
    {% set investment_rules = var("investment_rules") %}
        CASE 
            {% for rule_name, rule in investment_rules.items() %}  {#  Loop through the items (key-value pairs) #}
                WHEN upper({{column_name}}) LIKE ANY(
                    ARRAY[
                        {% for keyword in rule.keywords %}
                            '%{{ keyword | upper }}%' {% if not loop.last %}, {% endif %}
                        {% endfor %}
                    ]::text[]
                ) THEN '{{ rule.category }}'
            {% endfor %}
            ELSE 'Other'
        END

{% endmacro %}
