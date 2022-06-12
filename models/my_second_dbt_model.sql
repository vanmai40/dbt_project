
-- Use the `ref` function to select from other models

select id+1 as id
from {{ ref('my_first_dbt_model') }}
