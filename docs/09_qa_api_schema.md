# Q&A API Schema - Question and Answer Templates

## Overview

The Q&A API allows users to ask custom questions about conversation transcripts. This is separate from the quality analysis metrics that are automatically generated during sentiment analysis.

**Key Points**:
- Question input is a simple text string
- The system automatically determines the question type (Boolean, Categorical, Numeric, Textual)
- Answer structure varies based on the detected question type

See `10_qa_analysis_strategy.md` for detailed information on question types and analysis strategies.

---

## Q&A API Request - Question JSON

### Question Input Structure
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
  - No specific format requirements
  - System will analyze and determine question type automatically

**Note**: The question type is NOT specified in the input. The system analyzes the question text and determines whether it's:
- **Boolean**: Questions asking yes/no, presence/absence
- **Categorical**: Questions asking for classification into categories
- **Numeric**: Questions asking for numbers, counts, percentages
- **Textual**: Questions asking for summaries, key phrases, or extracted text

---

## Q&A API Response - Answer JSON

The answer structure varies based on the detected question type. See `10_qa_analysis_strategy.md` for detailed structures for each type.

### Common Response Structure
```json
{
  "call_id": "string",
  "question": {
    "text": "string",
    "detected_type": "boolean|categorical|numeric|textual"
  },
  "answer": {
    // Structure varies by question type - see 10_qa_analysis_strategy.md
    "text": "string",
    "type": "boolean|categorical|numeric|textual",
    "confidence": 0.85
  },
  "answered_at": "ISO8601 datetime"
}
```

**Note**: The exact answer structure depends on the question type. Please confirm the answer structures for each type in `10_qa_analysis_strategy.md`.

---

## Current Status

✅ **Question Input Structure**: Confirmed - Simple text field
✅ **Question Type Detection**: Auto-detected by system (Boolean, Categorical, Numeric, Textual)
✅ **Answer Structure**: Confirmed - Simple text-based with embedded context (see `10_qa_analysis_strategy.md`)

## Confirmed Structure

✅ **Question Input**: Simple text field - `{"question": {"text": "..."}}`
✅ **Answer Output**: Simple text-based with embedded context - `{"answer": {"text": "Answer - Details", "type": "..."}}`
✅ **Answer Types**: Boolean, Categorical, Numeric, Textual
✅ **Format Pattern**: "Answer - Details" or "Answer (Details)"

See `10_qa_analysis_strategy.md` for detailed examples and format patterns.

---

## Status

- [x] Question JSON template - **CONFIRMED**: Simple text field
- [x] Answer JSON template - **CONFIRMED**: Simple text-based with embedded context
- [x] Data model update - **COMPLETED**: Updated in `03_data_models.md`
- [x] API specification - **COMPLETED**: Updated in `02_api_specifications.md`

---

## Data Model Update Needed

Once the templates are provided, the following data model needs to be updated:

### Q&A Record (in `03_data_models.md`)
Currently shows:
```json
{
  "qa_id": "string (UUID)",
  "conversation_id": "string (UUID)",
  "call_id": "string",
  "tenant_id": "string (UUID)",
  "question": {
    // Structure to be provided by user
  },
  "answer": {
    // Structure to be provided by user
  },
  "created_at": "ISO8601 datetime"
}
```

This will be updated with the actual structure once templates are provided.

