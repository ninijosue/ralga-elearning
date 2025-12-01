<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Space Theme Config.
 *
 * @package   theme_space
 * @copyright 2022 onwards, Marcin Czaja (https://rosea.io)
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();

require_once(__DIR__ . '/lib.php');

$THEME->name = 'space';
$THEME->sheets = [];
$THEME->editor_sheets = [];
$THEME->editor_scss = ['editor'];
$THEME->usefallback = true;
$THEME->scss = function ($theme) {
    return theme_space_get_main_scss_content($theme);
};

$THEME->layouts = [
    // Most backwards compatible layout without the blocks - this is the layout used by default.
    'base' => [
        'file' => 'tmpl-columns2.php',
        'regions' => [
            'side-pre',
            'sidebartb',
            'sidebarbb',
            'sidecourseblocks',
        ],
        'defaultregion' => 'side-pre',
    ],
    // Standard layout with blocks, this is recommended for most pages with general information.
    'standard' => [
        'file' => 'tmpl-columns2.php',
        'regions' => [
            'side-pre',
            'sidebartb',
            'sidebarbb',
            'sidecourseblocks',
        ],
        'defaultregion' => 'side-pre',
    ],
    // Main course page.
    'course' => [
        'file' => 'tmpl-course.php',
        'regions' => [
            'side-pre',
            'sidecourseblocks',
            'ctopbl',
            'cbottombl',
            'cstopbl',
            'csbottombl',
            'sidebartb',
            'sidebarbb',
        ],
        'defaultregion' => 'side-pre',
        'options' => ['langmenu' => true],
    ],
    'coursecategory' => [
        'file' => 'tmpl-columns2.php',
        'regions' => [
            'side-pre',
            'sidebartb',
            'sidebarbb',
        ],
        'defaultregion' => 'side-pre',
    ],
    // Part of course, typical for modules - default page layout if $cm specified in require_login().
    'incourse' => [
        'file' => 'tmpl-incourse.php',
        'regions' => [
            'side-pre',
            'sidecourseblocks',
            'ctopbl',
            'cstopbl',
            'csbottombl',
            'sidebartb',
            'sidebarbb',
        ],
        'defaultregion' => 'side-pre',
    ],
    // The site home page.
    'frontpage' => [
        'file' => 'tmpl-frontpage.php',
        'regions' => [
            'side-pre',
            'sidebartb',
            'sidebarbb',
            'fpblockst',
            'fpblocksb',
        ],
        'defaultregion' => 'side-pre',
        'options' => ['nonavbar' => true],
    ],
    // Server administration scripts.
    'admin' => [
        'file' => 'tmpl-admin.php',
        'regions' => [
            'side-pre',
            'sidebartb',
            'sidebarbb',
            'sidecourseblocks',
        ],
        'defaultregion' => 'side-pre',
    ],
    // Moodle 4.x. - My courses page.
    'mycourses' => [
        'file' => 'tmpl-mycourses.php',
        'regions' => [
            'side-pre',
            'sidebartb',
            'sidebarbb',
            'sidecourseblocks',
        ],
        'defaultregion' => 'side-pre',
    ],
    // My dashboard page.
    'mydashboard' => [
        'file' => 'tmpl-dashboard.php',
        'regions' => [
            'side-pre',
            'dleftblocks',
            'dmiddleblocks',
            'drightblocks',
            'dtopblocks',
            'dbottomblocks',
            'sidebartb',
            'sidebarbb',
        ],
        'defaultregion' => 'side-pre',
        'options' => ['nonavbar' => true, 'langmenu' => true, 'nocontextheader' => true],
    ],
    // My public page.
    'mypublic' => [
        'file' => 'tmpl-incourse.php',
        'regions' => [
            'side-pre',
            'sidecourseblocks',
            'ctopbl',
            'cstopbl',
            'csbottombl',
            'sidebartb',
            'sidebarbb',
        ],
        'defaultregion' => 'side-pre',
    ],
    'login' => [
        'file' => 'tmpl-login.php',
        'regions' => [],
        'options' => ['langmenu' => true],
    ],

    // Pages that appear in pop-up windows - no navigation, no blocks, no header and bare activity header.
    'popup' => [
        'file' => 'tmpl-popup.php',
        'regions' => [],
        'options' => [
            'nofooter' => true,
            'nonavbar' => true,
            'activityheader' => [
                'notitle' => true,
                'nocompletion' => true,
                'nodescription' => true,
            ],
        ],
    ],
    // No blocks and minimal footer - used for legacy frame layouts only!
    'frametop' => [
        'file' => 'tmpl-columns1.php',
        'regions' => [],
        'options' => [
            'nofooter' => true,
            'nocoursefooter' => true,
            'activityheader' => [
                'nocompletion' => true,
            ],
        ],
    ],
    // Embeded pages, like iframe/object embeded in moodleform - it needs as much space as possible.
    'embedded' => [
        'file' => 'embedded.php',
        'regions' => [],
    ],
    // Used during upgrade and install, and for the 'This site is undergoing maintenance' message.
    // This must not have any blocks, links, or API calls that would lead to database or cache interaction.
    // Please be extremely careful if you are modifying this layout.
    'maintenance' => [
        'file' => 'tmpl-maintenance.php',
        'regions' => [],
    ],
    // Should display the content and basic headers only.
    'print' => [
        'file' => 'tmpl-columns1.php',
        'regions' => [],
        'options' => ['nofooter' => true, 'nonavbar' => false, 'noactivityheader' => true],
    ],
    // The pagelayout used when a redirection is occuring.
    'redirect' => [
        'file' => 'embedded.php',
        'regions' => [],
    ],
    // The pagelayout used for reports.
    'report' => [
        'file' => 'tmpl-report.php',
        'regions' => [
            'side-pre',
            'sidecourseblocks',
            'ctopbl',
            'cstopbl',
            'csbottombl',
            'sidebartb',
            'sidebarbb',
        ],
        'defaultregion' => 'side-pre',
    ],
    // The pagelayout used for safebrowser and securewindow.
    'secure' => [
        'file' => 'secure.php',
        'regions' => [
            'side-pre',
        ],
        'defaultregion' => 'side-pre',
    ],
];

$THEME->parents = [];
$THEME->enable_dock = false;
$THEME->extrascsscallback = 'theme_space_get_extra_scss';
$THEME->prescsscallback = 'theme_space_get_pre_scss';
$THEME->precompiledcsscallback = 'theme_space_get_precompiled_css';
$THEME->yuicssmodules = [];
$THEME->rendererfactory = 'theme_overridden_renderer_factory';
$THEME->requiredblocks = '';
$THEME->iconsystem = \core\output\icon_system::FONTAWESOME;
$THEME->addblockposition = BLOCK_ADDBLOCK_POSITION_FLATNAV;
$THEME->haseditswitch = true;
// By default, all Space theme do not need their titles displayed.
$THEME->activityheaderconfig = [
    'notitle' => true,
];

$THEME->usescourseindex = ($THEME->settings->hidecourseindexnav == 0) ? true : false;
