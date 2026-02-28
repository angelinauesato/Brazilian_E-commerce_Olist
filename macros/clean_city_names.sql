{% macro clean_city_names(column_name) %}
    
    case 
        when {{ column_name }} is null then null

        {% set clean_logic %}
            trim(
                split(
                    split(
                        split(
                            split(
                                regexp_replace(
                                    regexp_replace(
                                        regexp_replace(
                                            regexp_replace(
                                                regexp_replace(
                                                    regexp_replace(lower({{ column_name }}), '[áàâã]', 'a'),
                                                '[éèê]', 'e'),
                                            '[íï]', 'i'),
                                        '[óòôõ]', 'o'),
                                    '[úùû]', 'u'),
                                    '[ç]', 'c'),
                            '/')[0], 
                        '-')[0],
                    ',')[0],
                '\\')[0]
            )
        {% endset %}

        when {{ clean_logic }} = '04482255' then 'rio de janeiro'
        when {{ clean_logic }} = 'aguas claras df' then 'aguas claras'
        when {{ clean_logic }} = 'aparecida d oeste' then 'aparecida d''oeste'
        when {{ clean_logic }} = 'angra dos reis rj' then 'angra dos reis'
        when {{ clean_logic }} = 'ao bernardo do campo' then 'sao bernardo do campo'
        when {{ clean_logic }} = 'angico' then 'angicos'
        when {{ clean_logic }} = 'balenario camboriu' then 'balneario camboriu'
        when {{ clean_logic }} = 'alvorada do oeste' then 'alvorada d''oeste'
        when {{ clean_logic }} = 'belo horizont' then 'belo horizonte'
        when {{ clean_logic }} = 'brasilia df' then 'brasilia'
        when {{ clean_logic }} = 'diamante d  oeste' then 'diamante d''oeste'
        when {{ clean_logic }} = 'armacao de buzios' then 'armacao dos buzios'
        when {{ clean_logic }} = '...arraial do cabo' then 'arraial do cabo'
        when {{ clean_logic }} = 'arraial d ajuda' then 'arraial d''ajuda'
        when {{ clean_logic }} = 'ferraz de  vasconcelos' then 'ferraz de vasconcelos'
        when {{ clean_logic }} = 'floranopolis' then 'florianopolis'
        when {{ clean_logic }} = 'poa' then 'porto alegre'
        when {{ clean_logic }} = 'portoferreira' then 'porto ferreira'
        when {{ clean_logic }} = 'vendas@creditparts.com.br' then 'curitiba'
        
        -- Handling multiple typos with IN
        when {{ clean_logic }} in ('arco', 'arcos', 'arcoverde') then 'arco verde'
        when {{ clean_logic }} in ('ribeirao pretp', 'riberao preto', 'robeirao preto') then 'ribeirao preto'
        when {{ clean_logic }} in ('alta floresta do oeste', 'alta floresta doeste') then 'alta floresta d''oeste'
        when {{ clean_logic }} in ('santa barbara d oeste', 'santa barbara d''oeste', 'santa barbara d´oeste') then 'santa barbara d''oeste'
        when {{ clean_logic }} in ('sao jose dos pinhas', 'sao  jose dos pinhais') then 'sao jose dos pinhais'
        when {{ clean_logic }} = 'sao miguel do oeste' then 'sao miguel d''oeste'
        when {{ clean_logic }} in ('s jose do rio preto', 'sao jose do rio pret') then 'sao jose do rio preto'
        when {{ clean_logic }} in ('sp', 'são paulo', 'sao  paulo', 'sao paluo', 'sao paulo sp', 'sao pauo', 'sao paulop') then 'sao paulo'
        when {{ clean_logic }} in ('sbc', 'sao bernardo do capo') then 'sao bernardo do campo' 
        
        -- Default: use the cleaned version of the string
        else {{ clean_logic }}
    end
{% endmacro %}