--
-- Table structure for table Users
--
CREATE TABLE users
(
  id                   VARCHAR(26) NOT NULL PRIMARY KEY,
  create_at            TIMESTAMP   NOT NULL,
  update_at            TIMESTAMP    DEFAULT NULL,
  delete_at            TIMESTAMP    DEFAULT NULL,
  username             VARCHAR(64)  DEFAULT NULL UNIQUE,
  password             VARCHAR(128) DEFAULT NULL,
  auth_data            VARCHAR(128) DEFAULT NULL UNIQUE,
  auth_service         VARCHAR(32)  DEFAULT NULL,
  email                VARCHAR(128) DEFAULT NULL UNIQUE,
  email_verified       BOOLEAN      DEFAULT NULL,
  nickname             VARCHAR(64)  DEFAULT NULL,
  first_name           VARCHAR(64)  DEFAULT NULL,
  last_name            VARCHAR(64)  DEFAULT NULL,
  position             VARCHAR(128) DEFAULT NULL,
  roles                TEXT,
  allow_marketing      BOOLEAN      DEFAULT NULL,
  props                TEXT,
  notify_props         TEXT,
  last_password_update TIMESTAMP    DEFAULT NULL,
  last_picture_update  TIMESTAMP    DEFAULT NULL,
  failed_attempts      INT          DEFAULT NULL,
  locale               VARCHAR(5)   DEFAULT NULL,
  timezone             TEXT,
  mfa_active           BOOLEAN      DEFAULT NULL,
  mfa_secret           VARCHAR(128) DEFAULT NULL
);
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_update_at ON users (update_at);
CREATE INDEX idx_users_create_at ON users (create_at);
CREATE INDEX idx_users_delete_at ON users (delete_at);
-- CREATE INDEX idx_users_all_txt ON users USING GIN (username, first_name, last_name, nickname, email);
-- CREATE INDEX idx_users_all_no_full_name_txt ON users USING GIN (username, nickname, email);
-- CREATE INDEX idx_users_names_txt ON users USING GIN (username, first_name, last_name, nickname);
-- CREATE INDEX idx_users_names_no_full_name_txt ON users USING GIN (username, nickname);

--
-- Table structure for table Teams
--
CREATE TABLE teams
(
  id                    VARCHAR(26) NOT NULL PRIMARY KEY,
  create_at             TIMESTAMP    DEFAULT NULL,
  update_at             TIMESTAMP    DEFAULT NULL,
  delete_at             TIMESTAMP    DEFAULT NULL,
  display_name          VARCHAR(64)  DEFAULT NULL,
  name                  VARCHAR(64)  DEFAULT NULL UNIQUE,
  description           VARCHAR(255) DEFAULT NULL,
  email                 VARCHAR(128) DEFAULT NULL,
  type                  VARCHAR(255) DEFAULT NULL,
  company_name          VARCHAR(64)  DEFAULT NULL,
  allowed_domains       TEXT,
  invite_id             VARCHAR(32)  DEFAULT NULL,
  allow_open_invite     BOOLEAN      DEFAULT NULL,
  last_team_icon_update TIMESTAMP    DEFAULT NULL,
  scheme_id             VARCHAR(255) DEFAULT NULL
);
CREATE INDEX idx_teams_name ON teams (name);
CREATE INDEX idx_teams_invite_id ON teams (invite_id);
CREATE INDEX idx_teams_update_at ON teams (update_at);
CREATE INDEX idx_teams_create_at ON teams (create_at);
CREATE INDEX idx_teams_delete_at ON teams (delete_at);

