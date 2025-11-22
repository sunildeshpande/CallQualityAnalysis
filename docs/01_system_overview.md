# System Overview - Call Quality Analysis with Sentiment Analysis

## Purpose
A tenant-based API system for analyzing call quality through sentiment analysis of conversations. The system supports campaign management, conversation processing, and Q&A functionality.

## Key Features
1. **Multi-tenant Architecture**: Tenant-based authentication and data isolation
2. **Campaign Management**: Organize conversations under campaigns
3. **Conversation Processing**: Input validation, preprocessing, and sentiment analysis
4. **Sync Processing**: Synchronous processing (async mode planned for future release)
5. **Q&A System**: Question-answer functionality based on conversation transcripts

## Architecture Layers

### 1. Authentication Layer
- Tenant-based login
- JWT token generation
- Token validation middleware

### 2. API Layer
- RESTful APIs for all operations
- Request validation
- Response formatting

### 3. Business Logic Layer
- Campaign management
- Conversation processing
- Data validation
- Preprocessing pipeline
- Sentiment analysis (stubbed initially)
- Q&A processing (stubbed initially)

### 4. Data Layer
- Tenant data isolation
- Campaign storage
- Conversation storage
- Processing results storage

## Technology Stack
- **Framework**: Flask (Python)
- **Database**: PostgreSQL
- **ORM**: SQLAlchemy (recommended for Flask + PostgreSQL)
- **Authentication**: JWT tokens (PyJWT)
- **Async Processing**: Deferred to future release (Celery with Redis planned)
- **Validation**: Flask-WTF or marshmallow (for request validation)
- **API Documentation**: Flask-RESTX or Flask-Swagger-UI (for Swagger/OpenAPI docs)

