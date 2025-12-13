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

BEGIN
    -- Додаємо тестового учня в клас з ID=1
    AddNewStudent('Тестовий', 'Учень', TO_DATE('2010-01-01', 'YYYY-MM-DD'), 1);
END;

-- Перевіряємо, чи з'явився він у базі
SELECT * FROM STUDENT
WHERE LASTNAME = 'Тестовий';

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

SELECT StudentID, LastName, ClassID FROM STUDENT WHERE StudentID = 10;

BEGIN
    TransferStudent(10, 5);
END;

SELECT StudentID, LastName, ClassID FROM STUDENT WHERE StudentID = 10;

-- Перевіряємо зміну класу
SELECT STUDENTID, LASTNAME, CLASSID
FROM STUDENT
WHERE STUDENTID = 201;

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

BEGIN
    -- Оновлюємо контакти вчителя з ID=1
    UpdateTeacherContacts(1, '+380991112233', 'new.email@school.com');
END;

-- Перевіряємо зміни
SELECT TEACHERID, LASTNAME, PHONENUMBER, EMAIL
FROM TEACHER
WHERE TEACHERID = 1;

--оновлення контактних даних учня
CREATE OR REPLACE PROCEDURE UpdateStudentContacts(
   p_StudentID IN NUMBER,
   p_Email IN VARCHAR2,
   p_NewPhone IN VARCHAR2
) IS
BEGIN
   UPDATE STUDENT
   SET EMAIL = p_Email,
   PHONENUMBER = p_NewPhone
   WHERE STUDENTID = p_StudentID;

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Контактні дані учня успішно оновлено.');
EXCEPTION
   WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Помилка при оновленні: ' || SQLERRM);
END;

SELECT STUDENTID, LASTNAME, EMAIL, PHONENUMBER FROM STUDENT WHERE STUDENTID = 1;

BEGIN
    UpdateStudentContacts(1, 'love_school@gmail.com', '+380991112233');
END;

SELECT STUDENTID, LASTNAME, EMAIL, PHONENUMBER FROM STUDENT WHERE STUDENTID = 1;

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

BEGIN
    -- Ставимо оцінку 10 учню з ID=1 за урок з ID=1
    AddGrade(1, 1, 10, 'Відмінна робота на уроці');
END;

-- Дивимось останню додану оцінку
SELECT * FROM GRADE
ORDER BY GRADEID DESC
FETCH FIRST 1 ROWS ONLY;