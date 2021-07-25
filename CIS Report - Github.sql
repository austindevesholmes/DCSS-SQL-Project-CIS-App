--This script was created for the CIS Application. 

SELECT DISTINCT
cl.name AS CalendarName,
p.studentnumber AS 'School District Student ID',
i.lastname AS 'StudentLastName',
i.firstname AS 'Student First Name',
i.middlename AS 'Student Middle Name',
FORMAT((i.birthdate), 'MM-dd-yyyy')  AS 'Student Date of Birth',
p.studentNumber AS 'Dataset ID',
sl.name AS 'School',
e.grade AS 'Grade Level',
i.gender AS 'Gender', 
i.raceEthnicity AS 'Ethnicity',
'State Defined Economically Disadvantaged Status'= '1',
CASE 
	WHEN lep.programstatus = 'LEP' THEN '1' 
	ELSE '0' 
	END AS 'Designated as Limited English Proficient (LEP) ',	
CASE 
	WHEN e.specialedstatus = 'Y' THEN '1' 
	ELSE '0' 
	END AS 'Special Education',
CASE 
	WHEN e.endstatus = 'G' THEN '1' 
	ELSE '0' 
	END AS 'Graduation',
CASE 
	WHEN e.endstatus = 'V'  THEN 'V'
	WHEN e.endstatus = 'H'  THEN 'H'
	WHEN e.endstatus = 'D'  THEN 'D'
	WHEN e.endstatus = 'E'  THEN 'E'
	WHEN e.endstatus = 'I'  THEN 'I'
	WHEN e.endstatus = 'R'  THEN 'R'
	WHEN e.endstatus = 'J'  THEN 'J'
	WHEN e.endstatus = 'X'  THEN 'X'
	WHEN e.endstatus = 'T'  THEN 'T'
	WHEN e.endstatus = 'W'  THEN 'W'
	WHEN e.endstatus = 'K'  THEN 'K'
	WHEN e.endstatus = 'U'  THEN 'U'
	WHEN e.endstatus = '4'  THEN '4'
	WHEN e.endstatus = '5'  THEN '5'
	WHEN e.endstatus = '6'  THEN '6'
	ELSE 'NA' 
	END AS 'Leave Code', 
SUM(tcr.creditsearned) AS 'Course Credits'

FROM p
JOIN i WITH(NOLOCK) ON i.identityID = p.currentidentityID
JOIN e WITH(NOLOCK) ON e.personID = p.personID
JOIN cl WITH(NOLOCK) ON cl.calendarID = e.calendarID
JOIN sl WITH(NOLOCK) ON sl.schoolid = cl.schoolid 
JOIN sy WITH(NOLOCK) ON sy.endyear = e.endyear 
LEFT JOIN ct WITH(NOLOCK) ON ct.personID = p.personID
LEFT JOIN r WITH(NOLOCK) ON r.personID = p.personID
LEFT JOIN se WITH(NOLOCK) ON se.sectionID = r.sectionID
LEFT JOIN c WITH(NOLOCK) ON c.courseID = se.courseID and c.calendarID = cl.calendarID
LEFT JOIN lep WITH(NOLOCK) ON lep.lepid = p.personid 
LEFT JOIN tco WITH(NOLOCK) ON tco.personid = p.personid 
LEFT JOIN tcr WITH(NOLOCK) ON tco.transcriptid = tcr.transcriptid 

WHERE
sy.active = 1 
and e.active = 1
and isnull(e.noshow, 0) = 0
and e.enddate is null


GROUP BY 
cl.name,
p.studentnumber ,
i.lastname,
i.firstname,
i.middlename,
FORMAT((i.birthdate), 'MM-dd-yyyy'),
p.personID,
sl.name,
e.grade, 
i.gender, 
i.raceEthnicity, 
lep.programstatus,
e.specialedstatus,
e.endstatus 

ORDER BY
i.lastname, i.firstname 