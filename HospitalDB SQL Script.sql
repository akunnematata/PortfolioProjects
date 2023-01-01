CREATE TABLE Patient(
	Patient_ID INT NOT NULL,
	Patient_Name VARCHAR (100),
	Patient_Age INT,
	Patient_Address VARCHAR (100),
	Patient_Gender VARCHAR(100),
	Diagnosis VARCHAR (100)

);

ALTER TABLE Patient 
	ADD doctor_ID INT NOT NULL

ALTER TABLE Patient
ADD constraint Patient_PK
Primary Key (Patient_ID);

CREATE TABLE Doctor (
	Doctor_ID INT NOT NULL,
	Doctor_Name VARCHAR (100),
	Doctor_Age VARCHAR (100),
	Doctor_Gender VARCHAR (100),
	Doctor_Address VARCHAR (100)
	
	CONSTRAINT Doctor_PK Primary Key (Doctor_ID)
	
	)

CREATE TABLE Room (
	Room_No VARCHAR(50) NOT NULL,
	Room_Type VARCHAR (100),
	Room_Status VARCHAR (100)

	CONSTRAINT Home_PK Primary Key (Room_No)

	)


ALTER TABLE Patient 
ADD Constraint Patient_Doc_FK
Foreign Key (doctor_ID) references Doctor(Doctor_ID)


CREATE TABLE Check_IN_OUT(
	Patient_ID INT NOT NULL,
	Room_No VARCHAR(50),
	join_date datetime,
	Leave_date datetime,

	Constraint Patient_IN_FK
	Foreign Key (Patient_ID) references Patient (Patient_ID),

	Constraint ROOM_IN_FK_FK
	Foreign Key (Room_No) references Room (Room_No)


);


INSERT INTO Doctor
Values (1, 'Kayen', 35, 'male', 'California'), 
	(2, 'Michael', 42, 'male', 'California'),
	 (3, 'Bolton', 33, 'male', 'California'),
	  (4, 'Tobias', 30, 'male', 'California'),
	   (5, 'Alora', 36, 'female', 'California');


INSERT INTO Patient
Values (1, 'Drake', 38, 'California','male', 'diabetes', 1), 
(2, 'Donald', 39, 'California','male', 'hypertension', 2),
(3, 'Jay', 47, 'California','male', 'paraplegia', 3),
(4, 'Billie', 36, 'California','female', 'depression', 4),
(5, 'Lupe', 38, 'California','Male', 'alzheimers', 5);

INSERT INTO Room
Values ('1a', 'single', 'occupied'),
('1b', 'single', 'occupied'),
('1c', 'single', 'occupied'),
('1d', 'single', 'occupied'),
('1e', 'single', 'occupied');


INSERT INTO Check_IN_OUT
Values (1, '1a', '2022-10-12 12:00:00', null),
(2, '1b', '2022-10-13 12:10:00', null),
(3, '1c', '2022-10-14 12:30:00', null),
(4, '1d', '2022-10-14 12:58:00', null),
(5, '1e', '2022-10-14 13:48:00', null);


SELECT Patient_Name, Diagnosis, Doctor_Name
From Patient, Doctor
WHERE Patient.Patient_ID = Doctor.Doctor_ID


SELECT Patient.Patient_Name, Patient.Diagnosis, Room.Room_No, Room.Room_Status, Check_IN_OUT.join_date, Check_IN_OUT.Leave_date
FROM Patient, Check_IN_OUT, Room
WHERE Patient.Patient_ID = Check_IN_OUT.Patient_ID
AND Check_IN_OUT.Room_No = Room.Room_No
AND Check_IN_OUT.Leave_date is null 
;
