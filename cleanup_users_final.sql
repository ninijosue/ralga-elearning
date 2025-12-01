-- Cleanup Script: Remove all users except admin (ID=2) and guest (ID=1)
-- Focused on core tables that exist

SET FOREIGN_KEY_CHECKS=0;

-- Custom table
DELETE FROM mdl_additional_user_details WHERE userid NOT IN (1, 2);

-- Core user data
DELETE FROM mdl_user_enrolments WHERE userid NOT IN (1, 2);
DELETE FROM mdl_user_preferences WHERE userid NOT IN (1, 2);
DELETE FROM mdl_user_lastaccess WHERE userid NOT IN (1, 2);
DELETE FROM mdl_user_password_history WHERE userid NOT IN (1, 2);
DELETE FROM mdl_user_devices WHERE userid NOT IN (1, 2);
DELETE FROM mdl_user_private_key WHERE userid NOT IN (1, 2);

-- Completions and grades
DELETE FROM mdl_course_completions WHERE userid NOT IN (1, 2);
DELETE FROM mdl_course_modules_completion WHERE userid NOT IN (1, 2);
DELETE FROM mdl_grade_grades WHERE userid NOT IN (1, 2);

-- Certificates
DELETE FROM mdl_customcert_issues WHERE userid NOT IN (1, 2);

-- Assignments
DELETE FROM mdl_assign_submission WHERE userid NOT IN (1, 2);
DELETE FROM mdl_assign_grades WHERE userid NOT IN (1, 2);
DELETE FROM mdl_assign_user_flags WHERE userid NOT IN (1, 2);
DELETE FROM mdl_assign_user_mapping WHERE userid NOT IN (1, 2);

-- Forums
DELETE FROM mdl_forum_posts WHERE userid NOT IN (1, 2);
DELETE FROM mdl_forum_discussions WHERE userid NOT IN (1, 2);
DELETE FROM mdl_forum_read WHERE userid NOT IN (1, 2);

-- Messaging
DELETE FROM mdl_message_conversation_members WHERE userid NOT IN (1, 2);
DELETE FROM mdl_messages WHERE useridfrom NOT IN (1, 2);
DELETE FROM mdl_message_user_actions WHERE userid NOT IN (1, 2);

-- Badges
DELETE FROM mdl_badge_issued WHERE userid NOT IN (1, 2);

-- Competencies
DELETE FROM mdl_competency_usercomp WHERE userid NOT IN (1, 2);
DELETE FROM mdl_competency_usercompcourse WHERE userid NOT IN (1, 2);
DELETE FROM mdl_competency_usercompplan WHERE userid NOT IN (1, 2);
DELETE FROM mdl_competency_userevidence WHERE userid NOT IN (1, 2);
DELETE FROM mdl_competency_userevidencecomp WHERE userid NOT IN (1, 2);

-- Roles and permissions
DELETE FROM mdl_role_assignments WHERE userid NOT IN (1, 2);

-- Sessions
DELETE FROM mdl_sessions WHERE userid NOT IN (1, 2);

-- Logs
DELETE FROM mdl_logstore_standard_log WHERE userid NOT IN (1, 2);

-- Comments and ratings
DELETE FROM mdl_comments WHERE userid NOT IN (1, 2);
DELETE FROM mdl_rating WHERE userid NOT IN (1, 2);

-- Files
DELETE FROM mdl_files WHERE userid NOT IN (1, 2);

-- Groups and cohorts
DELETE FROM mdl_cohort_members WHERE userid NOT IN (1, 2);
DELETE FROM mdl_groups_members WHERE userid NOT IN (1, 2);

-- Calendar
DELETE FROM mdl_event WHERE userid NOT IN (1, 2);

-- Quiz
DELETE FROM mdl_quiz_attempts WHERE userid NOT IN (1, 2);
DELETE FROM mdl_quiz_grades WHERE userid NOT IN (1, 2);

-- Question attempts
DELETE FROM mdl_question_attempts WHERE userid NOT IN (1, 2);

-- User contexts
DELETE FROM mdl_context WHERE contextlevel = 30 AND instanceid NOT IN (1, 2);

-- Tags
DELETE FROM mdl_tag_instance WHERE itemid NOT IN (1, 2) AND itemtype = 'user';

-- Finally, delete users
DELETE FROM mdl_user WHERE id NOT IN (1, 2);

SET FOREIGN_KEY_CHECKS=1;

-- Results
SELECT '=== Cleanup Complete ===' as status;
SELECT id, username, firstname, lastname, email FROM mdl_user;
SELECT
    (SELECT COUNT(*) FROM mdl_user) as users,
    (SELECT COUNT(*) FROM mdl_user_enrolments) as enrolments,
    (SELECT COUNT(*) FROM mdl_additional_user_details) as additional_details;
