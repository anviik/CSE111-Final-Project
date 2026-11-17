-- ===========================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: Cat Shelter Management System
-- Team Members: Anvi Kudaraya, Marisol Lopez Lomeli
-- File: Checkpoint2-script.sql
-- ===========================================================================

-- ===========================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ===========================================================================
-- Modifications:
-- 1. Added: Added bool attribute (in_shelter) on Cats, to help filter cats.
--    1 means the cat is in the shelter, 0 means the cat is fostered.
-- 2. Shifts: added shift_id as the primary key, since the old table didn't have
--    one and we need it to link staff to shifts. Also changed shift_hrs to
--    DECIMAL(4,2) so a 4 hour shift fits.
-- 3. Cats: age is stored in months (kittens are under 12 months).
-- 4. Breeds: fixed a typo, VAR(100) is now VARCHAR(100).
-- 5. Healthrecords: record_number is now an INTEGER, and we added staff_id so we
--    know which staff member logged the record (logsRecord). The vaccine_id in
--    each record is how we track which vaccines a cat got.
-- 6. Added two tables from our ER diagram that we hadn't made yet:
--    ShiftAssignment (which staff work which shifts) and FosterPlacement
--    (which cats go to which fosters, with start and end dates).
-- ===========================================================================

-- ===========================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ===========================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 02: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 03: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 04: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 05: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 06: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 07: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 08: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 09: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 10: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 12: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 13: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 14: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 15: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 16: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 17: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 18: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 19: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 20: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 21: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 22: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 23: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 24: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 25: [Anvi Kudaraya]: 0%, [Marisol Lopez Lomeli]: 100%
-- Statement 26: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 27: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 28: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 29: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- Statement 30: [Anvi Kudaraya]: 100%, [Marisol Lopez Lomeli]: 0%
-- ===========================================================================

-- Ensure SQLite foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Set output format for readability during evaluation
.headers on
.mode column

-- ===========================================================================
-- SECTION 1: SIMPLE STATEMENTS (10 Statements)
-- Focus: Single-table projections/filters, simple inserts/updates/deletes,
-- basic sorting, simple aggregate functions, and pattern matching.
-- ===========================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: Current cats in shelter that are kittens
-- Explanation: Retrieve cat name, cat ID, age, shelter status, to determine which shelter cats are
-- kittens.
-- ----------------------------------------------------------------------------
SELECT cat_id, cat_name, age, in_shelter
FROM Cats
WHERE age < 12 AND in_shelter = 1
ORDER BY cat_id;

-- ----------------------------------------------------------------------------
-- Statement 02: Shelter Cat Count and Weights
-- Explanation: Counts how many cats are in the shelter right now and shows their
-- average, lowest, and highest weight.

-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS cats_in_shelter,
       ROUND(AVG(weight), 2) AS avg_weight,
       MIN(weight) AS min_weight,
       MAX(weight) AS max_weight
FROM Cats
WHERE in_shelter = 1;

-- ----------------------------------------------------------------------------
-- Statement 03: Adding a New Cat to Shelter
-- Explanation: Adding a new cat to the table/database, with all their information.
-- ----------------------------------------------------------------------------
INSERT INTO Cats (cat_id, cat_name, breed_name, age, weight, intake_date, in_shelter)
VALUES (48, 'Pie', 'Balinese', 13, 9.5, '2026-11-10', 1);

-- ----------------------------------------------------------------------------
-- Statement 04: Changing a Staff Phone Number
-- Explanation: Priya Kim (staff 9) got a new phone number, so we update it in
-- her staff record.
-- ----------------------------------------------------------------------------
UPDATE Staff
SET staff_phone = '(209) 555-7788'
WHERE staff_id = 9;

-- ----------------------------------------------------------------------------
-- Statement 05: Updating Amount of Minimum Staff
-- Explanation: Update minimum number of staff needed for area 'B', by doubling it.
-- ----------------------------------------------------------------------------
UPDATE Shifts
SET min_staff = min_staff * 2
WHERE area = 'B';

