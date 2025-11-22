# Technology Stack

## Confirmed Technologies

### Backend Framework
- **Flask** (Python)
  - Lightweight and flexible web framework
  - Good for RESTful APIs
  - Extensive ecosystem of extensions

### Database
- **PostgreSQL**
  - Relational database with strong ACID compliance
  - Excellent for multi-tenant data isolation
  - JSON support for flexible data storage
  - Robust indexing and querying capabilities

## Recommended Technologies

### ORM (Object-Relational Mapping)
- **SQLAlchemy**
  - Industry standard ORM for Python
  - Excellent PostgreSQL support
  - Supports both ORM and raw SQL queries
  - Migration support via Alembic

### Authentication
- **PyJWT**
  - JWT token generation and validation
  - Lightweight and widely used
  - Good Flask integration

### Async Processing (Future Feature)
- **Celery** (planned for future implementation)
  - Distributed task queue
  - Excellent for background job processing
  - Supports both sync and async modes
  - Good Flask integration via Flask-Celery
  - **Note**: Not required for initial implementation

### Message Broker (for Celery - Future)
- **Redis** (recommended for simplicity)
  - Fast in-memory data store
  - Can also be used for caching
  - Easy to set up and configure
- **RabbitMQ** (alternative)
  - More robust message queue
  - Better for complex routing scenarios
  - More setup complexity

**Implementation Status**: Async processing is deferred to a future release. The API will accept the `async` parameter but return `501 Not Implemented` until implemented.

### Request Validation
- **marshmallow** (recommended)
  - Schema validation and serialization
  - Good Flask integration
  - Type-safe validation
- **Flask-WTF** (alternative)
  - Form validation
  - CSRF protection
  - Good for form-based APIs

### API Documentation
- **OpenAPI 3.0** (Swagger 3.0)
  - Complete API specification in `swagger.yaml`
  - Interactive API documentation
- **Flask-RESTX** (recommended for integration)
  - Swagger/OpenAPI documentation
  - Request/response validation
  - API versioning support
  - Automatic Swagger UI generation
- **Flask-Swagger-UI** (alternative)
  - Simple Swagger UI integration
  - Less features but simpler setup

See `14_swagger_setup.md` for Swagger integration details.

### Additional Libraries
- **python-dotenv**: Environment variable management
- **psycopg2** or **psycopg2-binary**: PostgreSQL adapter
- **bcrypt** or **argon2**: Password hashing
- **python-dateutil**: Date/time parsing and manipulation

## Project Structure Recommendations

```
call_quality_analysis/
├── app/
│   ├── __init__.py
│   ├── models/          # SQLAlchemy models
│   ├── routes/          # Flask routes/blueprints
│   ├── services/        # Business logic
│   ├── utils/           # Utilities (validation, preprocessing)
│   ├── middleware/      # Auth middleware, etc.
│   └── config.py        # Configuration
├── migrations/          # Alembic migrations
├── tests/               # Test files
├── requirements.txt     # Python dependencies
├── .env                 # Environment variables
└── run.py               # Application entry point
```

## Database Schema Approach

- **Multi-tenant isolation**: Application-level (tenant_id in all tables)
- **Migrations**: Alembic for schema versioning
- **Indexes**: Strategic indexes on tenant_id, call_id, campaign_id, etc.

## Development Setup

### Python Version
- Python 3.9+ (recommended: 3.10 or 3.11)

### Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### Key Dependencies (Initial Implementation)
```
Flask>=2.3.0
SQLAlchemy>=2.0.0
psycopg2-binary>=2.9.0
PyJWT>=2.8.0
marshmallow>=3.20.0
python-dotenv>=1.0.0
bcrypt>=4.0.0
```

### Optional Dependencies (Future Features)
```
Celery>=5.3.0          # For async processing (future)
Redis>=5.0.0            # For Celery broker (future)
```

## Deployment Considerations

### Production Recommendations
- **WSGI Server**: Gunicorn or uWSGI
- **Reverse Proxy**: Nginx
- **Process Manager**: Supervisor or systemd
- **Database Connection Pooling**: SQLAlchemy connection pooling
- **Caching**: Redis for session storage and caching
- **Monitoring**: Flask monitoring extensions or external tools

### Environment Variables
- Database connection strings
- JWT secret keys
- Redis/Celery broker URLs
- API keys (if needed for future integrations)

## Docker & Containerization

- **Docker**: Application containerization
- **Docker Compose**: Multi-container orchestration
- **PostgreSQL Container**: Database in container
- **Volume Persistence**: Data persistence across container restarts

See `13_docker_setup.md` for detailed Docker setup and database initialization instructions.

## Questions for User

1. **Async Processing**: Confirm Celery + Redis, or prefer a different approach?
2. **Validation Library**: Prefer marshmallow or Flask-WTF?
3. **API Documentation**: Include Swagger/OpenAPI docs? (Flask-RESTX recommended)
4. **Password Hashing**: Prefer bcrypt or argon2?
5. **Python Version**: Any specific version requirement?

