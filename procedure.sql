--зарахування нового учня (спрощує додавання учня, щоб не писати всі поля вручну)
CREATE OR REPLACE PROCEDURE AddNewStudent(
    p_LastName IN VARCHAR2,
    p_FirstName IN VARCHAR2,
    p_BirthDate IN DATE,
    p_ClassID IN NUMBER
) IS
BEGIN
    INSERT INTO STUDENT (LASTNAME, FIRSTNAME, DATEOFBIRTH, CLASSID)
    VALUES (p_LastName, p_FirstName, p_BirthDate, p_ClassID);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Учня успішно додано.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Помилка при додаванні: ' || SQLERRM);
END;

--переведення учня в інший клас
CREATE OR REPLACE PROCEDURE TransferStudent(
    p_StudentID IN NUMBER,
    p_NewClassID IN NUMBER
) IS
BEGIN
    UPDATE STUDENT
    SET CLASSID = p_NewClassID
    WHERE STUDENTID = p_StudentID;

    COMMIT;
END;

--оновлення контактів вчителя
CREATE OR REPLACE PROCEDURE UpdateTeacherContacts(
    p_TeacherID IN NUMBER,
    p_Phone IN VARCHAR2,
    p_Email IN VARCHAR2
) IS
BEGIN
    UPDATE TEACHER
    SET PHONENUMBER = p_Phone,
        EMAIL = p_Email
    WHERE TEACHERID = p_TeacherID;

    COMMIT;
END;

--відрахування учня
CREATE OR REPLACE PROCEDURE ExpelStudent(
    p_StudentID IN NUMBER
) IS
BEGIN
    DELETE FROM STUDENT WHERE STUDENTID = p_StudentID;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Учня відраховано.');
END;

--виставлення оцінки
CREATE OR REPLACE PROCEDURE AddGrade(
    p_StudentID IN NUMBER,
    p_LessonID IN NUMBER,
    p_Value IN NUMBER,
    p_Comment IN VARCHAR2
) IS
BEGIN
    IF p_Value BETWEEN 1 AND 12 THEN
        INSERT INTO GRADE (GradeValue, GradeComment, StudentID, LessonID)
        VALUES (p_Value, p_Comment, p_StudentID, p_LessonID);
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Помилка: Оцінка має бути від 1 до 12!');
    END IF;
END;