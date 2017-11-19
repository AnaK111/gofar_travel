-- Asignatura   	:  Administración de Base de Datos Avanzada
-- Taller       	:  Assigments 1
-- Estudiantes  	:  Sebastián Alejandro Arias Mejia
--                 	   Ana Karina Largo Ramos

-- ********************************( 2 )****************************************

-- 2.  Create 3 tablespaces (0.2):
--  a. First one with 1 Gb and 3 datafiles, tablespace should be named
--     "hospital_bills".
--  b. Second one with 500 Mb and 1 datafile, named "test_purposes".
--  c. Undo tablespace with 5Mb of space and 1 datafile.

-- Solution 2:

-- a. First one with 1 Gb and 3 datafiles, tablespace should be named "hospital_bills"

CREATE TABLESPACE hospital_bills DATAFILE
'hospital_bills_df1' SIZE 500M,
'hospital_bills_df2' SIZE 400M,
'hospital_bills_df3' SIZE 124M
EXTENT MANAGEMENT LOCAL 
SEGMENT SPACE MANAGEMENT AUTO;

-- b. Second one with 500 Mb and 1 datafile, named "test_purposes".

CREATE TABLESPACE test_purposes DATAFILE
'test_purposes1' SIZE 500M
EXTENT MANAGEMENT LOCAL 
SEGMENT SPACE MANAGEMENT AUTO;

-- c. Undo tablespace with 5Mb of space and 1 datafile.

CREATE UNDO TABLESPACE Undo_Tbs DATAFILE
 'Undo_Tbs1.dbf' SIZE 5M
AUTOEXTEND OFF;

-- ********************************( 3 )****************************************

-- 3. Set the undo tablespace to be used in the system (0.2)

-- Solution 3:

ALTER SYSTEM SET UNDO_TABLESPACE = Undo_tbs scope = both;

-- ********************************( 4 )****************************************

-- 4. Create a DBA user and assign it to the tablespace called "hospital_bills",
--    this user has unlimited space on the tablespace (0.2)

-- Solution 4:

CREATE USER DBA_USER IDENTIFIED BY DBA_USER_123
DEFAULT TABLESPACE hospital_bills
QUOTA UNLIMITED ON hospital_bills;

-- ********************************( 5 )****************************************

-- 5. Assign the dba role and permissions to connect to the user just created(0.2)

-- Solution 5:

-- Assign the dba role (GRANT DBA TO DBA_USER;)
-- Assign permissions to connect to the user (GRANT CONNECT, RESOURCE TO DBA_USER)
GRANT CONNECT, RESOURCE, DBA TO DBA_USER;

-- ********************************( 6 )****************************************

-- 6. Create 3 profiles. (0.2)
--  a. Profile 1: "manager " password life 40 days, one session per user, 
--     15 minutes idle, 4 failed login attempts.
--  b. Profile 2: "finance " password life 15 days, one session per user, 
--     3 minutes idle, 2 failed login attempts.
--  c. Profile 3: "development " password life 100 days, two session per user, 
--     30 minutes idle, no failed login attempts.

-- Solution 6:

--  a. Profile 1: "manager " password life 40 days, one session per user, 
--     15 minutes idle, 4 failed login attempts.

CREATE PROFILE manager_profile LIMIT
    PASSWORD_LIFE_TIME     40
    SESSIONS_PER_USER      1 
    IDLE_TIME              15 
    FAILED_LOGIN_ATTEMPTS  4 ; 

--  b. Profile 2: "finance " password life 15 days, one session per user, 
--     3 minutes idle, 2 failed login attempts.

CREATE PROFILE fince_profile LIMIT
    PASSWORD_LIFE_TIME     15
    SESSIONS_PER_USER      1 
    IDLE_TIME              3 
    FAILED_LOGIN_ATTEMPTS  2 ;
    
--  c. Profile 3: "development " password life 100 days, two session per user, 
--     30 minutes idle, no failed login attempts.

CREATE PROFILE development_profile LIMIT
    PASSWORD_LIFE_TIME     100
    SESSIONS_PER_USER      2 
    IDLE_TIME              30 
    FAILED_LOGIN_ATTEMPTS  UNLIMITED;
    
-- ********************************( 7 )****************************************
    
-- 7. Create 4 users, assign them the tablespace "hospital_bills"; profiles 
--    created should be used for the users, all the users should be allow to 
--    connect to the database. (0.2)

-- Solution 7:

