# Auth-medium
This repository refer to the Medium blog stories - Authentication and Authorization with Spring Boot - Part 2 

There is 4 important files in this project:

1. Controller.java
2. application.properties
3. data.sql
4. ApplicationSecurity.java

## Controller
```java
@RestController
public class Controller {

    @GetMapping("/Stories")
    public String stories(){
        return " You are authenticated - Stories endpoint";

    }
    @GetMapping("/NewStory")
    public String newStory(){
        return " you are authenticated - New Story endpoint";

    }
    @GetMapping("/UserManaging")
    public String userManaging(){
        return " you are authenticated - User Management endpoint";

    }
}
```
It begins with @RestController and three endpoints /Stories, /NewStory and /UserManaging (like example in 1st part in Medium blog series #url ka medium-u#).
These are Rest API endpoints that Front will be able to call using GET method. In this example it will return the string "its authenticated - name of endpoint"

## Application Properties

You should configure data source, in our example it's in-memory H2 database:
```
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
```
## SQL Data
 
In your resources folder create new file: data.sql
put this code in it:
```sql
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
```
If you are not familiar with SQL it will create 2 tables for you (users and authorities) and put some data in it.

## Application Security
```java
@Configuration
public class ApplicationSecurity extends WebSecurityConfigurerAdapter {

    @Autowired
    DataSource dataSource;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.httpBasic().and().authorizeRequests()
                .antMatchers("/Stories").permitAll()
                .antMatchers("/NewStory").access("hasRole('ROLE_ADMIN') or hasRole('ROLE_WRITER')")
                .antMatchers("/UserManaging").access("hasRole('ROLE_ADMIN')")
                .anyRequest()
                .authenticated();
    }
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.jdbcAuthentication().dataSource(dataSource);
    }
}
```

First we are autowireing data source defined in application.properties (H2 database). 
Second, we are overriding configure method in which we said:
- Use HTTP basis 

- authorizeRequests() - authorize every request

- antMatchers("…").access("hasRole(…)") - for specified endpoint (url) define who have access.

- anyRequest().authenticated() - authenticate every request.

Long story short - Everybody have access to /Stories , only ADMIN and WRITER roles have access to /NewStory and only ADMIN have access to /UserManaging.

And third, we are also overriding configure method but now we said:
 "Authenticate provided credentials against defined data source."
