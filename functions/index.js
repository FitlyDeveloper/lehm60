/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest, HttpsError} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const fetch = require("node-fetch");
const functions = require("firebase-functions");

// Initialize the Firebase Admin SDK
admin.initializeApp();

// DeepSeek API endpoint
const DEEPSEEK_API_URL = "https://api.deepseek.com/v1/chat/completions";

// Function to call DeepSeek API
async function callDeepSeekApi(messages) {
  try {
    // Get DeepSeek API key from Firebase config
    const apiKey = functions.config().deepseek?.api_key;
    
    if (!apiKey) {
      logger.error("DeepSeek API key not configured");
      throw new HttpsError("failed-precondition", "API key not configured. Set it using 'firebase functions:config:set deepseek.api_key=\"your_api_key_here\"'");
    }

    logger.info(`Calling DeepSeek API with ${messages.length} messages`);
    
    const response = await fetch(DEEPSEEK_API_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${apiKey}`
      },
      body: JSON.stringify({
        model: "deepseek-chat",
        messages: messages,
        temperature: 0.7,
        max_tokens: 1000
      })
    });

    if (!response.ok) {
      const errorData = await response.json();
      logger.error("DeepSeek API error:", errorData);
      throw new HttpsError("internal", `DeepSeek API error: ${response.status} - ${JSON.stringify(errorData)}`);
    }

    const responseData = await response.json();
    logger.info("DeepSeek API response received successfully");
    return responseData;
  } catch (error) {
    logger.error("Error calling DeepSeek API:", error);
    throw new HttpsError("internal", `Failed to call DeepSeek API: ${error.message}`);
  }
}

// Non-streaming endpoint for AI responses
exports.getAIResponse = onRequest({
  cors: true, 
  region: "us-central1",
  timeoutSeconds: 60,
  memory: "1GiB"
}, async (request, response) => {
  try {
    const messages = request.body.messages;
    
    if (!messages || !Array.isArray(messages)) {
      logger.error("Invalid messages format:", messages);
      return response.status(400).json({
        success: false,
        error: "Messages must be provided as an array"
      });
    }

    logger.info(`Processing request with ${messages.length} messages`);
    const apiResponse = await callDeepSeekApi(messages);
    
    return response.json({
      success: true,
      content: apiResponse.choices[0].message.content,
      fullResponse: apiResponse // Include full response for debugging
    });
  } catch (error) {
    logger.error("Error in getAIResponse:", error);
    return response.status(500).json({
      success: false,
      error: error.message || "Unknown error occurred"
    });
  }
});

// Streaming endpoint for AI responses
// This is a simplified implementation since Firebase Functions doesn't support 
// native streaming responses, but we can simulate with our client-side streaming
exports.streamAIResponse = onRequest({
  cors: true,
  region: "us-central1",
  timeoutSeconds: 60,
  memory: "1GiB"
}, async (request, response) => {
  try {
    const messages = request.body.messages;
    
    if (!messages || !Array.isArray(messages)) {
      logger.error("Invalid messages format:", messages);
      return response.status(400).json({
        success: false,
        error: "Messages must be provided as an array"
      });
    }

    logger.info("Calling DeepSeek API for streaming response");
    const apiResponse = await callDeepSeekApi(messages);
    
    // Get the full content
    const fullContent = apiResponse.choices[0].message.content;
    
    // Split content into chunks to simulate streaming
    // This approach sends word chunks that the client will stream
    const words = fullContent.split(" ");
    const chunks = [];
    
    // Create chunks of 1-3 words
    for (let i = 0; i < words.length;) {
      const chunkSize = Math.min(1 + Math.floor(Math.random() * 2), words.length - i);
      const chunk = words.slice(i, i + chunkSize).join(" ") + (i + chunkSize < words.length ? " " : "");
      chunks.push(chunk);
      i += chunkSize;
    }

    logger.info(`Returning ${chunks.length} chunks for simulated streaming`);
    return response.json({
      success: true,
      chunks: chunks,
      fullContent: fullContent
    });
  } catch (error) {
    logger.error("Error in streamAIResponse:", error);
    return response.status(500).json({
      success: false,
      error: error.message || "Unknown error occurred"
    });
  }
});