-- Create 4 users, assign them the tablespace "hospital_bills"; profiles 
-- created should be used for the users.
CREATE USER User_1
IDENTIFIED BY User1_123
DEFAULT tablespace hospital_bills
PROFILE manager_profile;

CREATE USER User_2
IDENTIFIED BY User2_123
DEFAULT tablespace hospital_bills
PROFILE fince_profile;

CREATE USER User_3
IDENTIFIED BY User3_123
DEFAULT tablespace hospital_bills
PROFILE  development_profile ;

CREATE USER User_4
IDENTIFIED BY User4_123
DEFAULT tablespace hospital_bills
PROFILE  development_profile ;

-- All the users should be allow to connect to the database.
GRANT CREATE SESSION TO  
 User_1, User_2,  User_3,  User_4;
 
-- ********************************( 8 )****************************************
 
-- 8.Lock the users associate with profiles: manager and finance . (0.2)

-- Manager
ALTER USER User_1
ACCOUNT LOCK ;  

-- Finance
ALTER USER User_2
ACCOUNT LOCK ;


-- ********************************( 9 )****************************************

-- 9. Delete the tablespace called "test_purposes " (0.2)

-- Solution 9:

DROP TABLESPACE test_purposes;

-- DROP TABLESPACE test_purposes 
-- INCLUDING CONTENTS AND DATAFILES ;


-- ********************************( 10 )****************************************
 
-- 10. Create tables with its columns according to your normalization.Create sequences 
--    for every primary key. Create primary and foreign keys. Insert at least 10 patients, 5
--    cost centers, items for each cost center (2 or 3) (Go to http://www.generatedata.com/). 
--    This should be a functional single script (.sql) (Better if you generate sql through
--    sql developer).

-- Solution 10:

-- Create tables with its columns according to your normalization. 
-- Create primary and foreign keys

create table cost_centers(
id number not null,
cost_code number not null, 
cost_name varchar2(200) not null, 
CONSTRAINT PK_id_cost_centers PRIMARY KEY(id));

create table items (
id number not null,
item_code number unique not null,
description varchar2(200) not null,
chargue decimal not null,
cost_centers_id number not null,
CONSTRAINT PK_id_items PRIMARY KEY(id),
CONSTRAINT FK_cost_centers_id FOREIGN KEY (cost_centers_id) REFERENCES cost_centers(id));

create table states (
id number not null,
state_name varchar2(200) not null, 
CONSTRAINT PK_id_states PRIMARY KEY(id));

create table cities (
id number not null,
city varchar2(200) not null, 
zip varchar2(50) unique not null,
states_id number not null,
CONSTRAINT PK_id_cities PRIMARY KEY(id),
CONSTRAINT FK_states_id FOREIGN KEY (states_id) REFERENCES states(id));

create table patients(
id number not null, 
patient_number number unique not null, 
patient_name varchar2(200) not null,
patient_address varchar2(200)not null,
cities_id number(20) not null,
CONSTRAINT PK_id_patients PRIMARY KEY(id),
CONSTRAINT FK_cities_id FOREIGN KEY (cities_id) REFERENCES cities(id));

create table bills (
id number not null,
dates varchar2(10) not null, 
date_admitted varchar2(10) not null,
dischargue_date varchar2(10) not null,
balance_due decimal not null,
patients_id number not null,
CONSTRAINT PK_id_bills PRIMARY KEY(id),
CONSTRAINT FK_patients_id FOREIGN KEY (patients_id) REFERENCES patients(id));

create table bill_details(
id number not null,
date_charge varchar2(50) not null,
bills_id number not null,
items_id number not null,
CONSTRAINT PK_id_bill_details PRIMARY KEY(id),
CONSTRAINT FK_bills_id FOREIGN KEY (bills_id) REFERENCES bills(id),
CONSTRAINT FK_items_id FOREIGN KEY (items_id) REFERENCES items(id));

-- -- Create sequences for every primary key

CREATE SEQUENCE id_bill_details
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE id_cost_centers
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE id_items
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE id_bills
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE id_states
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE id_cities
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE id_patients
INCREMENT BY 1
START WITH 1;

-- Insert at least 10 patients, 5 cost centers, items for each cost center (2 or 3)

--Insert STATES
INSERT INTO STATES VALUES (id_states.nextval, 'Antioquia');
INSERT INTO STATES VALUES (id_states.nextval, 'Cundinamarca');
INSERT INTO STATES VALUES (id_states.nextval, 'Atlántico');

--Insert CITIES
INSERT INTO CITIES VALUES (id_cities.nextval, 'Medellin','0001',1);
INSERT INTO CITIES VALUES (id_Cities.nextval, 'Bógota','0002',2);
INSERT INTO CITIES VALUES (id_Cities.nextval, 'Barranquilla','0003',3);

--Insert PATIENTS
INSERT INTO PATIENTS VALUES (id_patients.nextval, 1,'Paciente 1','Calle 1',1);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 2,'Paciente 2','Calle 2',2);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 3,'Paciente 3','Calle 3',3);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 4,'Paciente 4','Calle 4',1);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 5,'Paciente 5','Calle 5',2);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 6,'Paciente 6','Calle 6',3);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 7,'Paciente 7','Calle 7',1);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 8,'Paciente 8','Calle 8',2);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 9,'Paciente 9','Calle 9',3);
INSERT INTO PATIENTS VALUES (id_patients.nextval, 10,'Paciente 10','Calle 10',1);

