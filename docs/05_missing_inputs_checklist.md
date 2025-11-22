# Missing Inputs Checklist

## Required Inputs from User

### 1. Technology Stack Preferences
- [x] **Backend Framework**: Flask (Python) - **CONFIRMED**
- [x] **Database**: PostgreSQL - **CONFIRMED**
- [ ] **Async Processing**: Celery + Redis recommended (needs confirmation)
- [x] **Authentication Library**: PyJWT (recommended for Flask)
- [ ] **Validation Library**: marshmallow recommended (needs confirmation)
- [ ] **ORM**: SQLAlchemy recommended (needs confirmation)

### 2. Input Data Templates
- [x] **Conversation Input JSON Template**: Complete structure provided (see `07_input_data_schema.md`)
- [ ] **Validation Rules**: Specific validation requirements for each field (partially documented, needs confirmation)
- [ ] **Required vs Optional Fields**: Documented in schema, needs confirmation on edge cases

### 3. Preprocessing Steps
- [x] **Detailed Preprocessing Steps**: Step-by-step preprocessing operations (see `04_processing_pipeline.md`)
- [ ] **Preprocessing Configuration**: Any configurable parameters (filler word list, etc.)
- [ ] **Preprocessing Dependencies**: Any external libraries or services needed

### 4. Output Data Templates
- [x] **Sentiment Analysis Output JSON**: Complete structure provided (see `08_output_data_schema.md`)
- [x] **Processing Result JSON**: Documented in output schema

### 5. Q&A Templates
- [x] **Question JSON Template**: Structure confirmed - Simple text field (see `09_qa_api_schema.md`)
- [x] **Answer JSON Template**: Structure confirmed - Text-based with embedded context (see `10_qa_analysis_strategy.md`)
- [x] **Q&A Validation Rules**: Basic validation documented (question text required, non-empty)

### 6. Authentication & Authorization
- [ ] **Tenant Management**: How are tenants created/managed? (Admin API needed?)
- [ ] **User Management**: How are users created/managed? (Admin API needed?)
- [ ] **Password Policy**: Any specific password requirements?
- [ ] **Token Expiry**: Token expiration time preference

### 7. Database Schema Details
- [x] **Database Choice**: PostgreSQL - **CONFIRMED**
- [ ] **ORM/ODM Preference**: SQLAlchemy recommended (needs confirmation)
- [ ] **Migration Strategy**: Alembic recommended for migrations (needs confirmation)

### 8. Async Processing Details
- [x] **Queue System**: Deferred to future release - Celery + Redis planned
- [x] **Implementation Status**: Async processing is a future feature, not in initial release
- [ ] **Job Status Retention**: How long to keep job status records (to be decided when async is implemented)
- [ ] **Retry Logic**: Should failed jobs be retried? How many times? (to be decided when async is implemented)

### 9. Stub Implementation Details
- [ ] **Sentiment Analysis Stub**: What mock data should be returned?
- [ ] **Q&A Stub**: What mock answers should be returned?
- [ ] **Stub Complexity**: Simple static responses or more realistic mock data?

### 10. Additional Requirements
- [ ] **Logging**: Logging level, format, destination
- [ ] **Monitoring**: Any monitoring/observability requirements
- [ ] **Rate Limiting**: Any rate limiting requirements per tenant
- [ ] **CORS**: CORS configuration if needed
- [ ] **API Versioning**: Versioning strategy preference

### 11. Deployment & Environment
- [x] **Environment Variables**: Configuration via .env file (see .env.example)
- [x] **Docker**: Docker and Docker Compose setup included (see `13_docker_setup.md`)
- [ ] **Testing**: Unit tests, integration tests requirements?

---

## Questions to Clarify

1. **Tenant Isolation**: Should data be completely isolated at database level (separate schemas) or application level (tenant_id filtering)?

2. **Campaign Status**: What are the valid status values and transitions?

3. **Conversation Status**: What triggers status changes? (pending → processing → completed/failed)

4. **Error Recovery**: If preprocessing fails, should partial results be stored?

5. **Data Retention**: Any requirements for data retention/deletion policies?

6. **API Pagination**: Preferred pagination style (offset/limit, cursor-based)?

7. **Search/Filter**: Any requirements for searching/filtering campaigns or conversations?

8. **Bulk Operations**: Need for bulk conversation upload/processing?

9. **Webhooks**: Should async jobs trigger webhooks on completion?

10. **API Documentation**: Should we include Swagger/OpenAPI documentation?

