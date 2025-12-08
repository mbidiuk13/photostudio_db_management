--отримати повне ім'я вчителя (щоб не писати || у кожному запиті)
CREATE OR REPLACE FUNCTION GetTeacherFullName(p_TeacherID IN NUMBER)
RETURN VARCHAR2 IS
    v_FullName VARCHAR2(150);
BEGIN
    SELECT LASTNAME || ' ' || FIRSTNAME || ' ' || PATRONYMIC
    INTO v_FullName
    FROM TEACHER
    WHERE TEACHERID = p_TeacherID;

    RETURN v_FullName;
END;

--середній бал учня
CREATE OR REPLACE FUNCTION GetStudentAverageGrade(p_StudentID IN NUMBER)
RETURN NUMBER IS
    v_AvgGrade NUMBER(4, 2);
BEGIN
    SELECT AVG(GRADEVALUE)
    INTO v_AvgGrade
    FROM GRADE
    WHERE STUDENTID = p_StudentID;

    RETURN NVL(v_AvgGrade, 0); -- Якщо оцінок немає, поверне 0
END;

--кількість учнів у класі
CREATE OR REPLACE FUNCTION GetClassCount(p_ClassID IN NUMBER)
RETURN NUMBER IS
    v_Count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_Count
    FROM STUDENT
    WHERE CLASSID = p_ClassID;

    RETURN v_Count;
END;

--визначення статусу учня (відмінник, двійочник або хорошист, залежно від середнього балу)
CREATE OR REPLACE FUNCTION GetStudentStatus(p_StudentID IN NUMBER)
RETURN VARCHAR2 IS
    v_Avg NUMBER;
BEGIN
    v_Avg := GetStudentAverageGrade(p_StudentID);

    IF v_Avg >= 10 THEN
        RETURN 'Відмінник';
    ELSIF v_Avg < 4 THEN
        RETURN 'Потребує уваги';
    ELSE
        RETURN 'Звичайний рівень';
    END IF;
END;

--перевірка місткості класів
CREATE OR REPLACE FUNCTION IsRoomEnough(p_ClassID IN NUMBER, p_RoomID IN NUMBER)
RETURN NUMBER IS
    v_Students NUMBER;
    v_Capacity NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_Students
    FROM Student
    WHERE ClassID = p_ClassID;

    SELECT Capacity
    INTO v_Capacity
    FROM Classroom
    WHERE RoomID = p_RoomID;

    IF v_Students <= v_Capacity THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;