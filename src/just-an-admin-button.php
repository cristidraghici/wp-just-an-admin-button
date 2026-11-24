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

/**
 * Return the minified contents of style.css for inline output.
 *
 * @return string
 */
function jaab_get_minified_css() {
	static $css = null;

	if ( null !== $css ) {
		return $css;
	}

	$css_file = plugin_dir_path( __FILE__ ) . 'style.css';
	if ( ! is_readable( $css_file ) ) {
		$css = '';
		return $css;
	}

	$raw = file_get_contents( $css_file );
	if ( false === $raw ) {
		$css = '';
		return $css;
	}

	$css = preg_replace( '!/\*.*?\*/!s', '', $raw );
	$css = preg_replace( '/\s+/', ' ', $css );
	$css = preg_replace( '/\s*([{};,])\s*/', '$1', $css );
	$css = preg_replace( '/:\s+/', ':', $css );
	$css = str_replace( ';}', '}', $css );
	$css = trim( $css );

	return $css;
}

/**
 * Inline plugin styles only for logged-in front-end users.
 */
function jaab_enqueue_styles() {
	if ( ! is_user_logged_in() || is_admin() ) {
		return;
	}

	$css = jaab_get_minified_css();
	if ( '' === $css ) {
		return;
	}

	wp_register_style(
		'just-an-admin-button-css',
		false,
		[],
		filemtime( plugin_dir_path( __FILE__ ) . 'style.css' )
	);
	wp_enqueue_style( 'just-an-admin-button-css' );
	wp_add_inline_style( 'just-an-admin-button-css', $css );
}
add_action( 'wp_enqueue_scripts', 'jaab_enqueue_styles' );

/*
 Hide the admin bar
*/
add_filter( 'show_admin_bar', '__return_false' );

/*
 Show the button, if the user is logged in
*/
function justAnAdminButton() {
	if ( ! is_user_logged_in() || is_admin() ) {
		return;
	}

	$icon_path = plugin_dir_path( __FILE__ ) . 'admin.svg';
	$icon_url  = plugin_dir_url( __FILE__ ) . 'admin.svg';
	if ( is_readable( $icon_path ) ) {
		$icon_url = add_query_arg( 'ver', filemtime( $icon_path ), $icon_url );
	}

	printf(
		'<a href="%s" class="just-an-admin-button" rel="nofollow"><img src="%s" alt="" width="30" height="30" decoding="async" fetchpriority="low"><span>%s</span></a>',
		esc_url( admin_url() ),
		esc_url( $icon_url ),
		esc_html__( 'Go to Admin Dashboard', 'just-an-admin-button' )
	);
}
add_action( 'wp_footer', 'justAnAdminButton', 1 );
