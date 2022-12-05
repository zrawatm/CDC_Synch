
-- common.v_vessel_master_jibe source

--CHANGE LOG
	--vid.[Crew Budgeted] AS crew_budgeted -- added by Mandeep(30-09-2022)
	--,vid.[Current/Last Dry-Dock End Date] AS current_last_dry_dock_end_date -- added by Mandeep(06-10-2022)
	--,vid.[Last Under Water Survey] as last_under_water_survey -- added by Mandeep(07-10-2022)

CREATE   view [common].[v_vessel_master_jibe]
as 
with v_eff_vessel 
as 
(
select *
--,row_number() over (partition by vessel_short_name order by date_of_modification desc, audit_time desc) as rn
,row_number() over (partition by vessel_id order by date_of_modification desc, audit_time desc) as rn
from jibe.vessel_audit v 
)
select 
 v.vessel_types as ship_type
,v.vessel_name as ship_name
,v.imo_code as imo
/*,case when audit_event = 'D' then 0
      when fleet in ('Out of Management ') then 0
      else active_status
 end as active*/
,case when handover_date is null then 1
 else 0 end as active
,left(v.vessel_short_name, 3) as fos_ship_code
--,left(v.vessel_short_name, 3) as netsuite_ship_code
,case when (len(v.vessel_short_name) = 4 and right(v.vessel_short_name, 1) = 'J') then left(v.vessel_short_name, 3) else v.vessel_short_name end as netsuite_ship_code 
,left(v.vessel_short_name, 3) as cis_ship_code
,v.vessel_short_name as jibe_ship_code
,v.call_sign as call_sign
--,v.official_number as officialno
,vid.[Official No.] as officialno
,v.flag as flag
--,v.class as class
,vid.[Classification Society] as class
,vid.[Port of Registry] as port_of_registry
,vid.[Communication 1 Phone] as primary_contact
,vid.[Minimum Safe manning onboard] as safe_manning_count
,v.takeover_date 
,v.handover_date 
,v.vessel_group_owner as group_owner_name 
,vid.[Group Owner Country] as group_owner_country
,vid.[Registered Owner Name] as registered_owner_name
,vid.[Crew Budgeted] AS crew_budgeted -- added by Mandeep(30-09-2022)
,vid.[Current/Last Dry-Dock End Date] AS current_last_dry_dock_end_date -- added by Mandeep(30-09-2022)
,vid.[Last Under Water Survey] as last_under_water_survey -- added by Mandeep(07-10-2022)
--,registered_owner_name
--,commercial_no_of_crew
--,*
from      v_eff_vessel v
join common.v_jibe_vid vid 
on (v.vessel_short_name = vid.vid_ship_code)
where v.rn = 1;
GO


