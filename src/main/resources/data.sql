create table users(
	username varchar_ignorecase(50) not null primary key,
	password varchar_ignorecase(200) not null,
	enabled boolean not null
);

create table authorities (
	username varchar_ignorecase(50) not null,
	authority varchar_ignorecase(50) not null,
	constraint fk_authorities_users foreign key(username) references users(username)
);

insert into users (username, password, enabled) values ('mike', '{noop}mike12', true);
insert into authorities (username, authority) values ('mike', 'ROLE_ADMIN');

insert into users (username, password, enabled) values ('ika', '{noop}ika12', true);
insert into authorities (username, authority) values ('ika', 'ROLE_WRITER');

insert into users (username, password, enabled) values ('tim', '{noop}tim12', true);
insert into authorities (username, authority) values ('tim', 'ROLE_READER');