--Change Log
	--30-09-2022  vmj.crew_budgeted added (Mandeep)
	--06-10-2022  vmj.current_last_dry_dock_end_date added (Mandeep)
	--07-10-2022  vmj.last_under_water_survey added (Mandeep)
CREATE procedure [client_portal].[p_start_dev]
AS BEGIN
	
	--
	-- Create views for select jibe data from different env
	--
	
	exec ('
	create or alter view client_portal.v_src_jibe_certificate
	as 
	select *
	from common.v_jibe_certificate
	')
	;
	
	exec ('
	create or alter view client_portal.v_src_jibe_inspection
	as 
	select *
	from common.v_jibe_inspection
	')
	;

	--
	-- Set Source Tables
	--
	exec ('
	create or alter view client_portal.v_src_netsuite_daily_gl
	as 
	select *
	from common.v_netsuite_daily_gl
	')
	;

	exec ('
	create or alter view client_portal.v_src_netsuite_coa_with_lvl
	as 
	select *
	from common.v_netsuite_coa_with_lvl
	')
	;

	exec ('
	create or alter view client_portal.v_src_netsuite_monthly_gl_with_budget
	as 
	select *
	from common.v_netsuite_monthly_gl_with_budget
	')
	;

	--
	-- Set Destination Tables
	--
	exec ('
	create or alter view client_portal.v_dest_Country
	as 
	select *
	from client_portal.Country
	')
	;	

	exec ('
	create or alter view client_portal.v_dest_Port
	as 
	select *
	from client_portal.Port
	')
	;	

	exec ('
	create or alter view client_portal.v_dest_Organization
	as 
	select *
	from client_portal.Organization
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselType
	as 
	select *
	from client_portal.VesselType
	')
	;

	exec ('
	create or alter view client_portal.v_dest_Vessel
	as 
	select *
	from client_portal.Vessel
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselManagement
	as 
	select *
	from client_portal.VesselManagement
	')
	;

	exec ('
	create or alter view client_portal.v_dest_COA
	as 
	select *
	from client_portal.COA
	')
	;

	exec ('
	create or alter view client_portal.v_dest_AccountTransaction
	as 
	select *
	from client_portal.AccountTransaction
	')
	;

	exec ('
	create or alter view client_portal.v_dest_AccountTransactionDocument
	as 
	select *
	from client_portal.AccountTransactionDocument
	')
	;

	exec ('
	create or alter view client_portal.v_dest_Budget
	as 
	select *
	from client_portal.Budget
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselPositionStatus
	as 
	select *
	from client_portal.VesselPositionStatus
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselVoyage
	as 
	select *
	from client_portal.VesselVoyage
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselPosition
	as 
	select *
	from client_portal.VesselPosition
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CrewMember
	as 
	select *
	from client_portal.CrewMember
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CrewServiceHistory
	as 
	select *
	from client_portal.CrewServiceHistory
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselCertificate
	as 
	select *
	from client_portal.VesselCertificate
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CrewRank
	as 
	select *
	from client_portal.CrewRank
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselReport
	as 
	select *
	from client_portal.VesselReport
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselCertificateCategory
	as 
	select *
	from client_portal.VesselCertificateCategory
	')
	;

	exec ('
	create or alter view client_portal.v_dest_InspectionType
	as 
	select *
	from client_portal.InspectionType
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CrewStatusType
	as 
	select *
	from client_portal.CrewStatusType
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CrewMemberStatus
	as 
	select *
	from client_portal.CrewMemberStatus
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CrewDocumentType
	as 
	select *
	from client_portal.CrewDocumentType
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CrewDocument
	as 
	select *
	from client_portal.CrewDocument
	')
	;

	exec ('
	create or alter view client_portal.v_dest_SourceSystem
	as 
	select *
	from client_portal.SourceSystem
	')
	;

	exec ('
	create or alter view client_portal.v_dest_CISPort
	as 
	select *
	from client_portal.CISPort
	')
	;

	exec ('
	create or alter view client_portal.v_dest_Contact
	as 
	select *
	from client_portal.Contact
	')
	;

	exec ('
	create or alter view client_portal.v_dest_ContactRole
	as 
	select *
	from client_portal.ContactRole
	')
	;

	exec ('
	create or alter view client_portal.v_dest_VesselContact
	as 
	select *
	from client_portal.VesselContact
	')
	;

	-- client_portal.v_port_country source
	exec ('
	create or alter  view client_portal.v_port_country
	as 
	select 
	 p.Id as PortId
	,p.Name as Port
	,c.Id as CountryId
	,c.Name as Country
	,p.Abbrevation 
	,p.Latitude 
	,p.Longitude 
	from client_portal.Port p 
	,client_portal.Country c 
	where p.CountryId = c.Id
	')
	;
	--
	-- Prepare temp table for preparing Vessel Master
	--	
	if OBJECT_ID('client_portal.temp_vessel_master', 'U') is not null 
		drop table client_portal.temp_vessel_master;
	
	--
	-- For Production
	--
	/*
	select 
	 *
	into client_portal.temp_vessel_master
	from common.v_vessel_master_jibe vmj 
	where cis_ship_code in ('AJY', 'AME', 'GEC', 'RME', 'YCN', 'YPN')
	;
	*/
	
	--
	-- For Development
	--
	select 
	 vmj.ship_type
	,vm.vessel_name as ship_name
	,vm.imo_code as imo
	,vmj.active
	,vmj.call_sign 
	,vmj.officialno 
	,vmj.flag 
	,vmj.class 
	,vmj.primary_contact 
	,vmj.takeover_date 
	,vmj.handover_date 
	,vmj.fos_ship_code
	,vmj.port_of_registry
	,vmj.netsuite_ship_code 
	,vm.group_owner_name as group_owner_name
	,vm.group_owner_country
	,vm.registered_owner_name as registered_owner_name 
	,vm.short_name as jibe_ship_code
	,vmj.cis_ship_code 
	,vmj.safe_manning_count 
	,vm.OrganizationAeCode 
	,vmj.crew_budgeted --vmj.crew_budgeted added (Mandeep)
	,vmj.current_last_dry_dock_end_date --vmj.current_last_dry_dock_end_date added (Mandeep)
	,vmj.last_under_water_survey --vmj.last_under_water_survey added (Mandeep)
--	,vm.*
	into client_portal.temp_vessel_master
	from      common.v_vessel_master_jibe vmj
	join	  jibe.vessel_dev vm on (vmj.cis_ship_code = left(vm.real_ship_code, 3))
	;

	exec client_portal.p_print 'Created temporary table temp_vessel_master to prepare Vessel, VesselManagement';
	
	exec client_portal.p_main;

END
;


