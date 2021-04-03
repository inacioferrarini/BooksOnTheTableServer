# BooksOnTheTableServer

Books On The Table Project back-end.

This back-end uses is made in **Swift** and **Vapor**.

Data is persistend using a SQLite database through **Fluent ORM**.

## Como utilizar o backend

Para preparar a base de dados:

```swift
swift run Run migrate
```

Para usar o backend, execute

```swift
swift run Run
```

# Features

## Creates a User

Creates a new user.

### Parameters

None.

### Request

```shell
curl -i -X POST "http://127.0.0.1:8080/users" \
        -H "Content-Type: application/json" \
        -d '{
        	"name" : "User Name",
        	"email" : "email@provider.com.br",
	     	"password" : "123123@11acc"
	     }'
```

### Success Response

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 40
connection: keep-alive
date: Sat, 03 Apr 2021 11:42:38 GMT

{"name":"User Name","email":"User Name"}
```

## User Authetication

```shell
```

## Creates a Book

Creates a new book.

Although the password is provided plain, it will be encrypted upon saving.

### Parameters

None.

### Request

```shell
curl -i -X POST "http://127.0.0.1:8080/books" \
        -H "Content-Type: application/json" \
        -d '{
        	"title" : "Book Title",
        	"author_name" : "Author Name",
        	"genre" : "Horror",
	     	"status" : "Reading"
	     }'
```

### Success Response

Returns status: 200 (OK)
Also, returns the given body plus the book ID.

```shell
HTTP/1.1 200 OK
content-type: application/json; charset=utf-8
content-length: 130
connection: keep-alive
date: Fri, 02 Apr 2021 22:22:44 GMT

{"author_name":"Author Name","id":"EAEF0D7C-E537-4114-BA61-5F7517AB4AFA","title":"Book Title","status":"Reading","genre":"Horror"}
```

## Fetch All Books

Fetchs all books. Supports pagination.

### Parameters

**page**: Page Number

**per**: How many records per page

### Request

```shell
curl -i -X GET "http://127.0.0.1:8080/books?page=<page number>&per=<records per page>" \
	-H "Content-Type: application/json"
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

## Fetch a Specific Book

Fetchs a book by id.

### Parameters

None.

### Request

```shell
curl -i -X GET "http://127.0.0.1:8080/books/<id>" \
	-H "Content-Type: application/json"
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

## Update a Book

Updates a book.

### Parameters

**id**: book identifier.

### Request

```shell
curl -i -X PUT "http://127.0.0.1:8080/books/<id>" \
        -H "Content-Type: application/json" \
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

## Delete a Book

Deletes a book.

### Parameters

**id**: book identifier.

### Request

```shell
curl -i -X DELETE "http://127.0.0.1:8080/books/<id>"
```
### Success Response

```shell
HTTP/1.1 204 No Content
connection: keep-alive
date: Fri, 02 Apr 2021 23:09:40 GMT
```

# References

* [A generic CRUD solution for Vapor 4](https://theswiftdev.com/a-generic-crud-solution-for-vapor-4/)
