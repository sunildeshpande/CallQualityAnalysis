# Input Data Schema - Conversation Processing

## Conversation Input JSON Structure

The input JSON for processing transcriptions follows this structure:

```json
{
  "transcription": [
    {
      "call_id": "CALL_20250122_001",
      "campaign_id": "CAMPAIGN_OFFERS_Q1",
      "timestamp": "2025-01-22T14:30:00Z",
      "duration_seconds": 420,
      "bot_name": "OfferBot_v2",
      "conversation": [
        {
          "speaker": "bot",
          "timestamp": 0,
          "text": "Hello, thank you for calling. I'm calling regarding our premium credit card offer..."
        },
        {
          "speaker": "customer",
          "timestamp": 2,
          "text": "Yeah, okay, I'm interested. Tell me more about the benefits."
        },
        {
          "speaker": "bot",
          "timestamp": 4,
          "text": "Great! This card offers 2% cashback on all purchases, priority customer support..."
        }
        // ... more conversation turns
      ],
      "metadata": {
        "customer_id": "CUST_12345",
        "campaign_segment": "premium_tier",
        "interaction_outcome": "pending_decision"
      }
    }
    // ... more transcriptions
  ]
}
```

## Field Specifications

### Root Level
- **transcription** (array, required): Array of transcription objects
  - Must contain at least one transcription object
  - Cannot be empty array

### Transcription Object
- **call_id** (string, required): Unique identifier for the call
  - Cannot be empty
  - Must be unique per tenant (enforced at API level)
  
- **campaign_id** (string, required): Identifier for the campaign
  - Cannot be empty
  - Must match an existing campaign for the tenant (validated at API level)
  
- **timestamp** (string, required): ISO8601 datetime string
  - Format: `YYYY-MM-DDTHH:mm:ssZ` or `YYYY-MM-DDTHH:mm:ss+HH:mm`
  - Must be valid datetime
  - Cannot be empty
  
- **duration_seconds** (number/integer, required): Duration of the call in seconds
  - Must be a positive number
  - Must be >= 0
  - Should be integer (can accept float if needed)
  
- **bot_name** (string, required): Name/version of the bot
  - Cannot be empty
  
- **conversation** (array, required): Array of conversation turn objects
  - Must contain at least one conversation turn
  - Cannot be empty array
  
- **metadata** (object, optional): Additional metadata
  - Can be empty object or omitted
  - Structure is flexible but should be validated if specific fields are expected

### Conversation Turn Object
- **speaker** (string, required): Speaker identifier
  - Must be one of: "bot", "customer" (case-sensitive or case-insensitive - to be confirmed)
  - Cannot be empty
  
- **timestamp** (number/integer, required): Timestamp within the call (in seconds)
  - Must be >= 0
  - Should be <= duration_seconds (warning if exceeds)
  - Should be in ascending order (warning if not)
  
- **text** (string, required): The spoken text
  - Cannot be empty
  - Should not be only whitespace (to be confirmed)

### Metadata Object (Optional)
- **customer_id** (string, optional): Customer identifier
- **campaign_segment** (string, optional): Campaign segment identifier
- **interaction_outcome** (string, optional): Outcome of the interaction
- Additional fields allowed (flexible structure)

## Validation Rules

### Required Field Validation
1. Root `transcription` array must exist and not be empty
2. Each transcription must have: `call_id`, `campaign_id`, `timestamp`, `duration_seconds`, `bot_name`, `conversation`
3. Each conversation turn must have: `speaker`, `timestamp`, `text`

### Data Type Validation
1. `call_id`, `campaign_id`, `bot_name`, `text` must be strings
2. `duration_seconds`, `timestamp` (in conversation turns) must be numbers
3. `timestamp` (root level) must be valid ISO8601 datetime string
4. `conversation` must be an array
5. `metadata` must be an object (if present)

### Business Logic Validation
1. `call_id` uniqueness per tenant (checked against database)
2. `campaign_id` must exist for the tenant (checked against database)
3. `duration_seconds` must be >= 0
4. Conversation turn `timestamp` should be >= 0
5. Conversation turn `timestamp` should be <= `duration_seconds` (warning, not error)
6. Conversation turns should be in ascending timestamp order (warning, not error)
7. `speaker` must be valid value ("bot" or "customer")

### Format Validation
1. ISO8601 datetime format validation
2. String non-empty validation
3. Number range validation

## Error Response Format

### Validation Error Example
```json
{
  "error": "Validation error",
  "message": "Input data validation failed",
  "details": {
    "transcription[0].call_id": ["Field is required"],
    "transcription[0].conversation[1].speaker": ["Invalid speaker value. Must be 'bot' or 'customer'"],
    "transcription[0].timestamp": ["Invalid datetime format. Expected ISO8601 format"],
    "transcription[1].duration_seconds": ["Must be a positive number"]
  }
}
```

## Questions to Clarify

1. **Speaker Values**: Are "bot" and "customer" case-sensitive? Are there other valid values?
2. **Conversation Order**: Should timestamps be strictly ascending, or can they be equal?
3. **Empty Text**: Should empty or whitespace-only text be rejected or allowed?
4. **Metadata Structure**: Is the metadata structure completely flexible, or are there required/expected fields?
5. **Multiple Transcriptions**: Can a single API call process multiple transcriptions, or should it be one at a time?
6. **Timestamp Precision**: What precision is expected for conversation turn timestamps (seconds, milliseconds)?
7. **Duration Validation**: Should we validate that the last conversation turn timestamp doesn't exceed duration_seconds?

