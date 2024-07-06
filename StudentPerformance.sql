-- Overall view of table
SELECT * FROM StudentPerformance;

-- (1) Generally, what is the amount of students in each grade class?

SELECT Count(StudentID) as StudentCount, 
CASE GradeClass
	WHEN 0 THEN 'A'
    WHEN 1 THEN 'B'
    WHEN 2 THEN 'C'
    WHEN 3 THEN 'D'
    WHEN 4 THEN 'F'
END AS GradeClass
FROM StudentPerformance
GROUP BY GradeClass
ORDER BY StudentCount;

-- (2) How does study time relate to a student's GPA?

SELECT StudyTimeWeeklyRanges, AVG(GPA) as AverageGPA
FROM(

SELECT StudyTimeWeekly, GPA,
CASE
	WHEN StudyTimeWeekly >=0 AND StudyTimeWeekly <= 5 THEN '0-5'
    WHEN StudyTimeWeekly >5 AND StudyTimeWeekly <=10 THEN '5-10'
    WHEN StudyTimeWeekly >10 AND StudyTimeWeekly <=15 THEN '10-15'
    WHEN StudyTimeWeekly >15 AND StudyTimeWeekly <=20 THEN '15-20'
END AS StudyTimeWeeklyRanges
FROM StudentPerformance) as StudyRanges

GROUP BY StudyTimeWeeklyRanges
ORDER BY StudyTimeWeeklyRanges;

-- (3) Does the education level of the parents affect parents' expectations of the student, and therefore, performance? 

SELECT 

CASE ParentalEducation
	WHEN 0 then 'No Education'
    WHEN 1 then 'High School'
    WHEN 2 then 'Some College'
    WHEN 3 then 'Bachelors'
    WHEN 4 then 'Masters'
END AS ParentEducationLevel, AVG(GPA) as AverageGPA

FROM StudentPerformance
GROUP BY ParentalEducation
ORDER BY ParentalEducation;

-- (4) When a student is tutored, does it reflect in their GPA?

SELECT 

CASE Tutoring
	WHEN 1 then 'Tutored'
    WHEN 0 then 'Not Tutored'
END AS TutoringStatus, AVG(GPA) as AverageGPA

FROM StudentPerformance
GROUP BY TutoringStatus;

-- (5) How much does a student's level of involvement impact their grade classification?

SELECT StudentInvolvementLevel, AVG(GPA) as AverageGPA 
FROM(

SELECT
CASE 
	WHEN SUM(Extracurricular + Sports + Music + Volunteering) =0 THEN 'Not Involved'
	WHEN SUM(Extracurricular + Sports + Music + Volunteering) >=1 AND SUM(Extracurricular + Sports + Music + Volunteering) <2 THEN 'Somewhat Involved'
    WHEN SUM(Extracurricular + Sports + Music + Volunteering) >=2 THEN 'Involved'
END AS StudentInvolvementLevel, GPA
FROM StudentPerformance
GROUP BY GPA) 
as StudentInvolvement
GROUP BY StudentInvolvementLevel
ORDER BY AverageGPA desc;