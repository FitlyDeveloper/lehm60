const fetch = require('node-fetch');
const fs = require('fs');
const path = require('path');

// Load the runtime config for local testing
let config = {};
try {
  const configPath = path.join(__dirname, '.runtimeconfig.json');
  if (fs.existsSync(configPath)) {
    config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  } else {
    console.error('No .runtimeconfig.json file found. Please run "firebase functions:config:get > .runtimeconfig.json" first.');
    process.exit(1);
  }
} catch (error) {
  console.error('Error loading config:', error);
  process.exit(1);
}

const apiKey = config.deepseek?.api_key;
if (!apiKey) {
  console.error('DeepSeek API key not found in config. Please set it using:');
  console.error('firebase functions:config:set deepseek.api_key="your_api_key_here"');
  console.error('Then run: firebase functions:config:get > .runtimeconfig.json');
  process.exit(1);
}

// DeepSeek API endpoint
const DEEPSEEK_API_URL = "https://api.deepseek.com/v1/chat/completions";

// Test messages
const messages = [
  {
    "role": "system",
    "content": "You are a premium fitness coach. Keep responses concise and focused on fitness advice."
  },
  {
    "role": "user",
    "content": "What's a good quick workout for busy days?"
  }
];

async function testDeepSeekApi() {
  console.log('Testing DeepSeek API with direct API call...');
  try {
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
      console.error("DeepSeek API error:", errorData);
      return;
    }

    const data = await response.json();
    console.log('\nAPI Response:');
    console.log('----------------');
    console.log(data.choices[0].message.content);
    console.log('----------------');
    console.log('\nFull API Response Object:');
    console.log(JSON.stringify(data, null, 2));

  } catch (error) {
    console.error("Error calling DeepSeek API:", error);
  }
}

// Main function
async function main() {
  console.log('DeepSeek API Key found in config.');
  await testDeepSeekApi();
}

main().catch(console.error); 