--Insert COST_CENTERS
INSERT INTO COST_CENTERS VALUES (id_cost_centers.nextval, 1,'Room');
INSERT INTO COST_CENTERS VALUES (id_cost_centers.nextval, 2,'Laboratory');
INSERT INTO COST_CENTERS VALUES (id_cost_centers.nextval, 3,'Radiology');
INSERT INTO COST_CENTERS VALUES (id_cost_centers.nextval, 4,'Centro Costo 4');
INSERT INTO COST_CENTERS VALUES (id_cost_centers.nextval, 5,'Centro Costo 5');


--Insert ITEMS
INSERT INTO ITEMS VALUES (id_items.nextval, 1,'Item 1',1001,1);
INSERT INTO ITEMS VALUES (id_items.nextval, 2,'Item 2',1002,1);
INSERT INTO ITEMS VALUES (id_items.nextval, 3,'Item 3',2001,2);
INSERT INTO ITEMS VALUES (id_items.nextval, 4,'Item 4',2002,2);
INSERT INTO ITEMS VALUES (id_items.nextval, 5,'Item 5',3001,3);
INSERT INTO ITEMS VALUES (id_items.nextval, 6,'Item 6',3002,3);
INSERT INTO ITEMS VALUES (id_items.nextval, 7,'Item 7',4001,4);
INSERT INTO ITEMS VALUES (id_items.nextval, 8,'Item 8',4002,4);
INSERT INTO ITEMS VALUES (id_items.nextval, 9,'Item 9',5001,5);
INSERT INTO ITEMS VALUES (id_items.nextval, 10,'Item 10',5002,5);

--Insert BILLS (formato fechas aaaammdd)
INSERT INTO BILLS VALUES (id_bills.nextval, '20170101','20170102','20170103',1001,1);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170201','20170202','20170203',2003,2);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170301','20170302','20170303',2001,3);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170401','20170402','20170403',8005,4);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170501','20170502','20170503',4001,5);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170601','20170602','20170603',9003,6);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170701','20170702','20170703',5002,7);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170801','20170802','20170803',2003,8);
INSERT INTO BILLS VALUES (id_bills.nextval, '20170901','20170902','20170903',4003,9);
INSERT INTO BILLS VALUES (id_bills.nextval, '20171001','20171002','20171003',3001,10);

--Insert BILL_DETAILS (formato fechas aaaammdd)
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170102',1,1);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170202',2,1);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170202',2,2);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170302',3,3);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170402',4,4);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170402',4,5);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170402',4,6);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170502',5,7);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170602',6,8);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170602',6,9);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170702',7,10);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170802',8,1);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170802',8,2);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170902',9,3);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170902',9,4);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20171002',10,5);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20171003',1,1);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20171004',1,1);

-- Ver tablas
SELECT * FROM STATES;
SELECT * FROM BILL_DETAILS;
SELECT * FROM CITIES;
SELECT * FROM PATIENTS;
SELECT * FROM COST_CENTERS;
SELECT * FROM ITEMS;
SELECT * FROM BILLS;
SELECT * FROM BILL_DETAILS ;



-- *****************************************************************************

-- Asignatura   	:  Administración de Base de Datos Avanzada
-- Taller       	:  Assigments 2
-- Estudiantes  	:  Sebastián Alejandro Arias Mejia
--                 	   Ana Karina Largo Ramos

-- ********************************( 3 )****************************************

