// Temporary implementation of AIService without Firebase Functions dependency
// This will be replaced with the actual implementation once Firebase Functions is set up

import 'package:cloud_functions/cloud_functions.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:async';

class AIService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Stream for receiving real-time token updates
  StreamController<String>? _streamController;

  /// Begin streaming AI response and return a stream of token chunks
  Stream<String> streamAIResponse(List<Map<String, dynamic>> messages) {
    // Create a stream controller
    _streamController = StreamController<String>();

    // Start the streaming process
    _getStreamingResponse(messages);

    // Return the stream for the UI to listen to
    return _streamController!.stream;
  }

  /// Private method to handle streaming response
  Future<void> _getStreamingResponse(
      List<Map<String, dynamic>> messages) async {
    try {
      print(
          "AI Service: Preparing streaming request with ${messages.length} messages");

      // Create a flat structure for the messages
      final List<Map<String, String>> safeMessages = [];

      // Add a system message with formatting instructions
      safeMessages.add({
        'role': 'system',
        'content': 'You are a premium fitness and nutrition coach inside the Fitly app. All responses must follow these rules:\n\n'
            '1. Be clear, concise, and easy to follow.\n\n'
            '2. Use bold section headers (e.g., **Nutrition Tips:**, **Workout Plan:**, **Progress Tips:**).\n\n'
            '3. Break info into short bullet points — each line should feel tight and useful.\n\n'
            '4. Avoid paragraphs or long explanations. Aim for a clean, modern premium app tone.\n\n'
            '5. All numbers must be rounded and practical (e.g., "3-5x/week," "100g chicken = 165 cal").\n\n'
            '6. Include actionable tips or structure when relevant (e.g., meals, routines, mindset).\n\n'
            '7. Never over-explain. No motivational fluff. Just smart, efficient advice.\n\n'
            '8. Keep formatting consistent across all answers (bullets, bold labels, calorie info etc).\n\n'
            '9. CRITICALLY IMPORTANT: Insert EXACTLY ONE empty line after EVERY heading.\n\n'
            '10. DO NOT use markdown syntax with # or ### symbols anywhere.\n\n'
            '11. Example structure:\n\n'
            '**Goal Plan:**\n\n'
            '- Calories: Target 300–500 kcal deficit/day\n'
            '- Protein: Prioritize lean sources (e.g., chicken, eggs)\n'
            '- Veggies: Half plate; spinach/broccoli are low cal\n\n'
            '**Training:**\n\n'
            '- Cardio: 3–5x/week (burns 150–300 kcal/session)\n'
            '- Strength: 2–3x/week (preserve muscle)\n\n'
            '**Tips:**\n\n'
            '- Track food daily\n'
            '- Sleep 7–9 hrs/night\n'
            '- Weigh once/week only\n\n'
            'Always respond in this format unless asked to be casual or conversational.'
      });

      // Add the user messages
      for (final msg in messages) {
        safeMessages.add({
          'role': (msg['role'] ?? 'user').toString(),
          'content': (msg['content'] ?? '').toString(),
        });
      }

      try {
        // Create a direct streaming implementation using the function
        final streamController = StreamController<String>();

        // Use Firebase Functions SDK to set up streaming listener
        final callable = _functions.httpsCallable(
          'streamAIResponse',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 60),
          ),
        );

        // Set up real-time streaming from DeepSeek
        // First, establish the streaming call
        callable.call({'messages': safeMessages}).then((result) {
          final data = result.data as Map<String, dynamic>;

          if (data['success'] == true) {
            // If we already received chunks in result, process them immediately
            if (data.containsKey('chunks') &&
                data['chunks'] is List &&
                (data['chunks'] as List).isNotEmpty) {
              print(
                  "Received ${(data['chunks'] as List).length} chunks in response");

              // Instead of adding chunks all at once, add them with a tiny delay
              // to simulate the streaming effect
              _streamChunksWithDelay(data['chunks'] as List);
            }
            // If there's just fullContent, simulate typing it out
            else if (data.containsKey('fullContent') &&
                data['fullContent'] is String) {
              _simulateStreaming(data['fullContent'] as String);
            }
            // If there's just content, simulate typing it out
            else if (data.containsKey('content') && data['content'] is String) {
              _simulateStreaming(data['content'] as String);
            } else {
              throw Exception('No content found in response');
            }
          } else {
            throw Exception(
                'API request failed: ${data['error'] ?? 'Unknown error'}');
          }
        }).catchError((error) {
          print('AI Service: Streaming function call error: $error');

          // Fallback to non-streaming approach
          _fallbackToNonStreaming(safeMessages);
        });
      } catch (callError) {
        print('AI Service: Initial function call error: $callError');

        // Fallback to non-streaming approach
        _fallbackToNonStreaming(safeMessages);
      }
    } catch (e) {
      print('AI Service: Error: $e');
      if (_streamController != null && !_streamController!.isClosed) {
        _streamController!.addError(e);
        _streamController!.close();
      }
    }
  }

  /// Stream chunks from a list with a minimal delay between each
  void _streamChunksWithDelay(List chunks) async {
    if (_streamController == null || _streamController!.isClosed) return;

    for (final chunk in chunks) {
      if (_streamController!.isClosed) return;

      // Add chunk to the stream
      _streamController!.add(chunk.toString());

      // Add a tiny delay to make it feel like real-time typing
      // This makes it feel more natural than dumping all at once
      await Future.delayed(Duration(milliseconds: 10));
    }

    // Close the stream when done
    if (!_streamController!.isClosed) {
      _streamController!.close();
    }
  }

  /// Fallback to non-streaming approach on error
  Future<void> _fallbackToNonStreaming(
      List<Map<String, String>> safeMessages) async {
    try {
      print("Falling back to non-streaming approach");

      final HttpsCallable callable = _functions.httpsCallable(
        'getAIResponse',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 60),
        ),
      );

      final result = await callable.call({'messages': safeMessages});
      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true &&
          (data['content'] is String || data['fullContent'] is String)) {
        final content =
            data['content'] as String? ?? data['fullContent'] as String;
        _simulateStreaming(content);
      } else {
        throw Exception('Non-streaming fallback also failed');
      }
    } catch (fallbackError) {
      print('AI Service: Fallback also failed: $fallbackError');
      if (_streamController != null && !_streamController!.isClosed) {
        _streamController!.addError(fallbackError);
        _streamController!.close();
      }
    }
  }

  /// Simulate streaming by sending chunks of the content
  void _simulateStreaming(String content) {
    if (_streamController == null || _streamController!.isClosed) return;

    // Define chunk size for more natural typing feel
    final words = content.split(' ');

    // Add a small delay for a more natural feel
    Future.delayed(Duration(milliseconds: 300), () {
      // Start streaming the words
      _streamWords(words, 0);
    });
  }

  /// Stream words with realistic typing speed
  void _streamWords(List<String> words, int index) async {
    if (_streamController == null || _streamController!.isClosed) return;
    if (index >= words.length) {
      _streamController!.close();
      return;
    }

    // Determine chunk size (1-3 words at a time)
    final chunkSize =
        math.min(1 + math.Random().nextInt(2), words.length - index);
    final chunk = words.sublist(index, index + chunkSize).join(' ') +
        (index + chunkSize < words.length ? ' ' : '');

    // Add the chunk to the stream
    _streamController!.add(chunk);

    // Determine delay (simulate typing speed)
    final delay = 50 + math.Random().nextInt(50); // 50-100ms

    // Process next chunk after delay
    Future.delayed(Duration(milliseconds: delay), () {
      _streamWords(words, index + chunkSize);
    });
  }

  /// Legacy method for non-streaming response, keep for compatibility
  Future<String> getAIResponse(List<Map<String, dynamic>> messages) async {
    try {
      print(
          "AI Service: Preparing to call Firebase function with ${messages.length} messages");

      // Create a completely flat structure for the messages
      final List<Map<String, String>> safeMessages = [];

      // Add a system message with formatting instructions
      safeMessages.add({
        'role': 'system',
        'content': 'You are a premium fitness and nutrition coach inside the Fitly app. All responses must follow these rules:\n\n'
            '1. Be clear, concise, and easy to follow.\n\n'
            '2. Use bold section headers (e.g., **Nutrition Tips:**, **Workout Plan:**, **Progress Tips:**).\n\n'
            '3. Break info into short bullet points — each line should feel tight and useful.\n\n'
            '4. Avoid paragraphs or long explanations. Aim for a clean, modern premium app tone.\n\n'
            '5. All numbers must be rounded and practical (e.g., "3-5x/week," "100g chicken = 165 cal").\n\n'
            '6. Include actionable tips or structure when relevant (e.g., meals, routines, mindset).\n\n'
            '7. Never over-explain. No motivational fluff. Just smart, efficient advice.\n\n'
            '8. Keep formatting consistent across all answers (bullets, bold labels, calorie info etc).\n\n'
            '9. CRITICALLY IMPORTANT: Insert EXACTLY ONE empty line after EVERY heading.\n\n'
            '10. DO NOT use markdown syntax with # or ### symbols anywhere.\n\n'
            '11. Example structure:\n\n'
            '**Goal Plan:**\n\n'
            '- Calories: Target 300–500 kcal deficit/day\n'
            '- Protein: Prioritize lean sources (e.g., chicken, eggs)\n'
            '- Veggies: Half plate; spinach/broccoli are low cal\n\n'
            '**Training:**\n\n'
            '- Cardio: 3–5x/week (burns 150–300 kcal/session)\n'
            '- Strength: 2–3x/week (preserve muscle)\n\n'
            '**Tips:**\n\n'
            '- Track food daily\n'
            '- Sleep 7–9 hrs/night\n'
            '- Weigh once/week only\n\n'
            'Always respond in this format unless asked to be casual or conversational.'
      });

      // Add the user messages after the system message
      for (final msg in messages) {
        safeMessages.add({
          'role': (msg['role'] ?? 'user').toString(),
          'content': (msg['content'] ?? '').toString(),
        });
      }

      // Simple direct approach - directly call Firebase function
      final HttpsCallable callable = _functions.httpsCallable(
        'getAIResponse',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 30),
        ),
      );

      // IMPORTANT: Format messages array directly, without nested 'data' property
      final result = await callable.call({'messages': safeMessages});

      print("AI Service: Received response from Firebase function");

      // Extract the data from the result
      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        // First try to get the direct content field (format from index.js)
        if (data.containsKey('content') && data['content'] is String) {
          return data['content'] as String;
        }

        // Try fullContent field (used in streaming responses)
        if (data.containsKey('fullContent') && data['fullContent'] is String) {
          return data['fullContent'] as String;
        }

        // We couldn't find the expected response format
        print("AI Service: Unexpected response format");
        return 'Sorry, I couldn\'t understand the response from the AI.';
      } else {
        print(
            "AI Service: Function reported failure: ${data['error'] ?? 'No error details provided'}");
        throw Exception(
            'API request failed: ${data['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('AI Service: Fatal error calling DeepSeek API: $e');
      return 'Sorry, there was an error communicating with the AI service. Please try again later.';
    }
  }

  /// For more complex conversations with context
  Future<Map<String, dynamic>> getChatResponse(
      List<Map<String, String>> conversation) async {
    try {
      // IMPORTANT: Format messages array directly, without nested 'data' property
      final result = await _functions
          .httpsCallable('getAIResponse')
          .call({'messages': conversation});

      // Extract the data from the result
      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        return data['response'];
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      print('Error calling DeepSeek API: $e');
      rethrow;
    }
  }

  /// Dispose method to clean up resources
  void dispose() {
    if (_streamController != null && !_streamController!.isClosed) {
      _streamController!.close();
    }
  }
}

/* 
// TODO: Replace with this implementation when Firebase Functions is set up:

import 'package:cloud_functions/cloud_functions.dart';

class AIService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<String> getAIResponse(List<Map<String, dynamic>> messages) async {
    try {
      // Call the Firebase Function
      final result = await _functions.httpsCallable('callDeepSeekAI').call({
        'messages': messages,
      });
      
      // Extract response from DeepSeek
      final response = result.data;
      return response['choices'][0]['message']['content'];
    } catch (e) {
      print('Error calling AI service: $e');
      return "Sorry, I couldn't process your request at the moment.";
    }
  }
}
*/