-- ----------------------------------------------------------------------------
-- Statement 06: Newest Staff Members
-- Explanation: Shows staff hired in 2025 or later, newest first, so we know who
-- still needs training.
-- ----------------------------------------------------------------------------
SELECT staff_id, staff_firstname, staff_lastname, role, hire_date
FROM Staff
WHERE hire_date >= '2025-01-01'
ORDER BY hire_date DESC;

-- ----------------------------------------------------------------------------
-- Statement 07: High Capacity Fosters
-- Explanation: Find the foster names and emails of fosters who have a capacity of 4 cats or more.
-- ----------------------------------------------------------------------------
SELECT foster_firstname, foster_lastname, foster_email, max_capacity
FROM Foster
WHERE max_capacity >= 4;

-- ----------------------------------------------------------------------------
-- Statement 08: Shifts on November 20
-- Explanation: Shows all the shifts on November 20, 2026, sorted by start time,
-- so staff can see the schedule for that day.
-- ----------------------------------------------------------------------------
SELECT shift_id, area, shift_start, shift_end, shift_hrs, min_staff
FROM Shifts
WHERE shift_date = '2026-11-20'
ORDER BY shift_start, area;

-- ----------------------------------------------------------------------------
-- Statement 09: Cats with Shorthair Breeds
-- Explanation: Find all cats whose breed name ends with shorthair.
-- ----------------------------------------------------------------------------
SELECT cat_id, cat_name, breed_name
FROM Cats
WHERE breed_name LIKE '%Shorthair'
ORDER BY breed_name;

-- ----------------------------------------------------------------------------
-- Statement 10: Removing a Cancelled Shift
-- Explanation: Priya Kim can't make her shift on Nov 21 (shift 104), so we take
-- her off of it.
-- ----------------------------------------------------------------------------
DELETE FROM ShiftAssignment
WHERE staff_id = 9 AND shift_id = 104;


-- ===========================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (10 Statements)
-- Focus: Multi-table inner joins, left outer joins, aggregation with GROUP BY
-- and HAVING, scalar subqueries, table aliasing, and conditional updates.
-- ===========================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: Breeds of Medium Sized Cats
-- Explanation: Finding the breeds of medium sized adult cats in the shelter, selecting cats older than
-- 12 months and joining the Breeds and Cats tables.
-- ----------------------------------------------------------------------------
SELECT Cats.breed_name AS Breed,
       cat_name AS Cat
FROM Cats, Breeds
WHERE age >= 12
  AND size = 'medium'
  AND Cats.breed_name = Breeds.breed_name
GROUP BY Cats.breed_name;

-- ----------------------------------------------------------------------------
-- Statement 12: How Many Cats Each Foster Has
-- Explanation: Shows how many cats each foster has right now. We use a LEFT JOIN
-- so fosters with no cats still show up with 0.
-- ----------------------------------------------------------------------------
SELECT f.foster_id, f.foster_firstname, f.foster_lastname, f.max_capacity,
       COUNT(fp.cat_id) AS current_cats
FROM Foster f
LEFT JOIN FosterPlacement fp
       ON fp.foster_id = f.foster_id AND fp.end_date IS NULL
GROUP BY f.foster_id
ORDER BY current_cats DESC, f.foster_id;

-- ----------------------------------------------------------------------------
-- Statement 13: Breeds with 5 or More Cats in the Shelter
-- Explanation: Select cat's breed that have at least 5 cats in the shelter, by counting how many times
-- that breed appears in Cats table.
-- ----------------------------------------------------------------------------
SELECT breed_name AS Breed
FROM Cats
WHERE in_shelter = 1
GROUP BY breed_name
HAVING COUNT(breed_name) >= 5;

