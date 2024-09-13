
## Installation

Clone repository

```bash
bundle install
```

## Usage
Check rspec tests with
```bash
  rspec/spec/
```
The authentication information should be included by the client in the headers of each request. The headers follow the RFC 6750 Bearer Token format:

Authentication headers example:
```json
"access-token": "wwwww",
"token-type":   "Bearer",
"client":       "xxxxx",
"expiry":       "yyyyy",
"uid":          "zzzzz"
```
Format url for API request
```bash
  localhost/api/posts
  localhost/api/auth/sign_in
  localhost/api/auth 
```
Format of request to api/posts/
```json
  {"post": {
    "title":,
    "body":
  }}
```
