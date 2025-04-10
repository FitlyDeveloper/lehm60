# Fitly - Fitness & Nutrition Tracking App

Fitly is a comprehensive fitness and nutrition tracking application built with Flutter. It helps users track their calorie intake, monitor macronutrients, and achieve their fitness goals.

## Features

- **User Onboarding**: Personalized onboarding flow collecting user information (gender, weight, height, etc.)
- **Calorie Tracking**: Track daily calorie intake and deficit
- **Macronutrient Monitoring**: Monitor protein, fat, and carbohydrate consumption
- **Meal Logging**: Log meals with detailed nutritional information
- **Activity Feed**: View recent food entries and activities
- **Snap Meal**: Quickly log meals using your camera
- **Coach Access**: Connect with fitness coaches for personalized guidance

## Screenshots

![App Screenshot](screenshots/home_screen.png)

## Project Structure

The app follows a feature-based architecture:

- **Features/**
  - **auth/**: Authentication-related screens and services
  - **codia/**: Main app screens including home screen
  - **home/**: Home screen components
  - **onboarding/**: Onboarding flow screens and components
- **core/**: Core utilities and widgets
- **services/**: Backend services including authentication
- **utils/**: Utility functions and helpers

## Getting Started

### Prerequisites

- Flutter SDK (2.10.0 or higher)
- Dart SDK (2.16.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/fitly.git
   ```

2. Navigate to the project directory:
   ```
   cd fitly
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Development Notes

### Navigation Flow

The app implements a multi-screen onboarding flow:
1. Sign In/Sign Up
2. Email Verification
3. Gender Selection
4. Weight & Height Input
5. Goal Setting
6. Main App (Home Screen)

### UI Components

- Uses Material Design with custom styling
- Implements responsive layouts for different screen sizes
- Custom navigation bar with increased height (90px) for better usability
- Fixed positioning of navigation elements for consistent UX

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI inspiration
- All contributors who have helped shape this project
"# Lehm40" 
