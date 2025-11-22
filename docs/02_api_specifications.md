# API Specifications

## Base URL
```
/api/v1
```

## Authentication
All APIs (except login) require JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

---

## 1. Tenant Login API

### Endpoint
```
POST /auth/login
```

### Request Body
```json
{
  "tenant_id": "string",
  "username": "string",
  "password": "string"
}
```

### Response (Success - 200)
```json
{
  "access_token": "string",
  "token_type": "bearer",
  "expires_in": 3600,
  "tenant_id": "string"
}
```

### Response (Error - 401)
```json
{
  "error": "Invalid credentials",
  "message": "string"
}
```

---

## 2. Create Campaign API

### Endpoint
```
POST /campaigns
```

### Headers
```
Authorization: Bearer <token>
```

### Request Body
```json
{
  "name": "string",
  "description": "string (optional)",
  "start_date": "ISO8601 datetime (optional)",
  "end_date": "ISO8601 datetime (optional)"
}
```

### Response (Success - 201)
```json
{
  "campaign_id": "string (UUID)",
  "name": "string",
  "description": "string",
  "tenant_id": "string",
  "created_at": "ISO8601 datetime",
  "status": "active"
}
```

### Response (Error - 400)
```json
{
  "error": "Validation error",
  "message": "string",
  "details": {
    "field": ["error message"]
  }
}
```

---

## 3. Process Conversation API

### Endpoint
```
POST /conversations/process
```

### Headers
```
Authorization: Bearer <token>
```

### Query Parameters
```
async: boolean (default: false)
```

**Note**: The `async` parameter is reserved for future implementation. Currently, all processing is synchronous. If `async=true` is provided, the API will return a `501 Not Implemented` error indicating that async processing is a planned feature.

### Request Body
```json
{
  "transcription": [
    {
      "call_id": "string",
      "campaign_id": "string",
      "timestamp": "ISO8601 datetime",
      "duration_seconds": 420,
      "bot_name": "string",
      "conversation": [
        {
          "speaker": "bot|customer",
          "timestamp": 0,
          "text": "string"
        }
      ],
      "metadata": {
        "customer_id": "string (optional)",
        "campaign_segment": "string (optional)",
        "interaction_outcome": "string (optional)"
      }
    }
  ]
}
```

**Note**: The API accepts an array of transcriptions. Each transcription contains:
- `call_id`: Unique identifier for the call (must be unique per tenant)
- `campaign_id`: Campaign identifier (must exist for the tenant)
- `timestamp`: ISO8601 datetime of the call
- `duration_seconds`: Call duration in seconds
- `bot_name`: Name/version of the bot
- `conversation`: Array of conversation turns with speaker, timestamp, and text
- `metadata`: Optional metadata object

See `07_input_data_schema.md` for detailed validation rules.

### Response (Sync - 200)
```json
{
  "job_id": "string (UUID)",
  "status": "completed",
  "processed_at": "ISO8601 datetime",
  "results": [
    {
      "call_id": "string",
      "campaign_id": "string",
      "status": "completed|failed",
      "result": {
        "report_metadata": {
          "report_id": "string",
          "generated_at": "ISO8601 datetime",
          "campaign_id": "string",
          "transcription_count": 1,
          "analysis_duration_ms": 2340
        },
        "call_details": {
          "call_id": "string",
          "duration": "string",
          "sentiment_trend": "string",
          "bot_performance_score": 8.2,
          "customer_engagement_score": 8.5
        },
        "quality_analysis": {
          "metrics": [
            {
              "question_id": "string",
              "question": "string",
              "answer": "string|number",
              "answer_type": "boolean|categorical|numeric|boolean_with_details",
              "confidence": 0.94,
              "supporting_evidence": ["string"],
              "sentiment_score": 0.78,
              "sentiment_trajectory": [{"segment": "string", "sentiment": "string"}],
              "new_requests": ["string"],
              "unresolved_count": 1,
              "time_breakdown": {"main_offer": "string", "additional_queries": "string", "closing": "string", "total": "string"},
              "interest_level": 0.82,
              "next_steps": "string",
              "conversion_probability": 0.75
            }
          ]
        },
        "summary_insights": {
          "overall_quality_score": 8.35,
          "strengths": ["string"],
          "areas_for_improvement": ["string"],
          "recommendations": ["string"]
        }
      },
      "error": {
        "message": "string",
        "code": "string"
      } // (if failed)
    }
  ]
}
```

**Note**: When processing multiple transcriptions, results are returned as an array. Each result corresponds to one transcription in the input. See `08_output_data_schema.md` for detailed output structure.

### Response (Async - 202) - **Future Feature**
```json
{
  "job_id": "string (UUID)",
  "status": "processing",
  "submitted_at": "ISO8601 datetime",
  "transcription_count": 2,
  "status_url": "/api/v1/jobs/{job_id}/status"
}
```

**Note**: Async processing is a planned future feature. Currently not implemented. The API will return `501 Not Implemented` if `async=true` is requested.

