-- Minimal cleanup: Remove all users except admin and guest
SET FOREIGN_KEY_CHECKS=0;

-- 1. Custom table (most important)
DELETE FROM mdl_additional_user_details WHERE userid NOT IN (1, 2);

-- 2. Core user tables
DELETE FROM mdl_user_enrolments WHERE userid NOT IN (1, 2);
DELETE FROM mdl_user_preferences WHERE userid NOT IN (1, 2);
DELETE FROM mdl_user_lastaccess WHERE userid NOT IN (1, 2);

-- 3. Completions and grades
DELETE FROM mdl_course_completions WHERE userid NOT IN (1, 2);
DELETE FROM mdl_course_modules_completion WHERE userid NOT IN (1, 2);
DELETE FROM mdl_grade_grades WHERE userid NOT IN (1, 2);

-- 4. Certificates
DELETE FROM mdl_customcert_issues WHERE userid NOT IN (1, 2);

-- 5. Role assignments
DELETE FROM mdl_role_assignments WHERE userid NOT IN (1, 2);

-- 6. Sessions
DELETE FROM mdl_sessions WHERE userid NOT IN (1, 2);

-- 7. Logs
DELETE FROM mdl_logstore_standard_log WHERE userid NOT IN (1, 2);

-- 8. Files
DELETE FROM mdl_files WHERE userid NOT IN (1, 2);

-- 9. Groups and cohorts
DELETE FROM mdl_cohort_members WHERE userid NOT IN (1, 2);
DELETE FROM mdl_groups_members WHERE userid NOT IN (1, 2);

-- 10. Contexts
DELETE FROM mdl_context WHERE contextlevel = 30 AND instanceid NOT IN (1, 2);

-- 11. Delete users
DELETE FROM mdl_user WHERE id NOT IN (1, 2);

SET FOREIGN_KEY_CHECKS=1;

SELECT '=== Remaining Users ===' as '';
SELECT id, username, firstname, lastname, email FROM mdl_user;

SELECT '=== Counts ===' as '';
SELECT
    (SELECT COUNT(*) FROM mdl_user) as total_users,
    (SELECT COUNT(*) FROM mdl_user_enrolments) as enrolments,
    (SELECT COUNT(*) FROM mdl_additional_user_details) as additional_user_details,
    (SELECT COUNT(*) FROM mdl_course_completions) as completions,
    (SELECT COUNT(*) FROM mdl_customcert_issues) as certificates;
