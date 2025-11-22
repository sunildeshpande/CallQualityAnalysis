# Q&A Analysis Strategy

## Question Types and Analysis Strategies

The Q&A system supports four question types, each with a specific analysis strategy:

| Question Type | Analysis Strategy | Description |
|--------------|------------------|-------------|
| **Boolean** | Check conversation presence/absence of signals | Determines if something exists or doesn't exist in the conversation |
| **Categorical** | Classify using patterns or LLM | Classifies the conversation into predefined categories |
| **Numeric** | Measure/count from parsed conversation | Extracts numerical values or counts from the conversation |
| **Textual** | Extract key phrases or generate summary | Extracts key information or generates textual summaries |

## Question Input

**The question input is a simple text string.** The system will automatically determine the question type based on the question text and apply the appropriate analysis strategy.

### Question JSON Structure

```json
{
  "question": {
    "text": "What was the main concern raised by the customer?"
  }
}
```

**Note**: The question type classification is determined by the system, not specified in the input. The user just provides the question text.

## Answer Structure

Based on the provided examples, **all answer types use a simple text-based format** with embedded context and details. The answer text combines the direct answer with supporting details.

### Unified Answer Structure
```json
{
  "answer": {
    "text": "Answer - Details/Context",
    "type": "boolean|categorical|numeric|textual"
  }
}
```

### Answer Examples by Type

#### 1. Boolean Answer
**Question**: "Was the call focused on the campaign topic?"
```json
{
  "answer": {
    "text": "Yes (94% keyword coverage, strong focus on credit card benefits throughout)",
    "type": "boolean"
  }
}
```

#### 2. Categorical Answer
**Question**: "What is the overall sentiment of the customer?"
```json
{
  "answer": {
    "text": "Positive - Customer showed interest, asked follow-up questions, expressed satisfaction",
    "type": "categorical"
  }
}
```

#### 3. Boolean with Details
**Question**: "Did the customer raise new requests or queries?"
```json
{
  "answer": {
    "text": "Yes - Customer asked about annual fee waiver, insurance coverage, and APR details",
    "type": "boolean"
  }
}
```

#### 4. Numeric Answer
**Question**: "What percentage of call time was spent on the main offer?"
```json
{
  "answer": {
    "text": "72% - 5 min 2 sec out of 7 min total discussion on primary offer benefits",
    "type": "numeric"
  }
}
```

#### 5. Categorical Answer (Interest Level)
**Question**: "Was the customer interested in proceeding?"
```json
{
  "answer": {
    "text": "Interested - Customer asked for comparison with existing card, indicating serious consideration",
    "type": "categorical"
  }
}
```

### Answer Format Patterns

- **Boolean**: "Yes/No (details)" or "Yes/No - details"
- **Categorical**: "Category - Description/Context"
- **Numeric**: "Value - Breakdown/Details"
- **Textual**: "Summary - Additional context/details"

**Key Points**:
- Answer text is a single string combining the answer with supporting context
- Details are embedded in the text (in parentheses or after a dash)
- No separate evidence or confidence fields in the basic structure
- The answer text is self-contained and human-readable

## Answer Structure Confirmed

Based on provided examples:
- ✅ **Answer Format**: Simple text-based with embedded context
- ✅ **Answer Types**: Boolean, Categorical, Numeric, Textual
- ✅ **Format Pattern**: "Answer - Details" or "Answer (Details)"
- ✅ **Self-contained**: All information in the text field

## Optional Enhancements (Future)

The current structure is simple and text-based. Future enhancements could include:
- Confidence scores (if needed for quality metrics)
- Evidence citations (if needed for traceability)
- Structured metadata (if needed for analytics)

For now, the simple text-based format is sufficient and matches the provided examples.

