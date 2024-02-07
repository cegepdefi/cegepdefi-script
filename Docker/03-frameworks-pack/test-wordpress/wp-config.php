<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress_db' );

/** Database username */
define( 'DB_USER', 'admin' );

/** Database password */
define( 'DB_PASSWORD', 'admin123' );

/** Database hostname */
define( 'DB_HOST', '01-HomePage-wordpress-mysql' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'm-__o5M;iduL(WfnFKHP)3Fc[|]|(b=UY$rXww&s6`{^bx=CX6Ph27n%O7I^nKT8' );
define( 'SECURE_AUTH_KEY',  'CVUts!r%+{xm+#`)iut%+DPEFh9{K2re15<_LA|f7aiGtAn{S>t>UT^1uO%vf5^^' );
define( 'LOGGED_IN_KEY',    '?9:J=loy@ho7-`q[{;H>:*{pEsbHZo2X[8eHqeC#;a^v+~~g$Rrm=/)@GwH0u&FQ' );
define( 'NONCE_KEY',        '=jh*^ GylQauFc83b@O_i<VrIQ]2b:q`sQ/8AA8sNKc:skDYb6hY08>~sUNGD2A@' );
define( 'AUTH_SALT',        '`48U8D`M g7)V o]=BO[:?=V+5e1C>9CM#SEV|Jf?HHUnI1&jT}=e.QfM^/Np<th' );
define( 'SECURE_AUTH_SALT', '/D_,%`oXiL|e}6UQ<*=#WnGm-`RC}tv3K]Q;biz=q=+@ba+oi:f4Z7L>;WTQ~_ =' );
define( 'LOGGED_IN_SALT',   'T;G.CbN;;yH$@zH25w(SneFzvpSy;V]:IjP7:M52Ro`l}r*|R![nUuR3M)9G&E-<' );
define( 'NONCE_SALT',       '1_2=BE:7p.2z;Mn_1wrPNWO`]#,+9;R{5;{Q7LV)7IhiO=/8rcfASAM&nz@^]XxI' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */
define('FS_METHOD','direct');


/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
