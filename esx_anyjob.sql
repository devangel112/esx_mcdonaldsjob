INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_mcdonalds', 'mcdonalds', 1),
	('society_offmcdonalds', 'FDS - McDonalds', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_mcdonalds', 'mcdonalds', 1),
	('society_offmcdonalds', 'FDS - McDonalds', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_mcdonalds', 'mcdonalds', 1),
	('society_offmcdonalds', 'FDS - McDonalds', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('mcdonalds','McDonalds'),
	('offmcdonalds','FDS - McDonalds')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('mcdonalds',0,'employee','Empleado',400,'{}','{}'),
	('mcdonalds',1,'security','Seguridad',550,'{}','{}'),
	('mcdonalds',2,'chief','Gerente',600,'{}','{}'),
	('mcdonalds',3,'boss','Dueño',500,'{}','{}'),
	('offmcdonalds',0,'employee','Empleado',150,'{}','{}'),
	('offmcdonalds',1,'security','Seguridad',150,'{}','{}'),
	('offmcdonalds',2,'chief','Gerente',150,'{}','{}'),
	('offmcdonalds',3,'boss','Dueño',150,'{}','{}')
;
