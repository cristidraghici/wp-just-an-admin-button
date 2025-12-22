<?php
defined('ABSPATH') or die('You shall not pass!');

/*
Plugin Name: Just an admin button
Description: This plugin will hide the admin bar and just display a button to it.
Author: Cristi DRAGHICI
Version: 0.0.0
Author URI: http://www.draghici.net
License: GPLv3 or later
*/

/** line-used-to-generate-placeholder-entry-file */
function jaab_enqueue_styles() {
	wp_enqueue_style(
		'just-an-admin-button-css',
		plugin_dir_url( __FILE__ ) . 'style.css',
		[],
		filemtime( plugin_dir_path( __FILE__ ) . 'style.css' )
	);
}
add_action( 'wp_enqueue_scripts', 'jaab_enqueue_styles' );

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
		echo '<a href="'.admin_url().'" class="just-an-admin-button"><span>Go to Admin Dashboard</span></a>';
	}
}
add_action('wp_footer', 'justAnAdminButton', 1);
?>
