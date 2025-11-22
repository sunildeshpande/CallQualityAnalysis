# Data Models

## 1. Tenant
```json
{
  "tenant_id": "string (UUID)",
  "name": "string",
  "created_at": "ISO8601 datetime",
  "is_active": "boolean"
}
```

## 2. User (Tenant User)
```json
{
  "user_id": "string (UUID)",
  "tenant_id": "string (UUID)",
  "username": "string",
  "email": "string",
  "password_hash": "string",
  "created_at": "ISO8601 datetime",
  "is_active": "boolean"
}
```

## 3. Campaign
```json
{
  "campaign_id": "string (UUID)",
  "tenant_id": "string (UUID)",
  "name": "string",
  "description": "string (optional)",
  "start_date": "ISO8601 datetime (optional)",
  "end_date": "ISO8601 datetime (optional)",
  "status": "active|inactive|archived",
  "created_at": "ISO8601 datetime",
  "updated_at": "ISO8601 datetime"
}
```

## 4. Conversation
```json
{
  "conversation_id": "string (UUID)",
  "campaign_id": "string (UUID)",
  "tenant_id": "string (UUID)",
  "call_id": "string (unique per tenant)",
  "raw_data": "JSON object",
  "processed_data": "JSON object (optional)",
  "status": "pending|processing|completed|failed",
  "created_at": "ISO8601 datetime",
  "processed_at": "ISO8601 datetime (optional)",
  "error_message": "string (optional)"
}
```

## 5. Processing Job
```json
{
  "job_id": "string (UUID)",
  "conversation_id": "string (UUID)",
  "tenant_id": "string (UUID)",
  "status": "pending|processing|completed|failed",
  "processing_mode": "sync|async",
  "submitted_at": "ISO8601 datetime",
  "started_at": "ISO8601 datetime (optional)",
  "completed_at": "ISO8601 datetime (optional)",
  "result": "JSON object (optional)",
  "error": "JSON object (optional)"
}
```

## 6. Sentiment Analysis Result
```json
{
  "conversation_id": "string (UUID)",
  "call_id": "string",
  "sentiment_scores": {
    // Structure to be defined based on output JSON template
  },
  "analysis_timestamp": "ISO8601 datetime"
}
```

## 7. Q&A Record
```json
{
  "qa_id": "string (UUID)",
  "conversation_id": "string (UUID)",
  "call_id": "string",
  "tenant_id": "string (UUID)",
  "question": {
    "text": "string",
    "detected_type": "boolean|categorical|numeric|textual"
  },
  "answer": {
    "text": "string",
    "type": "boolean|categorical|numeric|textual"
  },
  "created_at": "ISO8601 datetime"
}
```

**Field Specifications**:
- **question.text** (string, required): The question text as provided by the user
- **question.detected_type** (string, required): The question type detected by the system
  - Values: `boolean`, `categorical`, `numeric`, `textual`
- **answer.text** (string, required): The answer text with embedded context/details
  - Format: "Answer - Details" or "Answer (Details)"
  - Self-contained and human-readable
- **answer.type** (string, required): The answer type (matches detected question type)
  - Values: `boolean`, `categorical`, `numeric`, `textual`

**Example**:
```json
{
  "qa_id": "550e8400-e29b-41d4-a716-446655440000",
  "conversation_id": "660e8400-e29b-41d4-a716-446655440001",
  "call_id": "CALL_20250122_001",
  "tenant_id": "770e8400-e29b-41d4-a716-446655440002",
  "question": {
    "text": "Was the call focused on the campaign topic?",
    "detected_type": "boolean"
  },
  "answer": {
    "text": "Yes (94% keyword coverage, strong focus on credit card benefits throughout)",
    "type": "boolean"
  },
  "created_at": "2025-01-22T15:30:00Z"
}
```

## Database Relationships
```
Tenant (1) ----< (N) Campaign
Tenant (1) ----< (N) User
Campaign (1) ----< (N) Conversation
Conversation (1) ----< (1) ProcessingJob
Conversation (1) ----< (N) QARecord
```

## Indexes
- `call_id` + `tenant_id` (unique constraint)
- `campaign_id` (indexed for queries)
- `tenant_id` (indexed for all tenant-scoped tables)
- `job_id` (indexed for status queries)
- `status` (indexed for filtering)