-- 3. Create a view to display the information of the bill (patient, patient_name, 
--    patient_address, date, total, total_room_board) which has the highest 
--    balance due for the 'Room & board' cost center. (0.5)

-- Solution 3:

CREATE OR REPLACE VIEW INFORMATION_OF_BILL AS
SELECT  PATIENTS.PATIENT_NUMBER,
        PATIENTS.PATIENT_NAME,
        PATIENTS.PATIENT_ADDRESS,
        BILLS.DATES, 
        SUM(ITEMS.CHARGUE) AS TOTAL,
        (
        SELECT     MAX(SUM(ITEMS.CHARGUE)) AS TOTAL_ROOM_BOARD
            FROM        ITEMS 
            INNER JOIN  COST_CENTERS
            ON          ITEMS.COST_CENTERS_ID     =  COST_CENTERS.ID          
            INNER JOIN  BILL_DETAILS
            ON          ITEMS.ID   =   BILL_DETAILS.ITEMS_ID
            INNER JOIN  BILLS 
            ON          BILL_DETAILS.BILLS_ID           =   BILLS.ID 
            INNER JOIN  PATIENTS
            ON          BILLS.PATIENTS_ID               =   PATIENTS.ID
            WHERE       COST_CENTERS.COST_NAME          =   'Room'
            GROUP BY    BILLS.ID, COST_CENTERS.COST_NAME
        ) AS TOTAL_ROOM_BOARD
FROM    ITEMS 
        INNER JOIN  COST_CENTERS
        ON          ITEMS.COST_CENTERS_ID     =  COST_CENTERS.ID          
        INNER JOIN  BILL_DETAILS
        ON          ITEMS.ID   =   BILL_DETAILS.ITEMS_ID
        INNER JOIN  BILLS 
        ON          BILL_DETAILS.BILLS_ID     =   BILLS.ID 
        INNER JOIN  PATIENTS
        ON          BILLS.PATIENTS_ID         =   PATIENTS.ID
        WHERE       ITEMS.CHARGUE             =   (
            SELECT     MAX(SUM(ITEMS.CHARGUE)) AS TOTAL_ROOM_BOARD
            FROM        ITEMS 
            INNER JOIN  COST_CENTERS
            ON          ITEMS.COST_CENTERS_ID     =  COST_CENTERS.ID          
            INNER JOIN  BILL_DETAILS
            ON          ITEMS.ID   =   BILL_DETAILS.ITEMS_ID
            INNER JOIN  BILLS 
            ON          BILL_DETAILS.BILLS_ID           =   BILLS.ID 
            INNER JOIN  PATIENTS
            ON          BILLS.PATIENTS_ID               =   PATIENTS.ID
            WHERE       COST_CENTERS.COST_NAME          =   'Room'
            GROUP BY    BILLS.ID, COST_CENTERS.COST_NAME) 
        AND COST_CENTERS.COST_NAME          =   'Room'
GROUP BY PATIENTS.PATIENT_NUMBER,
         PATIENTS.PATIENT_NAME,
         PATIENTS.PATIENT_ADDRESS,
         BILLS.DATES;

-- ********************************( 4 )****************************************

-- 4. Create two functions, the first one which receives 2 params: 
-- (cost_center_id, bill_id) and return the total balance for all items which 
-- belongs to the cost center and associated to a bill. The second one also 
-- receives 2 params (cost_center_id, bill_id) and return the total of number of
-- items associated to a bill which belongs to the cost center (0.5)

-- Solution 4:

-- F1: cost_center_id, bill_id) and return the total balance for all items which 
-- belongs to the cost center and associated to a bill.

CREATE OR REPLACE FUNCTION TOTAL_BALANCE_FOR_ITEMS (VALUE1 in integer, VALUE2 in integer)
RETURN NUMBER IS
TOTAL NUMBER;
BEGIN  
     SELECT SUM(ITEMS.CHARGUE) AS "TOTAL BALANCE FOR ALL ITEMS" INTO TOTAL
            FROM        ITEMS
            INNER JOIN  COST_CENTERS
            ON          ITEMS.COST_CENTERS_ID       =   COST_CENTERS.ID
            INNER JOIN  BILL_DETAILS
            ON          ITEMS.ID                    =   BILL_DETAILS.ITEMS_ID
            INNER JOIN  BILLS 
            ON          BILL_DETAILS.BILLS_ID       =   BILLS.ID
            INNER JOIN  PATIENTS 
            ON          BILLS.PATIENTS_ID           =   PATIENTS.ID
            WHERE       COST_CENTERS.ID             =   VALUE1    
                        AND    BILLS.ID             =   VALUE2; 
