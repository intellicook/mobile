# IntelliCook Mobile

The mobile frontend app for IntelliCook.

## Development Setup

This app uses [Flutter](https://flutter.dev/). Since I am using Android Studio, I will be able to
provide more instructions for setting up the project in Android Studio.

1. Clone the repository.

2. Run the following command to install the dependencies:

    ```bash
    flutter pub get
    ```

3. Run the [install_hooks.sh](./install_hooks.sh) shell script or
   the [install_hooks.ps1](./install_hooks.ps1) PowerShell script to install a pre-commit hook which
   can help check if your code will pass the GitHub workflows before you commit.

4. Copy the [.env.development](./.env.development) file or the [.env.example](./.env.example) file
   to a new file named `.env` and fill in the required values if needed.

5. Run the [build_runner](https://pub.dev/packages/build_runner) to generate the config files (which
   use the `.env` file) for the app:

    ```bash
    # You may want to run this only if you have generated configs before
    dart run build_runner clean
   
    # Generate the configs
    dart run build_runner build --delete-conflicting-outputs
    ```

## Updating App Controller Version

To update the app controller version, you will run the following command:

```bash
flutter pub upgrade app_controller_client
```

## Making Code Changes

Important things to note when making code changes:

- All code changes made to the main branch must be done from a pull request, the branch name should
  use `kebab-case`.

- The GitHub workflows on the pull request must be passed before being able to merge into main.

- The formatting follows the [default Flutter linter rules](https://dart.dev/tools/linter-rules)
  plus the rules defined in [analysis_options.yaml](analysis_options.yaml).

### Widget Default Arguments

To keep the code consistent and predictable, please follow the steps below to define a default
argument for a widget:

1. If the default argument can be a `const`, define it as a `static const` for the widget class, and
   assign it in the constructor parameters.

2. If the default argument is a `final` and can be defined without the build context, define it as
   a `static final` for the widget class, and assign it in the initializer of the constructor.

    - You may also want to define it as an optional parameter, then checking against whether or not
      the supplied argument is null before assigning it in the initializer, example as follows:

      ```dart
      class MyWidget extends StatelessWidget {
        MyWidget({
          super.key,
          int? optParam,
        })  : optField = optParam ?? defaultArg;
        
        static final defaultArg = optArgFactory();
        
        int optField;
      }
      ```

    - If the default argument is a method, it may be able to be defined as `static const` for the
      widget class but it still need to be called which is not a constant value, so the return value
      still needs to be assigned in the initializer.

3. If the default argument does not satisfy any of the above condition, define it in the `build()`
   method.

*Note*: default arguments are not constants, constants are non-configurable arguments to it's
children, they are defined as `const` in `build()` method.
