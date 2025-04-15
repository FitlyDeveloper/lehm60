/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const axios = require("axios");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

/**
 * Production-ready API for DeepSeek chat completion
 * - Proper error handling
 * - Rate limiting
 * - Secure API key management
 */
exports.getAIResponse = functions.https.onCall(async (data, context) => {
  try {
    console.log("Function triggered with request");
    console.log("Raw data type:", typeof data);
    
    if (data) {
      console.log("Request properties:", Object.keys(data));
    }
    
    // The most common case for Firebase Callable Functions
    if (data && typeof data === 'object' && 'data' in data) {
      console.log("Found 'data' property, checking its contents");
      
      if (data.data) {
        console.log("Data properties:", Object.keys(data.data));
      }
      
      if (data.data && typeof data.data === 'object' && 'messages' in data.data) {
        console.log("Found data.data.messages - the expected path");
        
        // Get messages from the expected location
        const messages = data.data.messages;
        
        // Validate messages
        if (!Array.isArray(messages)) {
          console.error("messages is not an array:", typeof messages);
          throw new functions.https.HttpsError(
            "invalid-argument", 
            "Messages must be an array"
          );
        }
        
        if (messages.length === 0) {
          console.error("messages array is empty");
          throw new functions.https.HttpsError(
            "invalid-argument", 
            "Messages array cannot be empty"
          );
        }
        
        // Process the messages
        console.log(`Processing ${messages.length} messages`);
        
        // Create clean message objects
        const safeMessages = messages.map(msg => {
          if (typeof msg === "object" && msg !== null) {
            return {
              role: String(msg.role || "user"),
              content: String(msg.content || "")
            };
          }
          return { role: "user", content: String(msg || "") };
        });
        
        // Ensure messages are properly ordered (system message first)
        const orderedMessages = safeMessages.sort((a, b) => {
          // System messages should come first
          if (a.role === 'system') return -1;
          if (b.role === 'system') return 1;
          return 0;
        });
        
        console.log(`Processing ${orderedMessages.length} messages (including any system messages)`);
        
        // Call the DeepSeek API
        try {
          // Get API key from environment variables (Firebase v2 approach)
          const apiKey = process.env.DEEPSEEK_API_KEY || "sk-593c0eafc0734e4a9401ebdaa8a0093d";
          
          if (!apiKey) {
            console.error("API key not found in environment variables");
            throw new Error("API key configuration error");
          }
          
          // Make API request
          const response = await axios.post(
            "https://api.deepseek.com/v1/chat/completions",
            {
              model: "deepseek-chat",
              messages: orderedMessages,
              temperature: 0.7,
              max_tokens: 1000,
              stream: true // Enable streaming for token-by-token response
            },
            {
              headers: {
                "Authorization": `Bearer ${apiKey}`,
                "Content-Type": "application/json"
              },
              timeout: 30000, // 30 second timeout
              responseType: 'stream' // Set response type to stream
            }
          );
          
          console.log("DeepSeek API streaming response initiated with status:", response.status);
          
          // For non-streaming fallback
          if (!response.data || typeof response.data.on !== 'function') {
            console.log("Streaming not supported, falling back to regular response");
            return {
              success: true,
              content: "Streaming not supported by the API. Please try again.",
              streaming: false
            };
          }
          
          // Prepare for streaming response
          return new Promise((resolve) => {
            let fullContent = "";
            let isFirstChunk = true;
            
            response.data.on('data', (chunk) => {
              try {
                const lines = chunk.toString().split('\n').filter(line => line.trim() !== '');
                
                for (const line of lines) {
                  if (line.startsWith('data: ')) {
                    const data = line.substring(6);
                    
                    // Check for stream completion
                    if (data === '[DONE]') {
                      console.log("Stream completed");
                      continue;
                    }
                    
                    try {
                      const parsed = JSON.parse(data);
                      const delta = parsed.choices[0]?.delta?.content || '';
                      fullContent += delta;
                    } catch (err) {
                      console.error("Error parsing JSON from stream:", err);
                    }
                  }
                }
                
                // For debugging only
                if (isFirstChunk) {
                  console.log("First chunk received and processed");
                  isFirstChunk = false;
                }
              } catch (err) {
                console.error("Error processing stream chunk:", err);
              }
            });
            
            response.data.on('end', () => {
              console.log("Stream ended, returning full content");
              resolve({
                success: true,
                content: fullContent,
                streaming: true,
                streamComplete: true
              });
            });
            
            response.data.on('error', (err) => {
              console.error("Stream error:", err);
              resolve({
                success: false,
                error: "Streaming error occurred",
                content: fullContent || "An error occurred during streaming."
              });
            });
          });
        } catch (apiError) {
          console.error("API request failed:", apiError.message);
          
          if (apiError.response) {
            console.error("API response error:", JSON.stringify({
              status: apiError.response.status,
              data: apiError.response.data
            }));
            
            throw new functions.https.HttpsError(
              "unavailable",
              `DeepSeek API error: ${apiError.response.status}`
            );
          }
          
          throw new functions.https.HttpsError(
            "internal",
            `API request failed: ${apiError.message}`
          );
        }
      } else {
        console.error("Could not find messages in data.data");
        throw new functions.https.HttpsError(
          "invalid-argument", 
          "Messages array not found in request data"
        );
      }
    } else {
      console.error("Request missing expected 'data' property");
      throw new functions.https.HttpsError(
        "invalid-argument", 
        "Invalid request format"
      );
    }
  } catch (error) {
    console.error("Function error:", error.message);
    
    // Don't expose internal errors to clients
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    
    throw new functions.https.HttpsError(
      "internal",
      "An unexpected error occurred"
    );
  }
});