RETURN TOTAL;
END;
            
SELECT  TOTAL_BALANCE_FOR_ITEMS (&cost_center_id,&bill_id) 
        AS "TOTAL BALANCE FOR ALL ITEMS" FROM dual;      
 
        
-- F2: (cost_center_id, bill_id) and return the total of number of items associated 
--  to a bill which belongs to the cost center

CREATE OR REPLACE FUNCTION TOTAL_OF_NUMBER_OF_ITEMS 
(VALUE1 in integer, VALUE2 in integer)
RETURN NUMBER IS 
TOTAL NUMBER;
BEGIN  
     SELECT COUNT(ITEMS.CHARGUE) AS "TOTAL NUMBER OF ITEMS" INTO TOTAL
            FROM        ITEMS
            INNER JOIN  COST_CENTERS
            ON          ITEMS.COST_CENTERS_ID       =   COST_CENTERS.ID
            INNER JOIN  BILL_DETAILS
            ON          ITEMS.ID                    =   BILL_DETAILS.ITEMS_ID
            INNER JOIN  BILLS 
            ON          BILL_DETAILS.BILLS_ID       =   BILLS.ID
            INNER JOIN  PATIENTS 
            ON          BILLS.PATIENTS_ID           =   PATIENTS.ID
            WHERE       COST_CENTERS.ID             =   VALUE1    
                        AND    BILLS.ID             =   VALUE2; 
RETURN TOTAL;
END;
            
SELECT  TOTAL_OF_NUMBER_OF_ITEMS  (&cost_center_id,&bill_id) 
        AS "TOTAL OF NUMBER OF ITEMS " FROM dual;  

-- ********************************( 5 )****************************************

-- 5. Create a view to display the information of the bills patient, patient_name,
--  patient_address, date, date_admitted, discharge_date, total_items_room_board,
--  balance_room_and_board, total_items_laboratory, balance_laboratory, 
--  total_items_radiology, balance_radiology. Use the functions created in the 
--  previous step (0.5)

-- Solution 5:

CREATE OR REPLACE VIEW INFO_OF_THE_BILLS_PATIENTS AS
SELECT  DISTINCT 
        PATIENTS.PATIENT_NUMBER,
        PATIENTS.PATIENT_NAME,
        PATIENTS.PATIENT_ADDRESS,
        BILLS.DATE_ADMITTED,
        BILLS.DISCHARGUE_DATE,    
        -- (cost_center_id, bill_id) Valores quemados
        (select TOTAL_BALANCE_FOR_ITEMS ('1','1') FROM dual) TOTAL_BALANCE_ROOM_BOARD ,
        (select TOTAL_OF_NUMBER_OF_ITEMS('1','1') from dual) TOTAL_ITEMS_ROOM_BOARD ,
        (select TOTAL_BALANCE_FOR_ITEMS('2','1') FROM dual) TOTAL_BALANCE_LABORATORY,
        (select TOTAL_OF_NUMBER_OF_ITEMS('2','1') from dual) TOTAL_ITEMS_LABORATORY,
        (select TOTAL_BALANCE_FOR_ITEMS('3','1') FROM dual) TOTAL_BALANCE_RADIOLOGY,
        (select TOTAL_OF_NUMBER_OF_ITEMS('3','1') from dual) TOTAL_ITEMS_RADIOLOGY           
FROM        ITEMS
INNER JOIN  COST_CENTERS
ON          COST_CENTERS.ID         =       ITEMS.COST_CENTERS_ID
INNER JOIN  BILL_DETAILS
ON          ITEMS.ID                =       BILL_DETAILS.ITEMS_ID
INNER JOIN  BILLS
ON          BILL_DETAILS.BILLS_ID   =       BILLS.ID
INNER JOIN  PATIENTS 
ON          BILLS.PATIENTS_ID       =       PATIENTS.ID
WHERE       BILLS.PATIENTS_ID       =       PATIENTS.ID AND BILLS.ID = 1
ORDER BY    PATIENTS.PATIENT_NUMBER;

SELECT * FROM INFO_OF_THE_BILLS_PATIENTS;


-- ********************************( 6 )****************************************

