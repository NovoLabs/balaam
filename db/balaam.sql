DROP SCHEMA IF EXISTS balaam CASCADE;

CREATE SCHEMA balaam;

CREATE OR REPLACE FUNCTION balaam.update_last_modified_at_column() 
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified_at = now();
    RETURN NEW; 
END;
$$ language 'plpgsql';

CREATE TABLE balaam.users(
  id                SERIAL PRIMARY KEY NOT NULL,
  username          VARCHAR(25) NOT NULL UNIQUE,
  password          VARCHAR(250) NOT NULL,
  salt              VARCHAR(250) NOT NULL,
  last_modified_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT Now(),
  inserted_at       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT Now()
)
WITH (OIDS=FALSE);
CREATE TRIGGER update_users_last_modified_at BEFORE
  UPDATE ON balaam.users FOR EACH ROW EXECUTE PROCEDURE balaam.update_last_modified_at_column();

CREATE TABLE balaam.slack_tokens(
  id                SERIAL PRIMARY KEY NOT NULL,
  user_id           INT REFERENCES balaam.users(id) NOT NULL,
  access_token      VARCHAR(100) NOT NULL,
  scope             VARCHAR(100) NOT NULL,
  slack_user_id     VARCHAR(20) NOT NULL,
  slack_team_name   VARCHAR(50) NOT NULL,
  slack_team_id     VARCHAR(20) NOT NULL,
  last_modified_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT Now(),
  inserted_at       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT Now()
)
WITH (OIDS=FALSE);
CREATE TRIGGER update_slack_tokens_last_modified_at BEFORE
  UPDATE ON balaam.slack_tokens FOR EACH ROW EXECUTE PROCEDURE balaam.update_last_modified_at_column();
