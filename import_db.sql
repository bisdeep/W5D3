DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS user;


PRAGMA foreign_keys = ON;

CREATE TABLE user (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY(author_id) REFERENCES user(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY(user_id) REFERENCES user(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    parent_reply_id INTEGER,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
    user(fname, lname)
VALUES 
    ('Deep', 'Biswas'),
    ('Kira', 'Porter');

INSERT INTO 
    questions(title, body, author_id)
VALUES
    ('how sql work', 'I''m so confused. Send help!!!', (SELECT id FROM user WHERE fname = 'Deep'));

INSERT INTO
    question_follows(user_id, question_id)
VALUES
    ((SELECT id FROM user WHERE fname = 'Deep'), (SELECT id FROM questions WHERE id = 1));

INSERT INTO
    replies(question_id, user_id, body)
VALUES
    ((SELECT id FROM questions WHERE id = 1), (SELECT id FROM user WHERE fname = 'Kira'), "Same! So lost lol :(");

INSERT INTO
    question_likes(user_id, question_id)
VALUES
    ((SELECT id FROM user WHERE fname = 'Kira'), (SELECT id FROM questions WHERE id = 1))