--
-- Table structure for table Channels
--
CREATE TABLE channels
(
  id              VARCHAR(26)                       NOT NULL PRIMARY KEY,
  create_at       TIMESTAMP                         NOT NULL,
  update_at       TIMESTAMP    DEFAULT NULL,
  delete_at       TIMESTAMP    DEFAULT NULL,
  team_id         VARCHAR(26) REFERENCES teams (id) NOT NULL,
  type            VARCHAR(1)                        NOT NULL,
  display_name    VARCHAR(64)  DEFAULT NULL,
  name            VARCHAR(64)  DEFAULT NULL,
  header          TEXT,
  purpose         VARCHAR(250) DEFAULT NULL,
  last_post_at    TIMESTAMP    DEFAULT NULL,
  total_msg_count BIGINT       DEFAULT NULL,
  extra_update_at TIMESTAMP    DEFAULT NULL,
  creator_id      VARCHAR(26)  DEFAULT NULL,
  scheme_id       VARCHAR(26)  DEFAULT NULL,
  UNIQUE (name, team_id)
);
CREATE INDEX idx_channels_team_id ON channels (team_id);
CREATE INDEX idx_channels_name ON channels (name);
CREATE INDEX idx_channels_update_at ON channels (update_at);
CREATE INDEX idx_channels_create_at ON channels (create_at);
CREATE INDEX idx_channels_delete_at ON channels (delete_at);
-- CREATE INDEX idx_channel_search_txt ON channels USING GIN (name, display_name, purpose);

--
-- Table structure for table ChannelMembers
--
CREATE TABLE channel_members
(
  channel_id     VARCHAR(26) REFERENCES channels (id) NOT NULL,
  user_id        VARCHAR(26) REFERENCES users (id)    NOT NULL,
  roles          VARCHAR(64) DEFAULT NULL,
  last_viewed_at BIGINT      DEFAULT NULL,
  msg_count      BIGINT      DEFAULT NULL,
  mention_count  BIGINT      DEFAULT NULL,
  notify_props   TEXT,
  last_update_at TIMESTAMP   DEFAULT NULL,
  scheme_user    INT         DEFAULT NULL,
  scheme_admin   INT         DEFAULT NULL,
  PRIMARY KEY (channel_id, user_id)
);
CREATE INDEX idx_channel_members_channel_id ON channel_members (channel_id);
CREATE INDEX idx_channel_members_user_id ON channel_members (user_id);

--
-- Table structure for table Posts
--
CREATE TABLE posts
(
  id            VARCHAR(26) NOT NULL PRIMARY KEY,
  create_at     TIMESTAMP   NOT NULL,
  update_at     TIMESTAMP                            DEFAULT NULL,
  edit_at       TIMESTAMP                            DEFAULT NULL,
  delete_at     TIMESTAMP                            DEFAULT NULL,
  is_pinned     BOOLEAN                              DEFAULT NULL,
  user_id       VARCHAR(26) REFERENCES users (id)    DEFAULT NULL,
  channel_id    VARCHAR(26) REFERENCES channels (id) DEFAULT NULL,
  root_id       VARCHAR(26)                          DEFAULT NULL,
  parent_id     VARCHAR(26)                          DEFAULT NULL,
  original_id   VARCHAR(26)                          DEFAULT NULL,
  message       TEXT,
  type          VARCHAR(26)                          DEFAULT NULL,
  props         TEXT,
  hash_tags     TEXT,
  file_names    TEXT,
  file_ids      VARCHAR(150)                         DEFAULT NULL,
  has_reactions BOOLEAN                              DEFAULT NULL
);
CREATE INDEX idx_posts_update_at ON posts (update_at);
CREATE INDEX idx_posts_create_at ON posts (create_at);
CREATE INDEX idx_posts_delete_at ON posts (delete_at);
CREATE INDEX idx_posts_channel_id ON posts (channel_id);
CREATE INDEX idx_posts_root_id ON posts (root_id);
CREATE INDEX idx_posts_user_id ON posts (user_id);
CREATE INDEX idx_posts_is_pinned ON posts (is_pinned);
CREATE INDEX idx_posts_channel_id_update_at ON posts (channel_id, update_at);
CREATE INDEX idx_posts_channel_id_delete_at_create_at ON posts (channel_id, delete_at, create_at);
-- CREATE INDEX idx_posts_message_txt ON posts USING GIN (message);
-- CREATE INDEX idx_posts_hash_tags_txt ON posts USING GIN (hash_tags);
