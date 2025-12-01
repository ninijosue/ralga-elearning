-- Cleanup Script: Remove all users except admin (ID=2) and guest (ID=1)
-- This will delete all user data from Moodle tables and custom tables
-- Safe version with error handling

SET FOREIGN_KEY_CHECKS=0;

-- 1. Delete from custom additional_user_details table
DELETE FROM mdl_additional_user_details WHERE userid NOT IN (1, 2);

-- 2. Delete user enrolments
DELETE FROM mdl_user_enrolments WHERE userid NOT IN (1, 2);

-- 3. Delete course completions
DELETE FROM mdl_course_completions WHERE userid NOT IN (1, 2);

-- 4. Delete grade grades
DELETE FROM mdl_grade_grades WHERE userid NOT IN (1, 2);

-- 5. Delete user preferences
DELETE FROM mdl_user_preferences WHERE userid NOT IN (1, 2);

-- 6. Delete user info data (if exists)
DELETE FROM mdl_user_info_data WHERE userid NOT IN (1, 2);

-- 7. Delete user last access
DELETE FROM mdl_user_lastaccess WHERE userid NOT IN (1, 2);

-- 8. Delete custom certificate issues (if table exists)
DELETE FROM mdl_customcert_issues WHERE userid NOT IN (1, 2);

-- 9. Delete quiz attempts
DELETE FROM mdl_quiz_attempts WHERE userid NOT IN (1, 2);

-- 10. Delete assignment submissions
DELETE FROM mdl_assign_submission WHERE userid NOT IN (1, 2);
DELETE FROM mdl_assign_grades WHERE userid NOT IN (1, 2);

-- 11. Delete forum posts and discussions
DELETE FROM mdl_forum_posts WHERE userid NOT IN (1, 2);
DELETE FROM mdl_forum_discussions WHERE userid NOT IN (1, 2);

-- 12. Delete message data
DELETE FROM mdl_message_conversation_members WHERE userid NOT IN (1, 2);
DELETE FROM mdl_messages WHERE useridfrom NOT IN (1, 2);
DELETE FROM mdl_message_user_actions WHERE userid NOT IN (1, 2);

-- 13. Delete badges issued
DELETE FROM mdl_badge_issued WHERE userid NOT IN (1, 2);

-- 14. Delete role assignments for users
DELETE FROM mdl_role_assignments WHERE userid NOT IN (1, 2);

-- 15. Delete user sessions
DELETE FROM mdl_sessions WHERE userid NOT IN (1, 2);

-- 16. Delete log entries
DELETE FROM mdl_logstore_standard_log WHERE userid NOT IN (1, 2);

-- 17. Delete comments
DELETE FROM mdl_comments WHERE userid NOT IN (1, 2);

-- 18. Delete ratings
DELETE FROM mdl_rating WHERE userid NOT IN (1, 2);

-- 19. Delete files owned by users
DELETE FROM mdl_files WHERE userid NOT IN (1, 2);

-- 20. Delete user cohort memberships
DELETE FROM mdl_cohort_members WHERE userid NOT IN (1, 2);

-- 21. Delete user groups memberships
DELETE FROM mdl_groups_members WHERE userid NOT IN (1, 2);

-- 22. Delete calendar events
DELETE FROM mdl_event WHERE userid NOT IN (1, 2);

-- 23. Delete user private keys
DELETE FROM mdl_user_private_key WHERE userid NOT IN (1, 2);

-- 24. Delete user password history
DELETE FROM mdl_user_password_history WHERE userid NOT IN (1, 2);

-- 25. Delete user devices
DELETE FROM mdl_user_devices WHERE userid NOT IN (1, 2);

-- 26. Delete scorm tracking data
DELETE FROM mdl_scorm_scoes_track WHERE userid NOT IN (1, 2);

-- 27. Delete choice answers
DELETE FROM mdl_choice_answers WHERE userid NOT IN (1, 2);

-- 28. Delete glossary entries
DELETE FROM mdl_glossary_entries WHERE userid NOT IN (1, 2);

-- 29. Delete wiki pages
DELETE FROM mdl_wiki_pages WHERE userid NOT IN (1, 2);

-- 30. Delete lesson attempts
DELETE FROM mdl_lesson_attempts WHERE userid NOT IN (1, 2);

-- 31. Delete question attempts
DELETE FROM mdl_question_attempts WHERE userid NOT IN (1, 2);

-- 32. Delete user contexts
DELETE FROM mdl_context WHERE contextlevel = 30 AND instanceid NOT IN (1, 2);

-- 33. Delete user password resets
DELETE FROM mdl_user_password_resets WHERE userid NOT IN (1, 2);

-- 34. Delete user tags
DELETE FROM mdl_tag_instance WHERE itemid NOT IN (1, 2) AND itemtype = 'user';

-- 35. Delete user enrolment history
DELETE FROM mdl_user_enrolments WHERE userid NOT IN (1, 2);

-- 36. Delete competency user data
DELETE FROM mdl_competency_usercomp WHERE userid NOT IN (1, 2);

-- 37. Finally, delete the users themselves (keep admin ID=2 and guest ID=1)
DELETE FROM mdl_user WHERE id NOT IN (1, 2);

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;

-- Show remaining users
SELECT '=== Remaining Users ===' as info;
SELECT id, username, firstname, lastname, email FROM mdl_user;

-- Show counts
SELECT '=== Data Counts ===' as info;
SELECT
    (SELECT COUNT(*) FROM mdl_user) as total_users,
    (SELECT COUNT(*) FROM mdl_user_enrolments) as total_enrolments,
    (SELECT COUNT(*) FROM mdl_additional_user_details) as total_additional_details,
    (SELECT COUNT(*) FROM mdl_course_completions) as total_completions;