-- ----------------------------------------------------------------------------
-- Statement 14: Shifts That Need More Staff
-- Explanation: Finds upcoming shifts (Nov 16 and later) that don't have enough
-- staff signed up yet. The LEFT JOIN keeps shifts that have nobody assigned.
-- ----------------------------------------------------------------------------
SELECT sh.shift_id, sh.shift_date, sh.shift_start, sh.area, sh.min_staff,
       COUNT(sa.staff_id) AS assigned
FROM Shifts sh
LEFT JOIN ShiftAssignment sa ON sa.shift_id = sh.shift_id
WHERE sh.shift_date >= '2026-11-16'
GROUP BY sh.shift_id
HAVING COUNT(sa.staff_id) < sh.min_staff
ORDER BY sh.shift_date, sh.shift_start;

-- ----------------------------------------------------------------------------
-- Statement 15: Cats, Staff, and Fosters with Same Start Date
-- Explanation: Selecting cats, staff, and fosters who all started on the exact same date, after
-- January 01, 2023. Using INNER JOINs to combine the three tables.
-- ----------------------------------------------------------------------------
SELECT c.cat_name AS Cat,
       s.staff_firstname AS Staff,
       f.foster_firstname AS Foster,
       c.intake_date AS Start_Date
FROM Cats c
INNER JOIN Staff s
        ON c.intake_date = s.hire_date
INNER JOIN Foster f
        ON c.intake_date = f.approval_date
WHERE c.intake_date >= '2023-01-01'
ORDER BY c.intake_date;

-- ----------------------------------------------------------------------------
-- Statement 16: Most Used Vaccine
-- Explanation: finding which vaccine has been used the most by counting in how many records it is in.
-- Find the max from those. (INNER JOINs)
-- ----------------------------------------------------------------------------
SELECT COUNT(h.vaccine_id) AS vaccine_cnt, v.vaccine_name
FROM Vaccinations v
INNER JOIN Healthrecords h
        ON v.vaccine_id = h.vaccine_id
GROUP BY v.vaccine_id, v.vaccine_name
HAVING COUNT(h.vaccine_id) = (
    SELECT MAX(vaccine_count)
    FROM (
        SELECT COUNT(h2.vaccine_id) AS vaccine_count
        FROM Vaccinations v2
        INNER JOIN Healthrecords h2
                ON v2.vaccine_id = h2.vaccine_id
        GROUP BY v2.vaccine_id
    ) AS vaccine_totals
);

-- ----------------------------------------------------------------------------
-- Statement 17: Staff Hours in November
-- Explanation: Adds up how many shifts and hours each staff member is working
-- in November 2026.
-- ----------------------------------------------------------------------------
SELECT s.staff_id, s.staff_firstname, s.staff_lastname, s.role,
       COUNT(*) AS num_shifts,
       SUM(sh.shift_hrs) AS total_hours
FROM Staff s
JOIN ShiftAssignment sa ON sa.staff_id = s.staff_id
JOIN Shifts sh          ON sh.shift_id = sa.shift_id
WHERE sh.shift_date BETWEEN '2026-11-01' AND '2026-11-30'
GROUP BY s.staff_id
ORDER BY total_hours DESC;

-- ----------------------------------------------------------------------------
-- Statement 18: Adult Cats Above Average Weight
-- Explanation: Finds adult cats (12+ months) that weigh more than the
-- avg adult cat. A subquery works out the average.
-- ----------------------------------------------------------------------------
SELECT cat_id, cat_name, breed_name, weight,
       (SELECT ROUND(AVG(weight), 2) FROM Cats WHERE age >= 12) AS adult_avg_weight
FROM Cats
WHERE age >= 12
  AND weight > (SELECT AVG(weight) FROM Cats WHERE age >= 12)
ORDER BY weight DESC;

-- ----------------------------------------------------------------------------
-- Statement 19: Cats Seen by a Vet between August and November.
-- Explanation: Finding cats whose health record shows a visit date in between August and November
-- of 2026. Using INNER JOIN to combine Cats and Healthrecords tables.
-- ----------------------------------------------------------------------------
SELECT c.cat_id,
       c.cat_name,
       h.visit_date AS visit_date