### Response (Error - 501) - Async Not Implemented
```json
{
  "error": "Not Implemented",
  "message": "Async processing is a planned feature and will be available in a future release",
  "current_mode": "sync"
}
```

### Response (Error - 400)
```json
{
  "error": "Validation error",
  "message": "string",
  "details": {
    "field": ["error message"]
  }
}
```

---

## 4. Get Job Status API (for async processing) - **Future Feature**

### Endpoint
```
GET /jobs/{job_id}/status
```

**Note**: This endpoint is reserved for future async processing implementation. Currently returns `501 Not Implemented`.

### Headers
```
Authorization: Bearer <token>
```

### Response (200)
```json
{
  "job_id": "string (UUID)",
  "status": "processing|completed|failed",
  "submitted_at": "ISO8601 datetime",
  "completed_at": "ISO8601 datetime (if completed)",
  "transcription_count": 2,
  "processed_count": 1,
  "failed_count": 0,
  "results": [
    {
      "call_id": "string",
      "campaign_id": "string",
      "status": "completed|failed",
      "result": {
        "report_metadata": {
          "report_id": "string",
          "generated_at": "ISO8601 datetime",
          "campaign_id": "string",
          "transcription_count": 1,
          "analysis_duration_ms": 2340
        },
        "call_details": {
          "call_id": "string",
          "duration": "string",
          "sentiment_trend": "string",
          "bot_performance_score": 8.2,
          "customer_engagement_score": 8.5
        },
        "quality_analysis": {
          "metrics": []
        },
        "summary_insights": {
          "overall_quality_score": 8.35,
          "strengths": ["string"],
          "areas_for_improvement": ["string"],
          "recommendations": ["string"]
        }
      },
      "error": {
        "message": "string",
        "code": "string"
      } // (if failed)
    }
  ],
  "error": {
    "message": "string",
    "code": "string"
  } // (if entire job failed)
}
```

**Note**: For batch processing, the status endpoint returns results for all transcriptions in the job.

---

## 5. Question & Answer API

### Endpoint
```
POST /conversations/{call_id}/qa
```

### Headers
```
Authorization: Bearer <token>
```

### Request Body
```json
{
  "question": {
    "text": "What was the main concern raised by the customer?"
  }
}
```

**Field Specifications**:
- **text** (string, required): The question text
  - Cannot be empty
  - System automatically determines question type (Boolean, Categorical, Numeric, Textual)
  - See `10_qa_analysis_strategy.md` for question types and analysis strategies

### Response (200)
```json
{
  "call_id": "string",
  "question": {
    "text": "Was the call focused on the campaign topic?",
    "detected_type": "boolean|categorical|numeric|textual"
  },
  "answer": {
    "text": "Yes (94% keyword coverage, strong focus on credit card benefits throughout)",
    "type": "boolean"
  },
  "answered_at": "ISO8601 datetime"
}
```

**Answer Format**:
- **text** (string, required): The answer text with embedded context/details
  - Format: "Answer - Details" or "Answer (Details)"
  - Self-contained and human-readable
- **type** (string, required): The detected question type
  - Values: `boolean`, `categorical`, `numeric`, `textual`

**Examples**:
- Boolean: `"Yes (94% keyword coverage, strong focus on credit card benefits throughout)"`
- Categorical: `"Positive - Customer showed interest, asked follow-up questions, expressed satisfaction"`
- Numeric: `"72% - 5 min 2 sec out of 7 min total discussion on primary offer benefits"`
- Textual: `"Summary text with additional context and details"`

See `10_qa_analysis_strategy.md` for detailed examples and format patterns.

### Response (Error - 404)
```json
{
  "error": "Conversation not found",
  "message": "No conversation found for call_id: {call_id}"
}
```

---

## 6. List Campaigns API

### Endpoint
```
GET /campaigns
```

### Headers
```
Authorization: Bearer <token>
```

### Query Parameters
```
page: integer (default: 1)
limit: integer (default: 20)
```

### Response (200)
```json
{
  "campaigns": [
    {
      "campaign_id": "string",
      "name": "string",
      "description": "string",
      "created_at": "ISO8601 datetime",
      "status": "string"
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 20
}
```

---

## 7. Get Campaign Details API

### Endpoint
```
GET /campaigns/{campaign_id}
```

### Headers
```
Authorization: Bearer <token>
```

### Response (200)
```json
{
  "campaign_id": "string",
  "name": "string",
  "description": "string",
  "tenant_id": "string",
  "created_at": "ISO8601 datetime",
  "conversation_count": 10,
  "status": "active"
}
```

---

## Error Response Format (Standard)
All error responses follow this format:
```json
{
  "error": "Error type",
  "message": "Human readable error message",
  "details": {} // Optional additional details
}
```

### HTTP Status Codes
- `200` - Success
- `201` - Created
- `202` - Accepted (async job submitted)
- `400` - Bad Request (validation errors)
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

