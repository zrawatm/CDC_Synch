CREATE procedure [client_portal].[p_main]
as BEGIN
	
	--
	-- Prepare Source System data
	--
	--truncate table client_portal.v_dest_SourceSystem;

	with v_source as 
	(
	select 
	 'CIS' as SourceName 
	,'CIS' as Code 
	union all
	select 
	 'JiBe' as SourceName 
	,'JIB' as Code
	union all
	select 
	 'NetSuite' as SourceName 
	,'NET' as Code
	union all
	select 
	 'VIS' as SourceName 
	,'VIS' as Code
	)
	insert into client_portal.v_dest_SourceSystem
	(SourceName
  	,Code
	,CreatedOnUtc
	)
	select 
	 s.SourceName 
	,s.Code 
	,GetDate() as CreatedOnUtc
	from v_source s 
	where not exists 
	(
		select 1
		from client_portal.v_dest_SourceSystem cp_s
		where cp_s.Code = s.Code
	)
	;

	exec client_portal.p_print 'Created client_portal.SourceSystem';

	--
	-- Prepare Country
	--
	--truncate table client_portal.Country;

	insert into client_portal.v_dest_Country(Name, Iso3, Iso2, CreatedOnUtc)
	select 
 	 'UNKNOWN' as Name
	,'ZZZ' as Iso3 
	,'ZZ' as Iso2 
	,GetDate() as CreatedOnUtc
	where not exists (
		select 1
		from client_portal.v_dest_Country c
		where c.Name = 'UNKNOWN'
	)
	;
	
	insert into client_portal.v_dest_Country(Name, Iso3, Iso2, CreatedOnUtc)
	select 
 	distinct
 	 country as Name
	,country_iso3 as Iso3 
	,country_iso2 as Iso2 
	,GetDate() as CreatedOnUtc
	from common.port_country_master pcm 
	where not exists 
	(
		select 1
		from client_portal.v_dest_Country c 
		where pcm.country = c.Name
	)
	;

	exec client_portal.p_print 'Created client_portal.Country';

	--
	-- Prepare CISPort
	--
	insert into client_portal.v_dest_CISPort
	(Code 
	,PortName 
	,Country
	,CreatedOnUtc
	)
	select 
	 p.port_code as Code
	,p.port_name as PortName 
	,p.country as Country
	,GetDate() as CreatedOnUtc
	from cis.csm02 p
	where port_code is not null
	and not exists 
	(
	select 1
	from client_portal.v_dest_CISPort cp_p 
	where cp_p.Code = p.port_code
	)
	;

	exec client_portal.p_print 'Created client_portal.CISPort, that is temporary used for mapping CIS port on/off code';

	--
	-- Prepare Port
	--
