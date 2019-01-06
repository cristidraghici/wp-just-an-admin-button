<?php
defined('ABSPATH') or die('You shall not pass!');

/*
Plugin Name: Just an admin button
Description: This plugin will hide the admin bar and just display a button to it.
Author: Cristi DRAGHICI
Version: 1.2.0
Author URI: http://www.draghici.net
License: GPLv3 or later
*/

/** line-used-to-generate-placeholder-entry-file */
wp_enqueue_style( 'just-an-admin-button-css', plugins_url( 'style.css' , __FILE__ ) );

/*
 Hide the admin bar
*/
add_filter('show_admin_bar', '__return_false');

/*
 Show the button, if the user is logged in
*/
function justAnAdminButton()
{
	if ( is_user_logged_in() && !is_admin() )
	{
		echo '<a href="'.admin_url().'" class="just-an-admin-button"><span>A</span></a>';
	}
}
add_action('wp_footer', 'justAnAdminButton', 1);
?>