-- 6. Create the explain plan for the last step (add a screenshot or copy and paste 
--  the information returned (0.5)

-- Solution 6: 

-- Ver imagen Explain_Plan_6
SELECT * FROM INFO_OF_THE_BILLS_PATIENTS;


-- ********************************( 7 )****************************************

-- 7. The product owner has requested a change, they want to handle some sort of 
--  inventory for items which belongs to each cost center, the table where you
--  store those items should have a column "units_available" or "unidades_disponibles" 
--  (if you made the diagram in spanish). (0.5)

-- Solution 7:

ALTER TABLE ITEMS
  ADD UNITS_AVAILABLE number(12) default 500;
  
SELECT * FROM ITEMS;

-- ********************************( 8 )****************************************

-- 8. Create a trigger which decreases the number of units available when an item
--  is associated to a bill.(0.5)


CREATE OR REPLACE TRIGGER UPDATES_UNITS_AVAILABLE 
BEFORE INSERT OR UPDATE OF ITEMS_ID ON BILL_DETAILS FOR EACH ROW
DECLARE
   ITEMS_AVAILABLES_NEW NUMBER;
   ITEMS_AVAILABLES_OLD NUMBER;
BEGIN
   IF (:old.ITEMS_ID IS NULL) THEN
    ITEMS_AVAILABLES_OLD := 0;
   ELSE
    --cantidad disponible de items viejos
    SELECT  UNITS_AVAILABLE 
    INTO    ITEMS_AVAILABLES_OLD 
    FROM    ITEMS WHERE ID  =   :old.ITEMS_ID;
   END IF;
  --cantidad disponible de items nuevos
  SELECT    UNITS_AVAILABLE 
  INTO      ITEMS_AVAILABLES_NEW 
  FROM      ITEMS 
  WHERE     ID  = :new.ITEMS_ID; 
  --verifica la existencia de unidades disponibles
  IF (ITEMS_AVAILABLES_NEW > 0) THEN
    --verifica si se esta realizando una actualización
    IF (:old.ITEMS_ID != :new.ITEMS_ID) THEN
      UPDATE    ITEMS 
      SET       UNITS_AVAILABLE = (ITEMS_AVAILABLES_OLD + 1) 
      WHERE     ID  = :old.ITEMS_ID;
    END IF;
    UPDATE  ITEMS 
    SET     UNITS_AVAILABLE = (ITEMS_AVAILABLES_NEW - 1) 
    WHERE   ID = :new.ITEMS_ID;
  ELSE
    DBMS_OUTPUT.PUT_LINE('No hay unidades disponibles');
  END IF;
END;

INSERT INTO ITEMS VALUES (id_items.nextval, 90,'Item 90',1000,1,500);
INSERT INTO BILL_DETAILS VALUES (id_bill_details.nextval, '20170102',12,13);


-- ********************************( 9 )****************************************


-- 9. Create a procedure to increase the cost of each item as follows (0.5) :
-- ? If the item belongs to Room & board cost center: 2%
-- ? If the item belongs to Laboratory: 3.5%
-- ? If the item belongs to Radiology: 4%

-- Solution 9:

CREATE OR REPLACE PROCEDURE INCREASE_THE_COST AS
begin
declare 
    --Cursor con la sentencia a consultar
    cursor Lista_Items is select id, Chargue, Cost_Centers_id from ITEMS where Cost_Centers_id in (1, 2, 3);
    --Variables
    id_item number;
    Chargue decimal(10,3);
    id_cost_center number;
    increment_charge decimal(10,3);
begin
    --Room         con id = 1
    --Laboratory   con id = 2
    --Radiology    con id = 3
    --Se inicia el cursor
    open Lista_Items;
    --Se obtiene la primera fila del resultado
    fetch Lista_Items into id_item,Chargue,id_cost_center;
    --Preguntamos si el registro obtenido es valido
    while Lista_Items%FOUND
    loop
        case id_cost_center
            when 1 then increment_charge := (Chargue * 1.02);           
            when 2 then increment_charge := (Chargue * 1.035);
            when 3 then increment_charge := (Chargue * 1.04);      
            else dbms_output.put_line('producto: ' || id_item || ' centro costos: ' || id_cost_center);
        end case;
        --Se verifica que el item pertenece al centro de costos indicado
        if((id_cost_center > 0) and (id_cost_center < 4)) then
          update ITEMS set Chargue = increment_charge where id = id_item and cost_centers_id = id_cost_center;
        end if;
        fetch Lista_Items into id_item,Chargue,id_cost_center; 
    end loop;   
    close Lista_Items;
end;
end;

SELECT * FROM ITEMS;





         

            











