# BooksOnTheTableServer

Books On The Table Project back-end.

This back-end uses is made in **Swift** and **Vapor**.

Data is persistend using a SQLite database through **Fluent ORM**.

## How to Use the Back End

To Install Vapor Toolbox:

```shell
brew install vapor
```

To prepare the database:

```shell
swift run Run migrate
```

To start the backend:

```shell
swift run Run
```

To open the source code in Xcode

```shell
vapor xcode
```

To run the project in Xcode, using the correct **Data Path**, update the Schema, set the ***Working Directory*** to the folder where the *Package.swift* file is located.

# Features

## Creates a User (POST)

Creates a new user.

Although the password is provided plain, it will be encrypted upon saving.

### Headers

**Content-Type: application/json**

### Parameters

None.

### Body

| Parameter | Description |
| ---------------  | --------------- |
| name | User name |
| email | User email |
| password | User Password |

### Request Example

```shell
curl -i -X POST "http://127.0.0.1:8080/users" \
        -H "Content-Type: application/json" \
        -d '{
        	"name" : "User Name",
        	"email" : "user@email.com",
	     	"password" : "1234"
	     }'
```

### Success Response

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 40
connection: keep-alive
date: Sat, 03 Apr 2021 11:42:38 GMT

{"name":"User Name","email":"email@provider.com.br"}
```

### Error Responses

| HTTP Status Code | Details | Known Reasons |
| ---------------  | --------------- | --------------- |
| 400 | The given data was not valid JSON. | JSON Body has issues |
| | | |
| 400 | name is required | name property is absent |
| 400 | name is less than minimum of 3 character(s) | name property value is too short |
| | | |
| 400 | email is required | email property is absent |
| 400 | email is not a valid email address | email property value is invalid |
| | | |
| 400 | password is required | password property is absent |
| 400 | password is less than minimum of 8 character(s) | password property value is too short |

## User Authetication (POST)

Request a Bearer token.

### Headers

**Content-Type: application/json**

### Parameters

None.

### Body

| Parameter | Description |
| ---------------  | --------------- |
| email | User email |
| password | User Password |

### Request Example

```shell
curl -i -X POST "http://127.0.0.1:8080/security/token" \
		-H "Content-Type: application/json" \
		-d '{
			"email":"user@email.com",
			"password": "12345678"
		}'
```

### Success Response

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 118
connection: keep-alive
date: Sun, 04 Apr 2021 14:16:09 GMT

{"token":"E8D3B322-5001-4DCC-874B-B1FFEDCE0C60","createdAt":"2021-04-04T14:16:09Z","expiresAt":"2021-04-05T14:16:09Z"}
```

### Error Responses

| HTTP Status Code | Details | Known Reasons |
| ---------------  | --------------- | --------------- |
| 400 | The given data was not valid JSON. | JSON Body has issues |
| | | |
| 400 | email is required | email property is absent |
| 400 | email is not a valid email address | email property value is invalid |
| | | |
| 400 | password is required | password property is absent |
| 400 | password is less than minimum of 8 character(s) | password property value is too short |

## Creates a Book (POST)

Creates a new book.

### Headers

**Content-Type: application/json**

**Authorization: Bearer {token}**

### Parameters

None.

### Body

| Parameter | Description |
| ---------------  | --------------- |
| title | String |
| author_name | String |
| genre | "Horror" |
| status | "Reading", "Done" |

### Request Example

```shell
curl -i -X POST "http://127.0.0.1:8080/books" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer {token}" \
    -d '{
    	"title" : "Book Title",
    	"author_name" : "Author Name",
    	"genre" : "Horror",
     	"status" : "Reading"
     }'
```

### Success Response

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 130
connection: keep-alive
date: Fri, 02 Apr 2021 22:22:44 GMT

{"author_name":"Author Name","id":"EAEF0D7C-E537-4114-BA61-5F7517AB4AFA","title":"Book Title","status":"Reading","genre":"Horror"}
```

### Error Responses

| HTTP Status Code | Details | Known Reasons |
| ---------------  | --------------- | --------------- |
| 401 | UserSession not authenticated. | No bearer token was provided. |
| 401 | Unauthorized. | Bearer token is invalid. |
| | | |
| 400 | The given data was not valid JSON. | JSON Body has issues |
| | | |
| 400 | title is required | title property is absent |
| 400 | title is less than minimum of 3 character(s) | title property value is too short |
| | | |
| 400 | author_name is required | author_name property is absent |
| 400 | author_name is not a valid email address | author_name property value is invalid |
| | | |
| 400 | genre is required | genre property is absent |
| 400 | genre is not Horror | genre must be 'Horror' |
| | | |
| 400 | status is required | status property is absent |
| 400 | status is not Reading or Done | status must be 'Reading' or 'Done' |

## Fetch All Books (GET)

Fetchs all books. Supports pagination.

### Headers

**Content-Type: application/json**

**Authorization: Bearer {token}**

### Parameters

**page**: Page Number

**per**: How many records per page

### Body

None.

### Request Example

```shell
curl -i -X GET "http://127.0.0.1:8080/books?page=<page number>&per=<records per page>" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer {token}"
```

### Success Response

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 314
connection: keep-alive
date: Fri, 02 Apr 2021 22:43:41 GMT

{"items":[{"author_name":"Author Name","id":"EAEF0D7C-E537-4114-BA61-5F7517AB4AFA","title":"Book Title","status":"Reading","genre":"Horror"},{"author_name":"Author Name","id":"4E4852C1-5D8C-40B4-B0A8-58FC9827E5FE","title":"Other Book","status":"Reading","genre":"Horror"}],"metadata":{"per":20,"total":2,"page":0}}
```

