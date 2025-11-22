# Authentication & Authorization Flow

## Authentication Mechanism

### JWT Token Based Authentication
- Uses JWT (JSON Web Tokens) for stateless authentication
- Token contains tenant_id and user_id for authorization

### Token Structure
```json
{
  "sub": "user_id",
  "tenant_id": "tenant_id",
  "username": "username",
  "iat": 1234567890,
  "exp": 1234571490
}
```

## Login Flow

1. **Client Request**
   - POST /auth/login
   - Credentials: tenant_id, username, password

2. **Server Validation**
   - Verify tenant exists and is active
   - Verify user exists for tenant
   - Verify password (hashed comparison)
   - Verify user is active

3. **Token Generation**
   - Generate JWT token
   - Include tenant_id, user_id, username
   - Set expiration time

4. **Response**
   - Return access_token
   - Return token_type ("bearer")
   - Return expires_in (seconds)

## Authorization Middleware

### Token Validation
1. Extract token from Authorization header
2. Verify token signature
3. Verify token expiration
4. Extract tenant_id from token
5. Attach tenant_id and user_id to request context

### Tenant Isolation
- All database queries automatically filtered by tenant_id
- Prevents cross-tenant data access
- Applied at middleware/ORM level

## Protected Endpoints

All endpoints except `/auth/login` require:
- Valid JWT token in Authorization header
- Token must not be expired
- Tenant must be active

## Error Responses

### 401 Unauthorized
- Missing token
- Invalid token signature
- Expired token

### 403 Forbidden
- Token valid but tenant/user inactive
- Insufficient permissions (if role-based access added later)

## Security Considerations

1. **Password Storage**: Passwords stored as hashed (bcrypt/argon2)
2. **Token Expiry**: Configurable token expiration
3. **HTTPS**: All API calls should use HTTPS in production
4. **Token Refresh**: (Optional) Consider refresh token mechanism for long-lived sessions

