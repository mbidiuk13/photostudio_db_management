-- Прискорює з'єднання студентів з класами
CREATE INDEX IDX_Student_ClassFK ON Student(ClassID);

-- Прискорює пошук оцінок конкретного студента
CREATE INDEX IDX_Grade_StudentFK ON Grade(StudentID);

-- Прискорює пошук розкладу для вчителя
CREATE INDEX IDX_Schedule_TeacherFK ON Schedule(TeacherID);

-- Прискорює пошук уроків для розкладу
CREATE INDEX IDX_Lesson_ScheduleFK ON Lesson(ScheduleID);

-- Швидкий пошук учня за прізвищем (адже ми часто сортуємо за LastName)
CREATE INDEX IDX_Student_LastName ON Student(LastName);

-- Швидкий пошук вчителя за прізвищем
CREATE INDEX IDX_Teacher_LastName ON Teacher(LastName);

-- Швидкий пошук уроків за темою (для звітів)
CREATE INDEX IDX_Lesson_Topic ON Lesson(Topic);

-- Найчастіший запит до розкладу: "Які уроки у 10-А класі в Понеділок?"
-- Цей індекс прискорить фільтрацію WHERE ClassID = X AND DayOfWeek = Y
CREATE INDEX IDX_Schedule_ClassDay ON Schedule(ClassID, DayOfWeek);

-- Для журналу: пошук оцінок учня за конкретним предметом (через урок)
-- Хоча LessonID є в Grade, іноді корисно мати комбінацію для аналітики
CREATE INDEX IDX_Grade_StudentDate ON Grade(StudentID, GradeDate);

-- Індекс, який зберігає прізвища вже в нижньому регістрі
CREATE INDEX IDX_Student_LowerName ON Student(LOWER(LastName));


SELECT /*+ NO_INDEX(STUDENT IDX_STUDENT_LASTNAME) */ *
FROM STUDENT
WHERE LASTNAME = 'Коваленко';

SELECT /*+ INDEX(STUDENT IDX_STUDENT_LASTNAME) */ *
FROM STUDENT
WHERE LASTNAME = 'Коваленко';


SELECT /*+ NO_INDEX(GRADE) */ *
FROM GRADE
WHERE STUDENTID = 1;

SELECT /*+ INDEX(GRADE IDX_GRADE_STUDENTFK) */ *
FROM GRADE
WHERE STUDENTID = 1;


SELECT /*+ NO_INDEX(SCHEDULE) */ *
FROM SCHEDULE
WHERE CLASSID = 1
  AND DAYOFWEEK = 1;

SELECT /*+ INDEX(SCHEDULE IDX_SCHEDULE_SEARCH) */ *
FROM SCHEDULE
WHERE CLASSID = 1
  AND DAYOFWEEK = 1;
