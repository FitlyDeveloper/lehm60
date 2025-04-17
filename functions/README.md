# Firebase Functions for AI Service

This directory contains Firebase Cloud Functions that provide AI capabilities to the Fitly app by connecting to the DeepSeek API.

## Setup Instructions

### Prerequisites

1. Node.js version 22 or higher
2. Firebase CLI installed (`npm install -g firebase-tools`)
3. A DeepSeek API key from [DeepSeek](https://deepseek.com)

### Environment Configuration

1. Set up environment variables for the DeepSeek API key:

```bash
firebase functions:config:set deepseek.api_key="your_api_key_here"
```

2. Make the environment variables available locally for testing:

```bash
firebase functions:config:get > .runtimeconfig.json
```

### Installing Dependencies

```bash
cd functions
npm install
```

### Local Testing

```bash
firebase emulators:start --only functions
```

### Deployment

```bash
firebase deploy --only functions
```

## Available Functions

The following Cloud Functions are implemented:

1. `getAIResponse` - Non-streaming API call to DeepSeek
2. `streamAIResponse` - Simulated streaming response for AI chat

## Usage in Dart

The functions are meant to be called from the Dart code in `lib/services/ai_service.dart`. 

Example:
```dart
final callable = FirebaseFunctions.instance.httpsCallable('getAIResponse');
final result = await callable.call({'messages': messages});
```

## Troubleshooting

- If you encounter CORS issues, ensure your Firebase project has the correct CORS configuration.
- For "Function timeout" errors, check the function logs in the Firebase console and consider increasing the timeout limit.
- If the DeepSeek API returns errors, verify your API key and request format. 