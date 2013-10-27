CREATE TABLE users (
    user_name varchar(20) NOT NULL PRIMARY KEY,
    password varchar(20) NOT NULL,
    date_registered date NOT NULL
);
    
CREATE TABLE persons (
    user_name varchar(20) ,
    first_name varchar(20),
    last_name varchar(20),
    address varchar(20),
    email varchar(20),
    phone int
);

CREATE TABLE groups (
    group_id int;
    user_name varchar(20),
    group_name varchar(20),
    date_created date
)

CREATE TABLE group_lists(
    group_id int,
    friend_id int,
    date_added date,
    notice varchar(20)
)

CREATE TABLE images (
    photo_id int,
    owner_name varchar(20),
    permitted varchar(20),
    subject varchar(20),
    place varchar(20),
    when date,
    description varchar(100),
    thumbnail ??
    photo ??
)