### Error Responses

| HTTP Status Code | Details | Known Reasons |
| ---------------  | --------------- | --------------- |
| 401 | UserSession not authenticated. | No bearer token was provided. |
| 401 | Unauthorized. | Bearer token is invalid. |
| | | |
| 400 | Value of type 'Int' required for key 'page' | page parameter value must be an Int. |
| | | |
| 400 | Value of type 'Int' required for key 'per' | per parameter value must be an Int. |


## Fetch a Specific Book (GET)

Fetches a book by id.

### Headers

**Content-Type: application/json**

**Authorization: Bearer {token}**

### Parameters

**id**: Book identifier.

### Body

None.

### Request Example

```shell
curl -i -X GET "http://127.0.0.1:8080/books/<id>" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer {token}"
```

### Success Response

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 130
connection: keep-alive
date: Fri, 02 Apr 2021 22:51:15 GMT

{"author_name":"Author Name","id":"EAEF0D7C-E537-4114-BA61-5F7517AB4AFA","title":"Book Title","status":"Reading","genre":"Horror"}
```

### Error Responses

| HTTP Status Code | Details | Known Reasons |
| ---------------  | --------------- | --------------- |
| 401 | UserSession not authenticated. | No bearer token was provided. |
| 401 | Unauthorized. | Bearer token is invalid. |
| | | |
| 400 | Bad Request | id parameter is not a valid UUID. |
| | | |
| 404 | Not Found | A Book with given ID was not found on database. |

## Update a Book (PUT)

Updates a book.

### Headers

**Content-Type: application/json**

**Authorization: Bearer {token}**

### Parameters

**id**: Book identifier.

### Body

| Parameter | Description |
| ---------------  | --------------- |
| title | String |
| author_name | String |
| genre | "Horror" |
| status | "Reading", "Done" |

### Request Example

```shell
curl -i -X PUT "http://127.0.0.1:8080/books/<id>" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer {token}" \
        -d '{
        	"title" : "Book Title",
        	"author_name" : "Author Name",
        	"genre" : "Horror",
	     	"status" : "Reading"
	     }'
```

### Success Response

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 143
connection: keep-alive
date: Fri, 02 Apr 2021 23:05:15 GMT

{"author_name":"Updated Author Name","id":"EAEF0D7C-E537-4114-BA61-5F7517AB4AFA","title":"Updated Book Title","status":"Done","genre":"Horror"}
```

### Error Responses

| HTTP Status Code | Details | Known Reasons |
| ---------------  | --------------- | --------------- |
| 401 | UserSession not authenticated. | No bearer token was provided. |
| 401 | Unauthorized. | Bearer token is invalid. |
| | | |
| 400 | Bad Request | id parameter is not a valid UUID. |
| | | |
| 404 | Not Found | A Book with given ID was not found on database. |
| | | |
| 400 | The given data was not valid JSON. | JSON Body has issues |
| | | |
| 400 | title is required | title property is absent |
| 400 | title is less than minimum of 3 character(s) | title property value is too short |
| | | |
| 400 | author_name is required | author_name property is absent |
| 400 | author_name is not a valid email address | author_name property value is invalid |
| | | |
| 400 | genre is required | genre property is absent |
| 400 | genre is not Horror | genre must be 'Horror' |
| | | |
| 400 | status is required | status property is absent |
| 400 | status is not Reading or Done | status must be 'Reading' or 'Done' |

## Delete a Book (DELETE)

Deletes a book.

### Headers

**Content-Type: application/json**

**Authorization: Bearer {token}**

### Parameters

**id**: Book identifier.

### Body

None.

### Request Example

```shell
curl -i -X DELETE "http://127.0.0.1:8080/books/<id>" \
	-H "Authorization: Bearer {token}"
```
### Success Response

```shell
HTTP/1.1 204 No Content
connection: keep-alive
date: Fri, 02 Apr 2021 23:09:40 GMT
```

### Error Responses

| HTTP Status Code | Details | Known Reasons |
| ---------------  | --------------- | --------------- |
| 401 | UserSession not authenticated. | No bearer token was provided. |
| 401 | Unauthorized. | Bearer token is invalid. |
| | | |
| 400 | Bad Request | id parameter is not a valid UUID. |
| | | |
| 404 | Not Found | A Book with given ID was not found on database. |


# References

* [A generic CRUD solution for Vapor 4](https://theswiftdev.com/a-generic-crud-solution-for-vapor-4/)
