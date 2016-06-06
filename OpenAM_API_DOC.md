## OpenAM APIs used

Tested with OpenAM version 13.0, please reference [official API document](https://backstage.forgerock.com/#!/docs/openam/13/dev-guide#openam-apis)


## Get Server Info

##### request: 

```yml
	url: <openam_url>/json/serverinfo/*
	method: GET
	headers:
     Content-Type: application/json
     
   # example:
   # https://yourdomain.com/openam/json/serverinfo/*
```
	
##### response: 
	
```ruby
	{
	  "domains": [
	    ".yourdomain.com"
	  ],
	  "protectedUserAttributes": [],
	  "cookieName": "iPlanetDirectoryPro",
	  "secureCookie": true,
	  "forgotPassword": "false",
	  "forgotUsername": "false",
	  "kbaEnabled": "false",
	  "selfRegistration": "false",
	  "lang": "en-US",
	  "successfulUserRegistrationDestination": "default",
	  "socialImplementations": [],
	  "referralsEnabled": "false",
	  "zeroPageLogin": {
	    "enabled": false,
	    "refererWhitelist": [],
	    "allowedWithoutReferer": true
	  },
	  "realm": "/",
	  "xuiUserSessionValidationEnabled": true
	}
```

----

## Validate Token:
##### request: 
```yml
    url: <openam_url>/json/sessions/<token>
    method: POST
    headers:
        Content-Type: application/json
    query:
        _action: validate
		
	# example:
	# https://yourdomain.com/openam/json/sessions/AQPC5xd2qZDGxdwlgifS9_jPQT2gO5BfvGhB-HdlJNE6N0.*AAJTSQACMDEAAlNLABM1NzQyODQ2MDc3HSFDOTIxNjU2AAJTMQAA*?_action=validate
```

##### response: 

success:
  
  ````ruby
	{
	  "valid": true,
	  "uid": "john.rambo",
	  "realm": "/"
	}  	
  ````
  
error:

  ````ruby
	{
	  "valid": false
	}
  ````
  
  ----
  
## Get User Attributes:
##### request: 

```yml
    url: <openam_url>/json/users/<uid>
    method: GET
    headers:
        Content-Type: application/json
        iPlanetDirectoryPro: <TOKEN>
    query:
        _action: validate
		
	# example:
	# https://yourdomain.com/openam/json/users/john.rambo
```

##### response:
success:
  
```ruby
	{
	  "username": "john.rambo",
	  "realm": "/",
	  "mail": ["john.rambo@example.com"],
	  "givenName": ["John"],
	  "objectClass": [],
	  "dn": ["uid=john.rambo,ou=people,dc=openam,dc=forgerock,dc=org"],
	  "cn": ["John Rambo"],
	  "createTimestamp": ["20160201004947Z"],
	  "modifyTimestamp": ["20160602024339Z"],
	  "employeeNumber": ["123456789"],
	  "uid": ["john.rambo"],
	  "postalAddress": ["12345ABCDE"],
	  "universalid": ["id=john.rambo,ou=user,dc=openam,dc=forgerock,dc=org"],
	  "inetUserStatus": ["Active"],
	  "sn": ["Rambo"],
	  "roles": ["ui-self-service-user"
	  ]
	}
```

  
error:

  ````ruby
	{
	  "code": 401,
	  "reason": "Unauthorized",
	  "message": "Access Denied"
	}
  ````
  
----
  
## Logout:
##### request: 

```yml
    url: <openam_url>/json/sessions/
    method: POST
    headers:
        Content-Type: application/json
        iPlanetDirectoryPro: <TOKEN>
    query:
        _action: logout
		
	# example:
	# https://yourdomain.com/openam/json/sessions/?_action=logout
```

##### response:
success:
  
```ruby
	{
		"result": "Successfully logged out"
	}
```
