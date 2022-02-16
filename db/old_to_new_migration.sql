select * from 
((select 'id', 'url_id', 'company_id', 'region_id', 'name', 'locality', 'street_address', 'suite', 'city', 'county', 'state_code', 'zip', 'country', 'store_number', 'phone', 'orders_count', 'audits_count', 'latitude', 'longitude', 'active', 'created_at', 'updated_at')
UNION
(select `id`, IFNULL(`url_id`,'_NA_'), `company_id`, IFNULL(`region_id`,0), `name`, IFNULL(`locality`, '_NA_'), `street_address`, IFNULL(`suite`, '_NA_'), `city`, IFNULL(`county`, '_NA_'), `state_code`, IFNULL(`zip`,'_NA_'), `country`, IFNULL(`store_number`, '_NA_'), IFNULL(`phone`,'_NA_'), `orders_count`, `audits_count`, `latitude`, `longitude`, `active`, `created_at`, `updated_at`
    from stores)) t into outfile '~/Documents/Work/devops/apps_ror/graeters_v2/db/stores.csv' fields enclosed by '"' terminated by ',' escaped by '\\' lines terminated by '\n';


select * from 
(
    (select 'id', 'name', 'url_part', 'stores_count', 'regions_count', 'active', 'created_at', 'updated_at')
    UNION
    (select `id`, `name`, IFNULL(`url_part`, '_NA_'), `stores_count`, `regions_count`, `active`, `created_at`, `updated_at`
        from companies
    )
) t into outfile '~/Documents/Work/devops/apps_ror/graeters_v2/db/retailers.csv' fields enclosed by '"' terminated by ',' escaped by '\\' lines terminated by '\n';

select * from
(
    (select 'id', 'name', 'company_id', 'stores_count')
    UNION
    (select `id`, `name`, `company_id`, `stores_count`from `regions`)
) t into outfile '~/Documents/Work/devops/apps_ror/graeters_v2/db/regions.csv' fields enclosed by '"' terminated by ',' escaped by '\\' lines terminated by '\n';
