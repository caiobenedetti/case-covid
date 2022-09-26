--Total de casos Confirmados
select sum(confirmed) total_casos_confirmados from `processo-seletivo-363017.covid.caso` where is_last = True and place_type = 'city';

--Casos por estado
select state, sum(confirmed) casos_confirmados from `processo-seletivo-363017.covid.caso` where is_last = True and place_type = 'state' group by state order by casos_confirmados desc;

--Letalidade por estado
select state, concat(round(death_rate*100, 2), "%") letalidade from `processo-seletivo-363017.covid.caso` where is_last = True and place_type = 'state' order by letalidade desc;

--Taxa de óbitos por mil habitantes
select round(deaths/estimated_population*1000, 2) Mortalidade_por_1000_hab, state from `processo-seletivo-363017.covid.caso` where is_last = True and place_type = 'state' order by Mortalidade_por_1000_hab desc;

--Porcentagem de municipios com óbitos
with a as (select count(distinct city) c from `processo-seletivo-363017.covid.caso` where deaths > 0),
b as (select count(distinct city) c from `processo-seletivo-363017.covid.caso`)
select round(a.c/b.c * 100, 2) porcentagem from a,b;

--Populações estados
with a as (
  select 
  estimated_population,
  state
  from `processo-seletivo-363017.covid.caso`
  where is_last = True 
  and place_type = 'state'),
b as ( 
  select
  estimated_population,
  state,
  city from (
  select 
  estimated_population,
  state,
  city,
  row_number() over(PARTITION BY state order by estimated_population desc) seq
  from `processo-seletivo-363017.covid.caso`
  where is_last = True 
  and place_type = 'city'
  ) where seq = 1
)
SELECT a.state, 
a.estimated_population, 
b.city, 
round(b.estimated_population/a.estimated_population*100, 2) porcentagem_populacao 
from a left join b on a.state = b.state;