FROM Cats c
INNER JOIN Healthrecords h
        ON c.cat_id = h.cat_id
WHERE h.visit_date >= '2026-08-01'
  AND h.visit_date <= '2026-11-31';

-- ----------------------------------------------------------------------------
-- Statement 20: More Room for Experienced Fosters
-- Explanation: Fosters who have finished 4+ placements get their max
-- capacity raised by 1.
-- ----------------------------------------------------------------------------
UPDATE Foster
SET max_capacity = max_capacity + 1
WHERE foster_id IN (
    SELECT foster_id
    FROM FosterPlacement
    WHERE end_date IS NOT NULL
    GROUP BY foster_id
    HAVING COUNT(*) >= 4
);

-- ===========================================================================
-- SECTION 3: COMPLEX STATEMENTS (10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations
-- (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs),
-- window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying,
-- multi-condition triggers, and complex analytics.
-- ===========================================================================

-- ----------------------------------------------------------------------------
-- Statement 21: Breeds with More than 6 Adult Cats
-- Explanation: Finding the breed who have more than 6 cats that are adults, using EXCEPT to filter
-- out the breeds with 6 or fewer adult cats.
-- ----------------------------------------------------------------------------
SELECT DISTINCT c.breed_name
FROM Cats c
WHERE c.age >= 12
EXCEPT
SELECT c.breed_name
FROM Cats c
WHERE c.age >= 12
GROUP BY c.breed_name
HAVING COUNT(c.cat_id) <= 6;

-- ----------------------------------------------------------------------------
-- Statement 22: Average Cat Weight By Breed
-- Explanation: Using CTE(WITH) to calculate avg weight of cats within each breed.
-- ----------------------------------------------------------------------------
WITH breedAverage AS (
    SELECT breed_name,
           AVG(weight) AS ave_weight
    FROM Cats
    GROUP BY breed_name
)
SELECT breed_name,
       ave_weight
FROM breedAverage;

-- ----------------------------------------------------------------------------
-- Statement 23: Cats Who Have Never Been Vaccinated.
-- Explanation: Using NOT EXISTS and a correlated subquery to find
-- which cats do not have any records in the Healthrecords table.
-- ----------------------------------------------------------------------------
SELECT c.cat_id, c.cat_name, c.breed_name
FROM Cats c
WHERE NOT EXISTS (
    SELECT 1
    FROM Healthrecords h
    WHERE h.cat_id = c.cat_id
);

-- ----------------------------------------------------------------------------
-- Statement 24: Pairing Shift Date and Minimum Amount of Staff Needed
-- Explanation: A view containing shift_date and min_staff pairs, for area 'C'.
-- ----------------------------------------------------------------------------
CREATE VIEW IF NOT EXISTS ShiftStaff AS
    SELECT shift_date, min_staff FROM Shifts
    WHERE area = 'C';

-- ----------------------------------------------------------------------------
-- Statement 25: Ranking Fosters by Maximum Capacity
-- Explanation: Using DENSE_RANK() to rank fosters by their max capacity of cats.
-- ----------------------------------------------------------------------------
SELECT foster_id,
       foster_firstname,
       foster_lastname,
       max_capacity,
       DENSE_RANK() OVER (
           ORDER BY max_capacity DESC
       ) AS capacity_rank
FROM Foster;

-- ----------------------------------------------------------------------------
-- Statement 26: Trigger When a Cat Goes to a Foster
-- Explanation: When a cat is placed with a foster, this trigger does two things:
-- marks the cat as not in the shelter anymore, and closes any older placement
-- for that cat that was still open.
-- ----------------------------------------------------------------------------
CREATE TRIGGER IF NOT EXISTS trg_new_foster_placement
AFTER INSERT ON FosterPlacement
WHEN NEW.end_date IS NULL
BEGIN
    UPDATE Cats
    SET in_shelter = 0
    WHERE cat_id = NEW.cat_id;

    UPDATE FosterPlacement
    SET end_date = NEW.start_date
    WHERE cat_id = NEW.cat_id
      AND end_date IS NULL
      AND NOT (foster_id = NEW.foster_id AND start_date = NEW.start_date);
END;

-- ----------------------------------------------------------------------------
-- Statement 27: Sending a Cat to a Foster
-- Explanation: Uses WITH to find the cat that has been in the shelter the longest
-- and has never been fostered, and the foster with the most open spots, then
-- adds that placement. This also sets off the trigger from Statement 26.
-- ----------------------------------------------------------------------------
WITH next_cat AS (
    SELECT c.cat_id
    FROM Cats c
    WHERE c.in_shelter = 1
      AND NOT EXISTS (SELECT 1 FROM FosterPlacement fp WHERE fp.cat_id = c.cat_id)
    ORDER BY c.intake_date, c.cat_id
    LIMIT 1
),
open_spots AS (
    SELECT f.foster_id,
           f.max_capacity - (SELECT COUNT(*) FROM FosterPlacement fp
                             WHERE fp.foster_id = f.foster_id AND fp.end_date IS NULL) AS spots
    FROM Foster f
    ORDER BY spots DESC, f.foster_id
    LIMIT 1
)
INSERT INTO FosterPlacement (cat_id, foster_id, start_date, end_date)
SELECT next_cat.cat_id, open_spots.foster_id, '2026-11-16', NULL
FROM next_cat, open_spots
WHERE open_spots.spots > 0;

-- ----------------------------------------------------------------------------
-- Statement 28: Contact List
-- Explanation: Uses UNION to put staff and fosters into one contact list with
-- their names, phones, and emails.
-- ----------------------------------------------------------------------------
SELECT staff_firstname AS first_name, staff_lastname AS last_name,
       staff_phone AS phone, staff_email AS email, 'Staff - ' || role AS contact_type
FROM Staff
UNION
SELECT foster_firstname, foster_lastname, foster_phone, foster_email, 'Foster Parent'
FROM Foster
ORDER BY contact_type, last_name;

-- ----------------------------------------------------------------------------
-- Statement 29: Latest Health Record for Each Cat
-- Explanation: Uses ROW_NUMBER() to get only the most recent health record for
-- each cat, plus the vaccine they got and who logged it.
-- ----------------------------------------------------------------------------
WITH ranked AS (
    SELECT h.*,
           ROW_NUMBER() OVER (PARTITION BY h.cat_id
                              ORDER BY h.visit_date DESC, h.record_number DESC) AS rn
    FROM Healthrecords h
)
SELECT c.cat_name, r.visit_date, v.vaccine_name, r.health_diagnosis,
       s.staff_firstname || ' ' || s.staff_lastname AS logged_by
FROM ranked r
JOIN Cats c         ON c.cat_id = r.cat_id
JOIN Vaccinations v ON v.vaccine_id = r.vaccine_id
JOIN Staff s        ON s.staff_id = r.staff_id
WHERE r.rn = 1
ORDER BY r.visit_date DESC;

-- ----------------------------------------------------------------------------
-- Statement 30: Where Each Cat Is
-- Explanation: Uses CASE to label each cat as In Shelter or Fostered, and a
-- subquery to show the name of the foster each fostered cat is with.
-- ----------------------------------------------------------------------------
SELECT c.cat_id, c.cat_name, c.intake_date,
       CASE
           WHEN c.in_shelter = 1 THEN 'In Shelter'
           ELSE 'Fostered'
       END AS location,
       (SELECT f.foster_firstname || ' ' || f.foster_lastname
        FROM FosterPlacement fp
        JOIN Foster f ON f.foster_id = fp.foster_id
        WHERE fp.cat_id = c.cat_id AND fp.end_date IS NULL) AS current_foster
FROM Cats c
ORDER BY location, c.cat_name;