/*
	truncate table client_portal.v_dest_Port;

	insert into client_portal.v_dest_Port(CountryId, Name, Abbrevation, CreatedOnUtc)
	select 
	 1 as CountryId
	,'UNKNOWN' as Name
	,'ZZZZZ' as Abbrevation
	,GetDate() as CreatedOnUtc
	where not exists (
		select 1
		from client_portal.v_dest_Port c
		where c.Name = 'UNKNOWN'
	)
	;

	insert into client_portal.v_dest_Port(CountryId, Name, Abbrevation, CreatedOnUtc)
	select 
	 distinct
	 c.Id as CountryId
	,p.port as Name
	,port_code as Abbrevation
	,GetDate() as CreatedOnUtc
	from common.port_country_master p 
	left join client_portal.v_dest_Country c on (p.country_iso2 = c.iso2)
	where not exists 
	(
		select 1
		from client_portal.v_dest_Port cp
		where cp.Abbrevation = p.port_code
	)
	;
	*/

	if OBJECT_ID('client_portal.temp_Port', 'U') is not null 
		drop table client_portal.temp_Port
	;

	with v_port
	as 
	(
	select 
	 1 as CountryId
	,'UNKNOWN' as Name
	,'ZZZZZ' as Abbrevation
	,null as Longitude
	,null as Latitude
	,GetDate() as CreatedOnUtc
	,GetDate() as UpdatedOnUtc
	union all 
	select 
	 distinct
	 c.Id as CountryId
	,p.port as Name
	,port_code as Abbrevation
	,p.port_lon as Longitude
	,p.port_lat as Latitude
	,GetDate() as CreatedOnUtc
	,GetDate() as UpdatedOnUtc
	from common.port_country_master p 
	left join client_portal.v_dest_Country c on (p.country_iso2 = c.iso2)
	)
	select *
	into client_portal.temp_Port
	from v_port
	;

	update d
	set 
	 d.CountryId = s.CountryId
	,d.Longitude = s.Longitude
	,d.Latitude = s.Latitude
	from client_portal.v_dest_Port d
	,client_portal.temp_Port s
	where s.Name = d.Name
	and s.Abbrevation = d.Abbrevation
	and not (
		d.CountryId = s.CountryId
	and d.Longitude = s.Longitude
	and d.Latitude = s.Latitude
	)
	;
	
	insert into client_portal.v_dest_Port
	(CountryId 
	,Name 
	,Abbrevation 
	,Longitude 
	,Latitude
	,CreatedOnUtc
	,UpdatedOnUtc
	)
	select 
	 s.CountryId 
	,s.Name 
	,s.Abbrevation 
	,s.Longitude 
	,s.Latitude
	,s.CreatedOnUtc
	,s.UpdatedOnUtc
	from client_portal.temp_Port s
	where not exists 
	(
		select 1
		from client_portal.v_dest_Port d
		where s.Name = d.Name
		and s.Abbrevation = d.Abbrevation
	)
	;

	exec client_portal.p_print 'Created client_portal.Port';
	
	--
	-- Prepare Organization
	--
	if OBJECT_ID('client_portal.temp_Organization', 'U') is not null 
		drop table client_portal.temp_Organization;

	--truncate table client_portal.[Organization]; 

	with v_org
	as 
	(
	/*
	SELECT distinct 
	 ctry.Id as CountryId
	,ship_owner_country as _Country
	,ship_owner_name as Name 
	,cast(ship_owner_url as varchar) as LogoUrl
	,'CUSTOMER' as Type
	,null as CreatedOnUtc
	,null as NetSuiteCustId
	--,c.ae_jibe_id as _AeCode
	--,PHONE as _Phone
	-- ,*
	FROM      common.v_ship_and_owner c
	left join client_portal.Country ctry on (ctry.name = c.ship_owner_country)
	union ALL 
	*/
	select 
	 ctry.Id as CountryId
	,'Hong Kong' as _Country
	,'Anglo-Eastern' as Name 
	,'https://www.angloeastern.com/assets/image/logo.png' as LogoUrl
	,'Self' as Type
	,GetDate() as CreatedOnUtc
	,cast(null as int) as SourceSystemId
	--,cast(null as varchar) as SourceTransactionId
	,'OWNANGEA' as OrganizationAeCode
	from client_portal.Country ctry
	where ctry.iso2 = 'HK'
	--
	-- Original code but temporary disabled at 24-Jan-2022 to hardcode Organization to match with User Management Database
	--
	/*
	union ALL 
	select distinct
	 ctry.Id as CountryId
	,'Hong Kong' as _Country
	,v.group_owner_name as Name 
	,null as LogoUrl
	,'Client' as Type
	,null as CreatedOnUtc
	,null as NetSuiteCustId
	from common.v_vessel_master_jibe v
	join client_portal.Country ctry on (ctry.iso2 = 'HK')
	*/
	--
	-- For hardcoding the Organization Id
	--
	/*union all 
	select 
	 ctry.Id as CountryId
	,'Hong Kong' as _Country
	,'Dummy1' as Name 
	,'https://www.angloeastern.com/assets/image/logo.png' as LogoUrl
	,'Client' as Type
	,GetDate() as CreatedOnUtc
	,cast(null as int) as SourceSystemId
	--,cast(null as varchar) as SourceTransactionId
	,'OWNDUM1' as OrganizationAeCode
	from client_portal.Country ctry
	where ctry.iso2 = 'HK'
	/*
	union all 
	select 
	 ctry.Id as CountryId
	,'Hong Kong' as _Country
	,'Hunters Group Limited' as Name 
	,'https://www.angloeastern.com/assets/image/logo.png' as LogoUrl
	,'Client' as Type
	,GetDate() as CreatedOnUtc
	,cast(null as int) as SourceSystemId
	,cast(null as varchar) as SourceTransactionId
	from client_portal.Country ctry
	where ctry.iso2 = 'HK'
	*/
	union all 
	select 
	 ctry.Id as CountryId
	,'Hong Kong' as _Country
	,'Dummy2' as Name 
	,'https://www.angloeastern.com/assets/image/logo.png' as LogoUrl
	,'Client' as Type
	,GetDate() as CreatedOnUtc
	,cast(null as int) as SourceSystemId
	--,cast(null as varchar) as SourceTransactionId
	,'OWNDUM2' as OrganizationAeCode
	from client_portal.Country ctry
	where ctry.iso2 = 'HK'
	
	union all 
	select 
	 ctry.Id as CountryId
	,'Hong Kong' as _Country
	,'Group Owner Ltd' as Name 
	,'https://www.angloeastern.com/assets/image/logo.png' as LogoUrl
	,'Client' as Type
	,GetDate() as CreatedOnUtc
	,cast(null as int) as SourceSystemId
	,cast(null as varchar) as SourceTransactionId
	from client_portal.Country ctry
	where ctry.iso2 = 'HK'
	union all 
	select 
	 ctry.Id as CountryId
	,'Hong Kong' as _Country
	,'Catering Limted' as Name 
	,'https://www.angloeastern.com/assets/image/logo.png' as LogoUrl
	,'Client' as Type
	,GetDate() as CreatedOnUtc
	,cast(null as int) as SourceSystemId
	,cast(null as varchar) as SourceTransactionId
	from client_portal.Country ctry
	where ctry.iso2 = 'HK'
	*/
	union all 
	select 
	 distinct 
	 c.Id as CountryId
	,c.Name as _Country
	,vm.group_owner_name as Name 
	,'https://www.angloeastern.com/assets/image/logo.png' as LogoUrl
	,'Client' as Type 
	,GetDate() as CreatedOnUtc
	,s.Id as SourceSystemId
	--,vm.group_owner_name as SourceTransactionId
	,vm.OrganizationAeCode as OrganizationAeCode
	from      client_portal.temp_vessel_master vm
	left join client_portal.v_dest_Country c on (vm.group_owner_country = c.Name)
	left join client_portal.v_dest_SourceSystem s on (s.SourceName = 'JiBe')
	)
	--insert into client_portal.[Organization](CountryId, Name, Type, SourceSystemId, SourceTransactionId, CreatedOnUtc)
	select
	 a.CountryId
	,a.Name
	,a.Type
	,a.SourceSystemId
	--,a.SourceTransactionId
	,a.OrganizationAeCode
	,a.CreatedOnUtc
	into client_portal.temp_Organization
	from v_org a
	;

	update d
	set 
	 d.CountryId = s.CountryId
	,d.Type = s.Type
	,d.SourceSystemId = s.SourceSystemId
	--,d.SourceTransactionId  = s.SourceTransactionId
	,d.OrganizationAeCode = s.OrganizationAeCode
	,d.CreatedOnUtc = s.CreatedOnUtc
	from client_portal.v_dest_Organization d
	,client_portal.temp_Organization s
	where s.Name = d.Name
	and not (
		d.CountryId = s.CountryId
	and d.Type = s.Type
	and d.SourceSystemId = s.SourceSystemId
	--and COALESCE(d.SourceTransactionId, '@~@~@~')  = COALESCE(s.SourceTransactionId, '@~@~@~')
	and COALESCE(d.OrganizationAeCode, '@~@~@~') = COALESCE(s.OrganizationAeCode, '@~@~@~')
	)
	;

	insert into client_portal.v_dest_Organization(CountryId, Name, Type, SourceSystemId, OrganizationAeCode, CreatedOnUtc)
	select
	 a.CountryId
	,a.Name
	,a.Type
	,a.SourceSystemId
	--,a.SourceTransactionId
	,a.OrganizationAeCode
	,a.CreatedOnUtc
	from client_portal.temp_Organization a
	where not exists 
	(
	select 1
	from client_portal.v_dest_Organization b
	where a.Name = b.Name
	)
	;

	exec client_portal.p_print 'Created client_portal.Organization';
	
	--
	-- Prepare Vessel Type
	--
	--truncate table client_portal.VesselType;

	insert into client_portal.v_dest_VesselType(Description, CreatedOnUtc)
	select 
	 distinct 
	 ship_type as Description
	,GetDate() as CreatedOnUtc
	from client_portal.temp_vessel_master
	where not exists 
	(
		select 1
		from client_portal.v_dest_VesselType vt 
		where vt.Description = ship_type
	)
	;

	exec client_portal.p_print 'Created client_portal.VesselType';

	--
	-- Prepare Vessel
	--
	if OBJECT_ID('client_portal.temp_Vessel', 'U') is not null 
		drop table client_portal.temp_Vessel;

	--truncate table client_portal.Vessel;

	select 
	 vt.Id as VesselTypeId
	--,v.vessel_type as _VesselType
	,c.Id as FlagCountryId
	,vmj.flag as Flag
	,rp.Id as RegistryPortId
	,s.Id as SourceSystemId
	,vmj.jibe_ship_code as SourceTransactionId
	,vmj.port_of_registry as RegistryPort
	,vmj.ship_name as Name
	,vmj.imo as Imo
	,vmj.call_sign as CallSign
	,vmj.officialno as OfficialNumber
	,vmj.class as Class 
	,vmj.primary_contact as Phone 
	--,email as _Email 
	--,vmj.safe_manning_count as SafeManningCount
	,vmj.crew_budgeted as [BudgetedCrewCount]	-- added by Mandeep 03-10-2022
	,vmj.current_last_dry_dock_end_date as LastDryDockDateUtc
	,null as NextDryDockDateUtc
	,null as LastUwcUwiDateUtc
	,vmj.last_under_water_survey as NextUwcUwiDateUtc -- added by Mandeep 07-10-2022
	,null as LastInspectionDateUtc
	,null as NextInspectionDateUtc
	--,v.cdc_creation_date as CreatedOnUtc
	--,v.cdc_modified_date as UpdatedOnUtc
	,GetDate() as CreatedOnUtc
	,GetDate() as UpdatedOnUtc
	into client_portal.temp_Vessel
	from      client_portal.temp_vessel_master vmj
	left join client_portal.v_dest_VesselType vt on (vmj.ship_type = vt.Description)
	left join client_portal.v_dest_Country c on (c.Name = vmj.flag)
	left join client_portal.v_dest_Country rp on (lower(rp.Name) = vmj.port_of_registry)
	left join client_portal.v_dest_SourceSystem s on (s.Code = 'CIS');

	create index ix_temp_Vessel on client_portal.temp_Vessel(Name, Imo);

	exec client_portal.p_print 'Created temporary table temp_Vessel for preparing Vessel, VesselManagement';

	-- Delete Vessel not found in source table
	delete d
	from client_portal.v_dest_Vessel d
	where not exists 
	(
		select 1
		from client_portal.temp_Vessel s
		where s.Name = d.Name
		and s.Imo = d.Imo
		and s.Flag = d.Flag
		and s.RegistryPort = d.RegistryPort
		and s.CallSign = d.CallSign 
		and s.OfficialNumber = d.OfficialNumber 
		and s.Phone = d.Phone 
		--and s.BudgetedCrewCount= d.BudgetedCrewCount
		
	)
	;

	-- Update Vessel
	update d
	set 
	 d.VesselTypeId = s.VesselTypeId
	,d.Flag = s.Flag
	,d.RegistryPort = s.RegistryPort
	,d.SourceSystemId = s.SourceSystemId
	,d.SourceTransactionId = s.SourceTransactionId
	,d.CallSign = s.CallSign
	,d.OfficialNumber = s.OfficialNumber
	,d.Class = s.Class
	,d.Phone = s.Phone
	--,d.SafeManningCount = s.SafeManningCount
	,d.BudgetedCrewCount = s.BudgetedCrewCount	--added by Mandeep 03-10-2022
	,d.LastDryDockDateUtc = s.LastDryDockDateUtc
	,d.NextDryDockDateUtc = s.NextDryDockDateUtc
	,d.LastUwcUwiDateUtc = s.LastUwcUwiDateUtc
	,d.NextUwcUwiDateUtc = s.NextUwcUwiDateUtc
	,d.LastInspectionDateUtc = s.LastInspectionDateUtc
	,d.NextInspectionDateUtc = s.NextInspectionDateUtc
	,d.UpdatedOnUtc = s.UpdatedOnUtc
	from client_portal.v_dest_Vessel d
	,client_portal.temp_Vessel s
	where s.Name = d.Name
	and s.Imo = d.Imo
	and not (
		d.VesselTypeId = s.VesselTypeId
	--and d.FlagCountryId = s.FlagCountryId
	--and d.RegistryPortId = s.RegistryPortId
	and d.SourceSystemId = s.SourceSystemId
	and d.SourceTransactionId = s.SourceTransactionId
	and d.Flag = s.Flag
	and d.RegistryPort = s.RegistryPort
	and d.CallSign = s.CallSign
	and d.OfficialNumber = s.OfficialNumber
	and d.Class = s.Class
	and d.Phone = s.Phone
	--and d.SafeManningCount = s.SafeManningCount
	and d.BudgetedCrewCount = s.BudgetedCrewCount	--added by Mandeep 03-10-2022
	and d.LastDryDockDateUtc = s.LastDryDockDateUtc
	and d.NextDryDockDateUtc = s.NextDryDockDateUtc
	and d.LastUwcUwiDateUtc = s.LastUwcUwiDateUtc
	and d.NextUwcUwiDateUtc = s.NextUwcUwiDateUtc
	and d.LastInspectionDateUtc = s.LastInspectionDateUtc
	and d.NextInspectionDateUtc = s.NextInspectionDateUtc
	)
	;

	-- Insert Vessel
	insert into client_portal.v_dest_Vessel(
	 VesselTypeId
	,Flag
	,RegistryPort
	,SourceSystemId
	,SourceTransactionId
	,Name
	,Imo
	,CallSign
	,OfficialNumber
	,Class
	,Phone
	--,SafeManningCount
	,BudgetedCrewCount --added by Mandeep 03-10-2022
	,LastDryDockDateUtc
	,NextDryDockDateUtc
	,LastUwcUwiDateUtc
	,NextUwcUwiDateUtc
	,LastInspectionDateUtc
	,NextInspectionDateUtc
	,CreatedOnUtc
	,UpdatedOnUtc
	)
	select 
	 VesselTypeId
	,Flag
	,RegistryPort
	,SourceSystemId
	,SourceTransactionId
	,Name
	,Imo
	,CallSign
	,OfficialNumber
	,Class
	,Phone
	--,SafeManningCount
	,BudgetedCrewCount --added by Mandeep 03-10-2022
	,LastDryDockDateUtc
	,NextDryDockDateUtc
	,LastUwcUwiDateUtc
	,NextUwcUwiDateUtc
	,LastInspectionDateUtc
	,NextInspectionDateUtc
	,CreatedOnUtc
	,UpdatedOnUtc
	from client_portal.temp_Vessel s
	where not exists 
	(
		select 1
		from client_portal.v_dest_Vessel clv
		where clv.Name = s.Name
		and clv.Imo = s.Imo
	)
	;

	exec client_portal.p_print 'Created client_portal.Vessel';

	--
	-- Prepare VesselManagement
	--
	if OBJECT_ID('client_portal.temp_VesselManagement', 'U') is not null 
		drop table client_portal.temp_VesselManagement;

	--truncate table client_portal.VesselManagement;
	
	select 
	 org.OrganizationAeCode as OrganizationAeCode
	--,vm.netsuite_subsidiary_id as _ClientOrganizationId
	-- ,c.COMPANYNAME as _CompanyName
	,v.id as VesselId
	,vm.jibe_ship_code as AeCode
	-- ,vm.fos_ship_code as AeCode -- debug
	,vm.takeover_date as FromDateUtc
	,vm.handover_date as ToDateUtc
	,vm.active as Active
	,s.fiscal_year as FiscalYear
	,vm.takeover_date as CreatedOnUtc
	into client_portal.temp_VesselManagement
	from client_portal.temp_vessel_master vm
	--left join client_portal.Organization org on (org.NetSuiteCustId = vm.netsuite_subsidiary_id)
	left join client_portal.v_dest_Organization org on (org.OrganizationAeCode = vm.OrganizationAeCode)
	left join client_portal.v_dest_Vessel v on (vm.imo = v.imo)
	left join common.v_netsuite_ship_and_owner s on (s.ship_code = vm.netsuite_ship_code)
	;
	
	create index ix_temp_VesselManagement on client_portal.temp_VesselManagement(AeCode);

	exec client_portal.p_print 'Created temporary table temp_VesselManagement';

	-- Delete VesselManagement
	delete d
	from client_portal.v_dest_VesselManagement d
	where not exists 
	(
		select 1
		from client_portal.temp_VesselManagement s
		where d.AeCode = s.AeCode
	)
	;

	-- Update VesselManagement
	update d 
	set 
	 d.OrganizationAeCode = s.OrganizationAeCode
	,d.VesselId = s.VesselId
	,d.FromDateUtc = s.FromDateUtc
	,d.ToDateUtc = s.ToDateUtc
	,d.Active = s.Active
	,d.FiscalYear = s.FiscalYear
	from client_portal.v_dest_VesselManagement d
	,client_portal.temp_VesselManagement s
	where d.AeCode = s.AeCode
	/*and not (
		d.ClientOrganizationId = s.ClientOrganizationId
	and coalesce(d.SourceClientOrganizationId, '@~@~@~') = coalesce(s.SourceClientOrganizationId, '@~@~@~')
	and d.VesselId = s.VesselId
	and d.FromDateUtc = s.FromDateUtc
	and d.ToDateUtc = s.ToDateUtc
	and d.Active = s.Active
	and d.FiscalYear = s.FiscalYear
	)*/
	;
	
	-- Insert VesselManagement
	insert into client_portal.v_dest_VesselManagement
	(
	 OrganizationAeCode
	,VesselId
	,AeCode
	,FromDateUtc
	,ToDateUtc
	,Active
	,FiscalYear
	,CreatedOnUtc
	)
	select 
	 OrganizationAeCode
	,VesselId
	,AeCode
	,FromDateUtc
	,ToDateUtc
	,Active
	,FiscalYear
	,CreatedOnUtc
	from client_portal.temp_VesselManagement s
	where not exists 
	(
		select 1
		from client_portal.v_dest_VesselManagement cp_vm 
		where cp_vm.AeCode = s.AeCode 
	)
	;

	exec client_portal.p_print 'Created client_portal.VesselManagement';

	exec client_portal.p_voyage;

	exec client_portal.p_crew;

	exec client_portal.p_contact;

	--
	-- Call p_opex to genearate OPEX datasets
	--
	exec client_portal.p_opex;

END
;