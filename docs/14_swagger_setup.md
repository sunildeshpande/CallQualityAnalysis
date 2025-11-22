# Swagger/OpenAPI Documentation Setup

## Overview

The API is documented using OpenAPI 3.0 specification (Swagger 3.0). The specification file is located at `swagger.yaml` in the project root.

## Viewing Swagger Documentation

### Option 1: Swagger UI (Recommended)

1. **Install Flask-RESTX** (includes Swagger UI):
   ```bash
   pip install flask-restx
   ```

2. **Add to your Flask app**:
   ```python
   from flask_restx import Api, Resource
   
   api = Api(
       app,
       version='1.0',
       title='Call Quality Analysis API',
       description='A tenant-based API system for analyzing call quality',
       doc='/swagger/'  # Swagger UI will be available at /swagger/
   )
   ```

3. **Access Swagger UI**:
   - Development: http://localhost:5000/swagger/
   - Production: https://your-domain.com/swagger/

### Option 2: Standalone Swagger UI

1. **Use Swagger Editor** (online):
   - Go to https://editor.swagger.io/
   - Import `swagger.yaml` file
   - View and test the API

2. **Use Swagger UI Docker container**:
   ```bash
   docker run -p 8080:8080 -e SWAGGER_JSON=/swagger.yaml -v $(pwd):/swagger swaggerapi/swagger-ui
   ```
   - Access at: http://localhost:8080

3. **Use Redoc** (alternative):
   ```bash
   npm install -g redoc-cli
   redoc-cli serve swagger.yaml
   ```

## Integration with Flask

### Using Flask-RESTX

Flask-RESTX provides automatic Swagger documentation generation:

```python
from flask import Flask
from flask_restx import Api, Resource, fields

app = Flask(__name__)
api = Api(
    app,
    version='1.0',
    title='Call Quality Analysis API',
    description='A tenant-based API system',
    doc='/swagger/',
    prefix='/api/v1'
)

# Define models
login_model = api.model('LoginRequest', {
    'tenant_id': fields.String(required=True),
    'username': fields.String(required=True),
    'password': fields.String(required=True)
})

# Define routes
@api.route('/auth/login')
class Login(Resource):
    @api.expect(login_model)
    @api.marshal_with(login_response_model)
    def post(self):
        # Implementation
        pass
```

### Using Flask-Swagger-UI (Simpler)

For a simpler setup without code changes:

```python
from flask import Flask
from flask_swagger_ui import get_swaggerui_blueprint

app = Flask(__name__)

SWAGGER_URL = '/swagger'
API_URL = '/static/swagger.yaml'

swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': "Call Quality Analysis API"
    }
)

app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)
```

## Swagger File Structure

The `swagger.yaml` file includes:

- **API Information**: Title, description, version
- **Servers**: Base URLs for different environments
- **Tags**: API endpoint categories
- **Paths**: All API endpoints with:
  - Request/response schemas
  - Authentication requirements
  - Examples
  - Error responses
- **Components**: Reusable schemas and responses
- **Security Schemes**: JWT bearer token authentication

## Key Endpoints Documented

1. **Authentication**
   - `POST /auth/login` - Tenant login

2. **Campaigns**
   - `GET /campaigns` - List campaigns
   - `POST /campaigns` - Create campaign
   - `GET /campaigns/{campaign_id}` - Get campaign details

3. **Conversations**
   - `POST /conversations/process` - Process conversations

4. **Q&A**
   - `POST /conversations/{call_id}/qa` - Ask question

5. **Jobs** (Future)
   - `GET /jobs/{job_id}/status` - Get job status

## Testing with Swagger UI

Swagger UI allows you to:
- View all API endpoints
- See request/response schemas
- Test APIs directly from the browser
- View example requests and responses
- Test authentication

## Updating Swagger Documentation

When adding new endpoints or modifying existing ones:

1. Update `swagger.yaml` file
2. Add new schemas to `components/schemas`
3. Add new paths under `paths`
4. Update examples and descriptions
5. Regenerate Swagger UI (if using Flask-RESTX, it's automatic)

## Validation

Validate your Swagger file:

```bash
# Using swagger-codegen
swagger-codegen validate -i swagger.yaml

# Using online validator
# https://editor.swagger.io/ (has built-in validation)
```

## Best Practices

1. **Keep it updated**: Update Swagger docs when API changes
2. **Use examples**: Include realistic examples for all endpoints
3. **Document errors**: Include all possible error responses
4. **Use schemas**: Reuse schemas to avoid duplication
5. **Version control**: Keep Swagger file in version control

## Production Considerations

1. **Security**: Don't expose Swagger UI in production (or protect it)
2. **Performance**: Swagger UI adds minimal overhead
3. **Documentation**: Keep Swagger docs as source of truth
4. **Testing**: Use Swagger for API contract testing

## Additional Resources

- [OpenAPI Specification](https://swagger.io/specification/)
- [Flask-RESTX Documentation](https://flask-restx.readthedocs.io/)
- [Swagger UI](https://swagger.io/tools/swagger-ui/)
- [Swagger Editor](https://editor.swagger.io/)

