-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: mysql
-- Source Schemata: mysql
-- Created: Sat Dec 20 00:33:59 2025
-- Workbench Version: 8.0.45
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema mysql
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `mysql` ;
CREATE SCHEMA IF NOT EXISTS `mysql` ;

-- ----------------------------------------------------------------------------
-- Table mysql.columns_priv
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`columns_priv` (
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `Db` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `User` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Table_name` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Column_name` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Column_priv` SET('Select', 'Insert', 'Update', 'References') NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`, `User`, `Db`, `Table_name`, `Column_name`))
ENGINE = InnoDB
COMMENT = 'Column privileges'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.component
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`component` (
  `component_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `component_group_id` INT UNSIGNED NOT NULL,
  `component_urn` TEXT NOT NULL,
  PRIMARY KEY (`component_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Components'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.db
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`db` (
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `Db` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `User` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Select_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Insert_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Update_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Delete_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Drop_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Grant_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `References_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Index_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Alter_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Lock_tables_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_view_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Show_view_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_routine_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Alter_routine_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Execute_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Event_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Trigger_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Host`, `User`, `Db`),
  INDEX `User` (`User` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = 'Database privileges'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.default_roles
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`default_roles` (
  `HOST` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `USER` CHAR(32) NOT NULL DEFAULT '',
  `DEFAULT_ROLE_HOST` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '%',
  `DEFAULT_ROLE_USER` CHAR(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`HOST`, `USER`, `DEFAULT_ROLE_HOST`, `DEFAULT_ROLE_USER`))
ENGINE = InnoDB
COMMENT = 'Default roles'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.engine_cost
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`engine_cost` (
  `engine_name` VARCHAR(64) NOT NULL,
  `device_type` INT NOT NULL,
  `cost_name` VARCHAR(64) NOT NULL,
  `cost_value` FLOAT NULL DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` VARCHAR(1024) NULL DEFAULT NULL,
  `default_value` FLOAT GENERATED ALWAYS AS ((case `cost_name` when _utf8mb3'io_block_read_cost' then 1.0 when _utf8mb3'memory_block_read_cost' then 0.25 else NULL end)) VIRTUAL,
  PRIMARY KEY (`cost_name`, `engine_name`, `device_type`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.func
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`func` (
  `name` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `ret` TINYINT NOT NULL DEFAULT '0',
  `dl` CHAR(128) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `type` ENUM('function', 'aggregate') CHARACTER SET 'utf8mb3' NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB
COMMENT = 'User defined functions'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.general_log
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`general_log` (
  `event_time` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `user_host` MEDIUMTEXT NOT NULL,
  `thread_id` BIGINT UNSIGNED NOT NULL,
  `server_id` INT UNSIGNED NOT NULL,
  `command_type` VARCHAR(64) NOT NULL,
  `argument` MEDIUMBLOB NOT NULL)
ENGINE = CSV
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'General log';

-- ----------------------------------------------------------------------------
-- Table mysql.global_grants
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`global_grants` (
  `USER` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `HOST` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `PRIV` CHAR(32) CHARACTER SET 'utf8mb3' NOT NULL DEFAULT '',
  `WITH_GRANT_OPTION` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  PRIMARY KEY (`USER`, `HOST`, `PRIV`))
ENGINE = InnoDB
COMMENT = 'Extended global grants'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.gtid_executed
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`gtid_executed` (
  `source_uuid` CHAR(36) NOT NULL COMMENT 'uuid of the source where the transaction was originally executed.',
  `interval_start` BIGINT NOT NULL COMMENT 'First number of interval.',
  `interval_end` BIGINT NOT NULL COMMENT 'Last number of interval.',
  `gtid_tag` CHAR(32) NOT NULL COMMENT 'GTID Tag.',
  PRIMARY KEY (`source_uuid`, `gtid_tag`, `interval_start`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.help_category
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`help_category` (
  `help_category_id` SMALLINT UNSIGNED NOT NULL,
  `name` CHAR(64) NOT NULL,
  `parent_category_id` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `url` TEXT NOT NULL,
  PRIMARY KEY (`help_category_id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'help categories'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.help_keyword
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`help_keyword` (
  `help_keyword_id` INT UNSIGNED NOT NULL,
  `name` CHAR(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'help keywords'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.help_relation
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`help_relation` (
  `help_topic_id` INT UNSIGNED NOT NULL,
  `help_keyword_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`help_keyword_id`, `help_topic_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'keyword-topic relation'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.help_topic
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`help_topic` (
  `help_topic_id` INT UNSIGNED NOT NULL,
  `name` CHAR(64) NOT NULL,
  `help_category_id` SMALLINT UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `example` TEXT NOT NULL,
  `url` TEXT NOT NULL,
  PRIMARY KEY (`help_topic_id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'help topics'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.innodb_index_stats
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`innodb_index_stats` (
  `database_name` VARCHAR(64) NOT NULL,
  `table_name` VARCHAR(199) NOT NULL,
  `index_name` VARCHAR(64) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `stat_name` VARCHAR(64) NOT NULL,
  `stat_value` BIGINT UNSIGNED NOT NULL,
  `sample_size` BIGINT UNSIGNED NULL DEFAULT NULL,
  `stat_description` VARCHAR(1024) NOT NULL,
  PRIMARY KEY (`database_name`, `table_name`, `index_name`, `stat_name`))
ENGINE = InnoDB
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.innodb_table_stats
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`innodb_table_stats` (
  `database_name` VARCHAR(64) NOT NULL,
  `table_name` VARCHAR(199) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `n_rows` BIGINT UNSIGNED NOT NULL,
  `clustered_index_size` BIGINT UNSIGNED NOT NULL,
  `sum_of_other_index_sizes` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`database_name`, `table_name`))
ENGINE = InnoDB
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.ndb_binlog_index
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`ndb_binlog_index` (
  `Position` BIGINT UNSIGNED NOT NULL,
  `File` VARCHAR(255) NOT NULL,
  `epoch` BIGINT UNSIGNED NOT NULL,
  `inserts` INT UNSIGNED NOT NULL,
  `updates` INT UNSIGNED NOT NULL,
  `deletes` INT UNSIGNED NOT NULL,
  `schemaops` INT UNSIGNED NOT NULL,
  `orig_server_id` INT UNSIGNED NOT NULL,
  `orig_epoch` BIGINT UNSIGNED NOT NULL,
  `gci` INT UNSIGNED NOT NULL,
  `next_position` BIGINT UNSIGNED NOT NULL,
  `next_file` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`epoch`, `orig_server_id`, `orig_epoch`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.password_history
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`password_history` (
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `User` CHAR(32) NOT NULL DEFAULT '',
  `Password_timestamp` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `Password` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`Host`, `User`, `Password_timestamp`))
ENGINE = InnoDB
COMMENT = 'Password history for user accounts'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.plugin
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`plugin` (
  `name` VARCHAR(64) NOT NULL DEFAULT '',
  `dl` VARCHAR(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'MySQL plugins'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.procs_priv
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`procs_priv` (
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `Db` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `User` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Routine_name` CHAR(64) CHARACTER SET 'utf8mb3' NOT NULL DEFAULT '',
  `Routine_type` ENUM('FUNCTION', 'PROCEDURE', 'LIBRARY') COLLATE 'utf8mb3_bin' NOT NULL,
  `Grantor` VARCHAR(288) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Proc_priv` SET('Execute', 'Alter Routine', 'Grant') NOT NULL DEFAULT '',
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`, `User`, `Db`, `Routine_name`, `Routine_type`),
  INDEX `Grantor` (`Grantor`(255) ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = 'Procedure privileges'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.proxies_priv
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`proxies_priv` (
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `User` CHAR(32) NOT NULL DEFAULT '',
  `Proxied_host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `Proxied_user` CHAR(32) NOT NULL DEFAULT '',
  `With_grant` TINYINT(1) NOT NULL DEFAULT '0',
  `Grantor` VARCHAR(288) NOT NULL DEFAULT '',
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`, `User`, `Proxied_host`, `Proxied_user`),
  INDEX `Grantor` (`Grantor`(255) ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = 'User proxy privileges'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.replication_asynchronous_connection_failover
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`replication_asynchronous_connection_failover` (
  `Channel_name` CHAR(64) CHARACTER SET 'utf8mb3' NOT NULL COMMENT 'The replication channel name that connects source and replica.',
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL COMMENT 'The source hostname that the replica will attempt to switch over the replication connection to in case of a failure.',
  `Port` INT UNSIGNED NOT NULL COMMENT 'The source port that the replica will attempt to switch over the replication connection to in case of a failure.',
  `Network_namespace` CHAR(64) NOT NULL COMMENT 'The source network namespace that the replica will attempt to switch over the replication connection to in case of a failure. If its value is empty, connections use the default (global) namespace.',
  `Weight` TINYINT UNSIGNED NOT NULL COMMENT 'The order in which the replica shall try to switch the connection over to when there are failures. Weight can be set to a number between 1 and 100, where 100 is the highest weight and 1 the lowest.',
  `Managed_name` CHAR(64) CHARACTER SET 'utf8mb3' NOT NULL DEFAULT '' COMMENT 'The name of the group which this server belongs to.',
  PRIMARY KEY (`Channel_name`, `Host`, `Port`, `Network_namespace`, `Managed_name`),
  INDEX `Channel_name` (`Channel_name` ASC, `Managed_name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'The source configuration details'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.replication_asynchronous_connection_failover_managed
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`replication_asynchronous_connection_failover_managed` (
  `Channel_name` CHAR(64) CHARACTER SET 'utf8mb3' NOT NULL COMMENT 'The replication channel name that connects source and replica.',
  `Managed_name` CHAR(64) CHARACTER SET 'utf8mb3' NOT NULL DEFAULT '' COMMENT 'The name of the source which needs to be managed.',
  `Managed_type` CHAR(64) CHARACTER SET 'utf8mb3' NOT NULL DEFAULT '' COMMENT 'Determines the managed type.',
  `Configuration` JSON NULL DEFAULT NULL COMMENT 'The data to help manage group. For Managed_type = GroupReplication, Configuration value should contain {\"Primary_weight\": 80, \"Secondary_weight\": 60}, so that it assigns weight=80 to PRIMARY of the group, and weight=60 for rest of the members in mysql.replication_asynchronous_connection_failover table.',
  PRIMARY KEY (`Channel_name`, `Managed_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'The managed source configuration details'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.replication_group_configuration_version
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`replication_group_configuration_version` (
  `name` CHAR(255) CHARACTER SET 'ascii' NOT NULL COMMENT 'The configuration name.',
  `version` BIGINT UNSIGNED NOT NULL COMMENT 'The version of the configuration name.',
  PRIMARY KEY (`name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'The group configuration version.'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.replication_group_member_actions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`replication_group_member_actions` (
  `name` CHAR(255) CHARACTER SET 'ascii' NOT NULL COMMENT 'The action name.',
  `event` CHAR(64) CHARACTER SET 'ascii' NOT NULL COMMENT 'The event that will trigger the action.',
  `enabled` TINYINT(1) NOT NULL COMMENT 'Whether the action is enabled.',
  `type` CHAR(64) CHARACTER SET 'ascii' NOT NULL COMMENT 'The action type.',
  `priority` TINYINT UNSIGNED NOT NULL COMMENT 'The order on which the action will be run, value between 1 and 100, lower values first.',
  `error_handling` CHAR(64) CHARACTER SET 'ascii' NOT NULL COMMENT 'On errors during the action will be handled: IGNORE, CRITICAL.',
  PRIMARY KEY (`name`, `event`),
  INDEX `event` (`event` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'The member actions configuration.'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.role_edges
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`role_edges` (
  `FROM_HOST` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `FROM_USER` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `TO_HOST` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `TO_USER` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `WITH_ADMIN_OPTION` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  PRIMARY KEY (`FROM_HOST`, `FROM_USER`, `TO_HOST`, `TO_USER`))
ENGINE = InnoDB
COMMENT = 'Role hierarchy and role grants'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.server_cost
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`server_cost` (
  `cost_name` VARCHAR(64) NOT NULL,
  `cost_value` FLOAT NULL DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` VARCHAR(1024) NULL DEFAULT NULL,
  `default_value` FLOAT GENERATED ALWAYS AS ((case `cost_name` when _utf8mb3'disk_temptable_create_cost' then 20.0 when _utf8mb3'disk_temptable_row_cost' then 0.5 when _utf8mb3'key_compare_cost' then 0.05 when _utf8mb3'memory_temptable_create_cost' then 1.0 when _utf8mb3'memory_temptable_row_cost' then 0.1 when _utf8mb3'row_evaluate_cost' then 0.1 else NULL end)) VIRTUAL,
  PRIMARY KEY (`cost_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.servers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`servers` (
  `Server_name` CHAR(64) NOT NULL DEFAULT '',
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `Db` CHAR(64) NOT NULL DEFAULT '',
  `Username` CHAR(64) NOT NULL DEFAULT '',
  `Password` CHAR(64) NOT NULL DEFAULT '',
  `Port` INT NOT NULL DEFAULT '0',
  `Socket` CHAR(64) NOT NULL DEFAULT '',
  `Wrapper` CHAR(64) NOT NULL DEFAULT '',
  `Owner` CHAR(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`Server_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'MySQL Foreign Servers table'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.slave_master_info
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`slave_master_info` (
  `Number_of_lines` INT UNSIGNED NOT NULL COMMENT 'Number of lines in the file.',
  `Master_log_name` TEXT CHARACTER SET 'utf8mb3' NOT NULL COMMENT 'The name of the master binary log currently being read from the master.',
  `Master_log_pos` BIGINT UNSIGNED NOT NULL COMMENT 'The master log position of the last read event.',
  `Host` VARCHAR(255) CHARACTER SET 'ascii' NULL DEFAULT NULL COMMENT 'The host name of the source.',
  `User_name` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The user name used to connect to the master.',
  `User_password` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The password used to connect to the master.',
  `Port` INT UNSIGNED NOT NULL COMMENT 'The network port used to connect to the master.',
  `Connect_retry` INT UNSIGNED NOT NULL COMMENT 'The period (in seconds) that the slave will wait before trying to reconnect to the master.',
  `Enabled_ssl` TINYINT(1) NOT NULL COMMENT 'Indicates whether the server supports SSL connections.',
  `Ssl_ca` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The file used for the Certificate Authority (CA) certificate.',
  `Ssl_capath` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The path to the Certificate Authority (CA) certificates.',
  `Ssl_cert` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The name of the SSL certificate file.',
  `Ssl_cipher` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The name of the cipher in use for the SSL connection.',
  `Ssl_key` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The name of the SSL key file.',
  `Ssl_verify_server_cert` TINYINT(1) NOT NULL COMMENT 'Whether to verify the server certificate.',
  `Heartbeat` FLOAT NOT NULL,
  `Bind` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'Displays which interface is employed when connecting to the MySQL server',
  `Ignored_server_ids` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The number of server IDs to be ignored, followed by the actual server IDs',
  `Uuid` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The master server uuid.',
  `Retry_count` BIGINT UNSIGNED NOT NULL COMMENT 'Number of reconnect attempts, to the master, before giving up.',
  `Ssl_crl` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The file used for the Certificate Revocation List (CRL)',
  `Ssl_crlpath` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The path used for Certificate Revocation List (CRL) files',
  `Enabled_auto_position` TINYINT(1) NOT NULL COMMENT 'Indicates whether GTIDs will be used to retrieve events from the master.',
  `Channel_name` VARCHAR(64) CHARACTER SET 'utf8mb3' NOT NULL COMMENT 'The channel on which the replica is connected to a source. Used in Multisource Replication',
  `Tls_version` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'Tls version',
  `Public_key_path` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The file containing public key of master server.',
  `Get_public_key` TINYINT(1) NOT NULL COMMENT 'Preference to get public key from master.',
  `Network_namespace` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'Network namespace used for communication with the master server.',
  `Master_compression_algorithm` VARCHAR(64) CHARACTER SET 'utf8mb3' NOT NULL COMMENT 'Compression algorithm supported for data transfer between source and replica.',
  `Master_zstd_compression_level` INT UNSIGNED NOT NULL COMMENT 'Compression level associated with zstd compression algorithm.',
  `Tls_ciphersuites` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'Ciphersuites used for TLS 1.3 communication with the master server.',
  `Source_connection_auto_failover` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether the channel connection failover is enabled.',
  `Gtid_only` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Indicates if this channel only uses GTIDs and does not persist positions.',
  PRIMARY KEY (`Channel_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Master Information'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.slave_relay_log_info
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`slave_relay_log_info` (
  `Number_of_lines` INT UNSIGNED NOT NULL COMMENT 'Number of lines in the file or rows in the table. Used to version table definitions.',
  `Relay_log_name` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The name of the current relay log file.',
  `Relay_log_pos` BIGINT UNSIGNED NULL DEFAULT NULL COMMENT 'The relay log position of the last executed event.',
  `Master_log_name` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'The name of the master binary log file from which the events in the relay log file were read.',
  `Master_log_pos` BIGINT UNSIGNED NULL DEFAULT NULL COMMENT 'The master log position of the last executed event.',
  `Sql_delay` INT NULL DEFAULT NULL COMMENT 'The number of seconds that the slave must lag behind the master.',
  `Number_of_workers` INT UNSIGNED NULL DEFAULT NULL,
  `Id` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Internal Id that uniquely identifies this record.',
  `Channel_name` VARCHAR(64) CHARACTER SET 'utf8mb3' NOT NULL COMMENT 'The channel on which the replica is connected to a source. Used in Multisource Replication',
  `Privilege_checks_username` VARCHAR(32) CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'Username part of PRIVILEGE_CHECKS_USER.',
  `Privilege_checks_hostname` VARCHAR(255) CHARACTER SET 'ascii' NULL DEFAULT NULL COMMENT 'Hostname part of PRIVILEGE_CHECKS_USER.',
  `Require_row_format` TINYINT(1) NOT NULL COMMENT 'Indicates whether the channel shall only accept row based events.',
  `Require_table_primary_key_check` ENUM('STREAM', 'ON', 'OFF', 'GENERATE') NOT NULL DEFAULT 'STREAM' COMMENT 'Indicates what is the channel policy regarding tables without primary keys on create and alter table queries',
  `Assign_gtids_to_anonymous_transactions_type` ENUM('OFF', 'LOCAL', 'UUID') NOT NULL DEFAULT 'OFF' COMMENT 'Indicates whether the channel will generate a new GTID for anonymous transactions. OFF means that anonymous transactions will remain anonymous. LOCAL means that anonymous transactions will be assigned a newly generated GTID based on server_uuid. UUID indicates that anonymous transactions will be assigned a newly generated GTID based on Assign_gtids_to_anonymous_transactions_value',
  `Assign_gtids_to_anonymous_transactions_value` TEXT CHARACTER SET 'utf8mb3' NULL DEFAULT NULL COMMENT 'Indicates the UUID used while generating GTIDs for anonymous transactions',
  PRIMARY KEY (`Channel_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Relay Log Information'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.slave_worker_info
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`slave_worker_info` (
  `Id` INT UNSIGNED NOT NULL,
  `Relay_log_name` TEXT CHARACTER SET 'utf8mb3' NOT NULL,
  `Relay_log_pos` BIGINT UNSIGNED NOT NULL,
  `Master_log_name` TEXT CHARACTER SET 'utf8mb3' NOT NULL,
  `Master_log_pos` BIGINT UNSIGNED NOT NULL,
  `Checkpoint_relay_log_name` TEXT CHARACTER SET 'utf8mb3' NOT NULL,
  `Checkpoint_relay_log_pos` BIGINT UNSIGNED NOT NULL,
  `Checkpoint_master_log_name` TEXT CHARACTER SET 'utf8mb3' NOT NULL,
  `Checkpoint_master_log_pos` BIGINT UNSIGNED NOT NULL,
  `Checkpoint_seqno` INT UNSIGNED NOT NULL,
  `Checkpoint_group_size` INT UNSIGNED NOT NULL,
  `Checkpoint_group_bitmap` BLOB NOT NULL,
  `Channel_name` VARCHAR(64) CHARACTER SET 'utf8mb3' NOT NULL COMMENT 'The channel on which the replica is connected to a source. Used in Multisource Replication',
  PRIMARY KEY (`Channel_name`, `Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Worker Information'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.slow_log
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`slow_log` (
  `start_time` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `user_host` MEDIUMTEXT NOT NULL,
  `query_time` TIME(6) NOT NULL,
  `lock_time` TIME(6) NOT NULL,
  `rows_sent` INT NOT NULL,
  `rows_examined` INT NOT NULL,
  `db` VARCHAR(512) NOT NULL,
  `last_insert_id` INT NOT NULL,
  `insert_id` INT NOT NULL,
  `server_id` INT UNSIGNED NOT NULL,
  `sql_text` MEDIUMBLOB NOT NULL,
  `thread_id` BIGINT UNSIGNED NOT NULL)
ENGINE = CSV
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Slow log';

-- ----------------------------------------------------------------------------
-- Table mysql.tables_priv
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`tables_priv` (
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `Db` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `User` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Table_name` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Grantor` VARCHAR(288) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Table_priv` SET('Select', 'Insert', 'Update', 'Delete', 'Create', 'Drop', 'Grant', 'References', 'Index', 'Alter', 'Create View', 'Show view', 'Trigger') NOT NULL DEFAULT '',
  `Column_priv` SET('Select', 'Insert', 'Update', 'References') NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`, `User`, `Db`, `Table_name`),
  INDEX `Grantor` (`Grantor`(255) ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = 'Table privileges'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.time_zone
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`time_zone` (
  `Time_zone_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Use_leap_seconds` ENUM('Y', 'N') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Time_zone_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Time zones'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.time_zone_leap_second
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`time_zone_leap_second` (
  `Transition_time` BIGINT NOT NULL,
  `Correction` INT NOT NULL,
  PRIMARY KEY (`Transition_time`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Leap seconds information for time zones'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.time_zone_name
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`time_zone_name` (
  `Name` CHAR(64) NOT NULL,
  `Time_zone_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Time zone names'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.time_zone_transition
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`time_zone_transition` (
  `Time_zone_id` INT UNSIGNED NOT NULL,
  `Transition_time` BIGINT NOT NULL,
  `Transition_type_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Time_zone_id`, `Transition_time`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Time zone transitions'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.time_zone_transition_type
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`time_zone_transition_type` (
  `Time_zone_id` INT UNSIGNED NOT NULL,
  `Transition_type_id` INT UNSIGNED NOT NULL,
  `Offset` INT NOT NULL DEFAULT '0',
  `Is_DST` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `Abbreviation` CHAR(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`Time_zone_id`, `Transition_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'Time zone transition types'
ROW_FORMAT = DYNAMIC;

-- ----------------------------------------------------------------------------
-- Table mysql.user
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mysql`.`user` (
  `Host` CHAR(255) CHARACTER SET 'ascii' NOT NULL DEFAULT '',
  `User` CHAR(32) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT '',
  `Select_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Insert_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Update_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Delete_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Drop_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Reload_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Shutdown_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Process_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `File_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Grant_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `References_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Index_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Alter_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Show_db_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Super_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Lock_tables_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Execute_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Repl_slave_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Repl_client_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_view_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Show_view_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_routine_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Alter_routine_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_user_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Event_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Trigger_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_tablespace_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `ssl_type` ENUM('', 'ANY', 'X509', 'SPECIFIED') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT '',
  `ssl_cipher` BLOB NOT NULL,
  `x509_issuer` BLOB NOT NULL,
  `x509_subject` BLOB NOT NULL,
  `max_questions` INT UNSIGNED NOT NULL DEFAULT '0',
  `max_updates` INT UNSIGNED NOT NULL DEFAULT '0',
  `max_connections` INT UNSIGNED NOT NULL DEFAULT '0',
  `max_user_connections` INT UNSIGNED NOT NULL DEFAULT '0',
  `plugin` CHAR(64) COLLATE 'utf8mb3_bin' NOT NULL DEFAULT 'caching_sha2_password',
  `authentication_string` TEXT COLLATE 'utf8mb3_bin' NULL DEFAULT NULL,
  `password_expired` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `password_last_changed` TIMESTAMP NULL DEFAULT NULL,
  `password_lifetime` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `account_locked` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Create_role_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Drop_role_priv` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NOT NULL DEFAULT 'N',
  `Password_reuse_history` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `Password_reuse_time` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `Password_require_current` ENUM('N', 'Y') CHARACTER SET 'utf8mb3' NULL DEFAULT NULL,
  `User_attributes` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`Host`, `User`))
ENGINE = InnoDB
COMMENT = 'Users and global privileges'
ROW_FORMAT = DYNAMIC;
SET FOREIGN_KEY_CHECKS = 1;
