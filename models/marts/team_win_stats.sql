/*
    Win statistics per team per season.
    Business question: Which teams dominated each IPL season?
*/
with team_matches as (
    -- team1 perspective
    select
        season,
        team1                                               as team,
        count(*)                                            as matches_played,
        sum(case when winner = team1 then 1 else 0 end)    as wins
    from {{ ref('stg_matches') }}
    group by season, team1

    union all

    -- team2 perspective
    select
        season,
        team2                                               as team,
        count(*)                                            as matches_played,
        sum(case when winner = team2 then 1 else 0 end)    as wins
    from {{ ref('stg_matches') }}
    group by season, team2
),

aggregated as (
    select
        season,
        team,
        sum(matches_played)                                 as total_matches,
        sum(wins)                                           as total_wins,
        sum(matches_played) - sum(wins)                     as total_losses,
        round(
            sum(wins) * 100.0 / nullif(sum(matches_played), 0), 1
        )                                                   as win_pct
    from team_matches
    group by season, team
)

select *
from aggregated
order by season desc, win_pct desc
