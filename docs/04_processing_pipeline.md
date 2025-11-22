# Processing Pipeline

## Conversation Processing Flow

### 1. Input Validation
- Validate request structure
- Validate campaign_id exists and belongs to tenant
- Validate call_id uniqueness (per tenant)
- Validate conversation_data structure against schema
- Return detailed validation errors

### 2. Preprocessing Steps

The preprocessing pipeline consists of four main steps applied sequentially to the input conversation data:

#### 2.1 Text Cleaning
- **Remove filler words**: Eliminate common filler words (e.g., "um", "uh", "like", "you know")
- **Normalize whitespace**: 
  - Remove extra spaces, tabs, and newlines
  - Standardize spacing between words
  - Clean up formatting inconsistencies
- **Purpose**: Prepare clean text for analysis and improve accuracy of sentiment analysis

#### 2.2 Speaker Segmentation
- **Separate bot vs customer dialogue**: 
  - Identify and tag each conversation turn by speaker type
  - Ensure proper speaker attribution for each text segment
  - Validate speaker labels match expected values ("bot" or "customer")
- **Purpose**: Enable speaker-specific analysis and maintain dialogue context

#### 2.3 Conversation Reconstruction
- **Build coherent dialogue context**:
  - Reconstruct conversation flow from individual turns
  - Maintain temporal sequence based on timestamps
  - Create dialogue context for understanding conversation flow
  - Link related conversation turns
- **Purpose**: Enable context-aware analysis and maintain conversation coherence

#### 2.4 Metadata Extraction
- **Extract key metadata**:
  - **Duration**: Calculate and validate call duration from timestamps
  - **Campaign context**: Extract and validate campaign-related information
  - **Timestamps**: Normalize and validate all timestamp data
  - Extract additional metadata from the input (customer_id, campaign_segment, etc.)
- **Purpose**: Enrich data with metadata needed for analysis and reporting

#### Preprocessing Output
After preprocessing, the data is:
- Cleaned and normalized
- Properly segmented by speaker
- Reconstructed into coherent dialogue
- Enriched with extracted metadata
- Ready for sentiment analysis processing

### 3. Sentiment Analysis (Stubbed)
- Currently returns mock sentiment scores
- Placeholder for future integration
- Maintains same output structure

### 4. Result Storage
- Store processed conversation
- Store sentiment analysis results
- Update conversation status

### 5. Response Generation
- Format output JSON
- Include all required fields
- Return appropriate status code

## Processing Flow

### Sync Mode (Current Implementation)
1. Process immediately
2. Return result in response
3. Status: completed

### Async Mode (Future Feature)
**Note**: Async processing is a planned future feature. The API accepts the `async` parameter but currently returns `501 Not Implemented` if requested.

When implemented, async mode will:
1. Create job record (status: pending)
2. Queue job for processing (using Celery)
3. Return job_id and status URL
4. Process in background
5. Update job status
6. Store results when complete

## Q&A Processing Flow

### 1. Validation
- Validate call_id exists
- Validate conversation is processed
- Validate question structure

### 2. Q&A Processing (Stubbed)
- Currently returns mock answers
- Placeholder for future Q&A service integration
- Maintains same output structure

### 3. Result Storage
- Store Q&A record
- Link to conversation

## Error Handling

### Validation Errors
- Return 400 with detailed field-level errors
- Include all validation failures in single response

### Processing Errors
- Log error details
- Update job/conversation status to "failed"
- Store error message
- Return appropriate error response

### System Errors
- Return 500 for unexpected errors
- Log full error details
- Return generic error message to client