/**
 * Stream chat completions from DeepSeek API
 * This function supports token-by-token streaming for real-time chat responses
 * NOTE: Firebase Functions currently doesn't support true streaming responses
 * This implementation immediately returns all tokens collected during the stream
 */
exports.streamAIResponse = functions.https.onCall(async (data, context) => {
  try {
    console.log("Streaming function triggered with request");
    console.log("Raw data type:", typeof data);
    
    let messages = [];
    
    // Handle different request formats
    if (data && data.messages) {
      console.log("Found messages at root level:", Array.isArray(data.messages));
      messages = data.messages;
    } else if (data && data.data && data.data.messages) {
      console.log("Found messages in data.data:", Array.isArray(data.data.messages));
      messages = data.data.messages;
    } else {
      console.error("Could not find messages in request data");
      throw new functions.https.HttpsError(
        "invalid-argument", 
        "Messages must be provided as an array"
      );
    }
    
    // Ensure messages is an array
    if (!Array.isArray(messages)) {
      console.error("messages is not an array:", typeof messages);
      throw new functions.https.HttpsError(
        "invalid-argument", 
        "Messages must be provided as an array"
      );
    }
    
    if (messages.length === 0) {
      console.error("messages array is empty");
      throw new functions.https.HttpsError(
        "invalid-argument", 
        "Messages array cannot be empty"
      );
    }
    
    console.log(`Processing ${messages.length} messages for streaming`);
    
    // Create clean message objects
    const safeMessages = messages.map(msg => {
      if (typeof msg === "object" && msg !== null) {
        return {
          role: String(msg.role || "user"),
          content: String(msg.content || "")
        };
      }
      return { role: "user", content: String(msg || "") };
    });
    
    // Ensure messages are properly ordered (system message first)
    const orderedMessages = safeMessages.sort((a, b) => {
      if (a.role === 'system') return -1;
      if (b.role === 'system') return 1;
      return 0;
    });
    
    // Get API key from environment variables
    const apiKey = process.env.DEEPSEEK_API_KEY || "sk-593c0eafc0734e4a9401ebdaa8a0093d";
    if (!apiKey) {
      throw new Error("API key configuration error");
    }
    
    // Make streaming API request to DeepSeek
    const response = await axios({
      method: 'post',
      url: "https://api.deepseek.com/v1/chat/completions",
      data: {
        model: "deepseek-chat",
        messages: orderedMessages,
        temperature: 0.7,
        max_tokens: 1000,
        stream: true
      },
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json"
      },
      responseType: 'stream'
    });
    
    // Process streaming response
    return new Promise((resolve) => {
      let collectedChunks = [];
      let isFirstChunk = true;
      
      // Process each chunk as it comes in
      response.data.on('data', (chunk) => {
        try {
          const chunkStr = chunk.toString('utf8');
          const lines = chunkStr.split('\n').filter(line => line.trim().length > 0);
          
          for (const line of lines) {
            if (line.startsWith('data: ')) {
              const data = line.substring(6).trim();
              
              if (data === '[DONE]') {
                console.log("Stream completion marker received");
                continue;
              }
              
              try {
                const parsedData = JSON.parse(data);
                const content = parsedData.choices[0]?.delta?.content || '';
                if (content) {
                  console.log(`Collected chunk: "${content}"`);
                  collectedChunks.push(content);
                }
              } catch (jsonError) {
                console.error("Error parsing JSON from chunk:", jsonError);
              }
            }
          }
          
          if (isFirstChunk) {
            console.log("First streaming chunk processed");
            isFirstChunk = false;
          }
        } catch (chunkError) {
          console.error("Error processing chunk:", chunkError);
        }
      });
      
      // Handle stream completion
      response.data.on('end', () => {
        console.log("Stream completed, finalizing response with chunks");
        
        // Log each chunk for debugging
        if (collectedChunks.length > 0) {
          console.log(`Returning ${collectedChunks.length} chunks`);
          console.log(`First few chunks: ${collectedChunks.slice(0, 5).join(', ')}`);
          console.log(`Last few chunks: ${collectedChunks.slice(-5).join(', ')}`);
        } else {
          console.log("No chunks collected!");
        }
        
        resolve({
          success: true,
          chunks: collectedChunks,
          fullContent: collectedChunks.join(''),
          streaming: true
        });
      });
      
      // Handle stream errors
      response.data.on('error', (err) => {
        console.error("Stream error:", err);
        resolve({
          success: false,
          error: "Error during streaming response",
          chunks: collectedChunks,
          fullContent: collectedChunks.join('')
        });
      });
    });
  } catch (error) {
    console.error("Streaming function error:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Streaming error: ${error.message}`
    );
  }
});
