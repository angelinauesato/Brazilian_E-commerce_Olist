{% snapshot snp_users %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='check',
      check_cols=['zip_code_prefix', 'city', 'state_code'],
    )
}}

select * from {{ ref('stg_users') }}

{% endsnapshot %}