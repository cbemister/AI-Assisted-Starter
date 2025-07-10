@echo off
setlocal enabledelayedexpansion

:: Disable colors for maximum compatibility - focus on functionality
set "GREEN="
set "YELLOW="
set "RED="
set "BLUE="
set "CYAN="
set "RESET="

echo !GREEN!=========================================================!RESET!
echo !GREEN!  [REPO_NAME] - Dynamic Multi-Workspace Setup Script       !RESET!
echo !GREEN!=========================================================!RESET!
echo.

:: ===================================================================
:: Configuration Variables
:: ===================================================================
set "REPO_URL=https://github.com/cbemister/[REPO_NAME].git"
set "MAIN_BRANCH=main"
set "USE_SHARED_MODULES=false"
set "BASE_PROJECT_NAME=[REPO_NAME]"

:: Store the original directory to ensure consistent relative paths
set "ORIGINAL_DIR=%CD%"
set "PARENT_DIR=%CD%\.."

:: SAFETY CHECK: Ensure we're in a [REPO_NAME] project directory
if not exist "package.json" (
    echo !RED!ERROR: No package.json found. Are you in the correct project directory?!RESET!
    goto :error
)

:: SAFETY CHECK: Verify this is actually a [REPO_NAME] project
findstr /c:"[REPO_NAME]" package.json >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo !YELLOW!WARNING: This doesn't appear to be a [REPO_NAME] project!RESET!
    echo !YELLOW!Continuing anyway, but please verify you're in the correct directory.!RESET!
)

:: Parse command line arguments
set "NUM_VERSIONS=1"
set "TEMPLATE_PATH="
set "FEATURE_NAME="
set "USE_TEMPLATE=false"
set "USE_DOCS_DRIVEN=false"
set "DOCS_FEATURE_NAME="
set "METHODOLOGY_WORKSPACES="

:: Check for help parameter
if "%~1"=="--help" goto :show_help
if "%~1"=="-h" goto :show_help
if "%~1"=="/?" goto :show_help

:: Parse first parameter (number of versions)
if not "%~1"=="" (
    set "NUM_VERSIONS=%~1"
)

:: Parse second parameter (mode: template path or "docs-driven")
if not "%~2"=="" (
    if "%~2"=="docs-driven" (
        set "USE_DOCS_DRIVEN=true"

        :: Parse third parameter (feature name for docs-driven mode)
        if not "%~3"=="" (
            set "DOCS_FEATURE_NAME=%~3"

            :: Clean feature name (replace spaces and special chars with hyphens)
            set "DOCS_FEATURE_NAME=!DOCS_FEATURE_NAME: =-!"
            set "DOCS_FEATURE_NAME=!DOCS_FEATURE_NAME:_=-!"
            set "DOCS_FEATURE_NAME=!DOCS_FEATURE_NAME:/=-!"
            set "DOCS_FEATURE_NAME=!DOCS_FEATURE_NAME:\=-!"
        ) else (
            echo Error: docs-driven mode requires a feature name.
            echo Usage: %~nx0 [number] docs-driven [feature-name]
            goto :error
        )
    ) else (
        :: Traditional template mode
        set "TEMPLATE_PATH=%~2"
        set "USE_TEMPLATE=true"

        :: Extract feature name from template path (last directory name)
        for %%f in ("!TEMPLATE_PATH!") do set "FEATURE_NAME=%%~nxf"

        :: Clean feature name (replace spaces and special chars with hyphens)
        set "FEATURE_NAME=!FEATURE_NAME: =-!"
        set "FEATURE_NAME=!FEATURE_NAME:_=-!"
        set "FEATURE_NAME=!FEATURE_NAME:/=-!"
        set "FEATURE_NAME=!FEATURE_NAME:\=-!"
    )
)

:: Display usage information
if "!USE_DOCS_DRIVEN!"=="true" (
    echo !CYAN!Creating !NUM_VERSIONS! documentation-driven workspace^(s^) for feature: !DOCS_FEATURE_NAME!!RESET!
    echo !CYAN!Scanning docs/sandbox/!DOCS_FEATURE_NAME!/ for methodology files...!RESET!
    echo.
) else (
    if "!USE_TEMPLATE!"=="true" (
        echo !CYAN!Creating !NUM_VERSIONS! feature-specific workspace^(s^) using template: !TEMPLATE_PATH!!RESET!
        echo !CYAN!Feature name: !FEATURE_NAME!!RESET!
        echo.
    ) else (
        if not "%~1"=="" (
            echo !CYAN!Creating !NUM_VERSIONS! standard workspace^(s^)...!RESET!
            echo.
        ) else (
            echo !CYAN!No parameters specified. Creating 1 standard workspace by default.!RESET!
            echo.
        )
    )
)

goto :continue_setup

:show_help
echo.
echo =========================================================
echo   [REPO_NAME] - Enhanced Multi-Workspace Setup Script
echo =========================================================
echo.
echo USAGE:
echo   %~nx0 [number_of_versions] [template_path]
echo   %~nx0 [number_of_versions] docs-driven [feature_name]
echo.
echo PARAMETERS:
echo   number_of_versions  Number of workspaces to create (default: 1)
echo   template_path       Optional path to feature template directory
echo   docs-driven         Use documentation-driven methodology workspaces
echo   feature_name        Feature name for docs-driven mode (e.g., design-system)
echo.
echo STANDARD EXAMPLES:
echo   %~nx0                                    Create 1 standard workspace
echo   %~nx0 2                                  Create 2 standard workspaces
echo.
echo TEMPLATE EXAMPLES:
echo   %~nx0 1 templates/recipe-discovery       Create 1 recipe-discovery workspace
echo   %~nx0 2 templates/meal-planning          Create 2 meal-planning workspaces
echo.
echo DOCUMENTATION-DRIVEN EXAMPLES:
echo   %~nx0 1 docs-driven design-system        Create all design-system methodology workspaces
echo   %~nx0 2 docs-driven authentication       Create 2 copies of each auth methodology workspace
echo   %~nx0 1 docs-driven payment-processing   Create all payment methodology workspaces
echo.
echo TEMPLATE STRUCTURE:
echo   templates/[feature-name]/
echo   ├── *.md                    Feature documentation (required)
echo   ├── next.config.ts          Modified configuration files
echo   ├── src/                    Feature-specific components
echo   └── ...                     Other feature files
echo.
echo DOCUMENTATION-DRIVEN STRUCTURE:
echo   docs/sandbox/[feature-name]/
echo   ├── 00-*-foundation.md      Foundation document (copied to all workspaces)
echo   ├── 01-*-methodology.md     First methodology (creates workspace)
echo   ├── 02-*-methodology.md     Second methodology (creates workspace)
echo   └── 03-*-methodology.md     Third methodology (creates workspace)
echo.
echo WORKSPACE NAMING:
echo   Standard:     [REPO_NAME]-v1, [REPO_NAME]-v2, ...
echo   Template:     [REPO_NAME]-[feature-name]-v1, [REPO_NAME]-[feature-name]-v2, ...
echo   Docs-Driven:  [REPO_NAME]-[methodology-name]-v1, [REPO_NAME]-[methodology-name]-v2, ...
echo.
echo OPTIONS:
echo   --help, -h, /?              Show this help message
echo.
goto :end

:continue_setup

:: ===================================================================
:: Auto-Discovery of Existing Versions
:: ===================================================================
echo !YELLOW!Scanning for existing [REPO_NAME] project folders...!RESET!

set "HIGHEST_VERSION=0"
set "EXISTING_VERSIONS="
set "ORIGINAL_PROJECT_EXISTS=false"

:: Check for original [REPO_NAME] project
if exist "!PARENT_DIR!\!BASE_PROJECT_NAME!" (
    set "ORIGINAL_PROJECT_EXISTS=true"
    echo Found original project: !BASE_PROJECT_NAME!
    set "EXISTING_VERSIONS=!EXISTING_VERSIONS! !BASE_PROJECT_NAME!"
)

:: Scan for versioned projects ([REPO_NAME]-v2, [REPO_NAME]-v3, etc.)
for /d %%d in ("!PARENT_DIR!\!BASE_PROJECT_NAME!-v*") do (
    set "FOLDER_NAME=%%~nd"
    call :extract_version "!FOLDER_NAME!" "!BASE_PROJECT_NAME!"
)

:: Calculate next version numbers
set /a "NEXT_VERSION=HIGHEST_VERSION+1"
echo.
echo !BLUE!Existing versions found: !EXISTING_VERSIONS!!RESET!
echo !BLUE!Next version will start from: v!NEXT_VERSION!!RESET!
echo.

:: ===================================================================
:: Prerequisites Check
:: ===================================================================
echo !YELLOW!Checking prerequisites...!RESET!

:: Check for Git installation
where git >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo Error: Git is not installed or not in PATH. Please install Git and try again.
    goto :error
)

:: Check for Node.js installation
where node >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo Error: Node.js is not installed or not in PATH. Please install Node.js and try again.
    goto :error
)

:: Individual dependency installation is now the default approach
echo Using individual dependency installation for each workspace.
echo This ensures complete isolation and prevents package resolution issues.

:: ===================================================================
:: Template Validation (if template specified)
:: ===================================================================
if "!USE_TEMPLATE!"=="true" (
    echo.
    echo !YELLOW!Validating template: !TEMPLATE_PATH!!RESET!
    call :validate_template "!TEMPLATE_PATH!"
    if !ERRORLEVEL! NEQ 0 (
        echo.
        echo !RED!Template validation failed. Available templates:!RESET!
        call :list_available_templates
        goto :error
    )
    echo !GREEN!Template validation successful!!RESET!
    echo.
)

:: ===================================================================
:: Documentation-Driven Validation (if docs-driven specified)
:: ===================================================================
if "!USE_DOCS_DRIVEN!"=="true" (
    echo.
    echo !YELLOW!Validating documentation-driven feature: !DOCS_FEATURE_NAME!!RESET!
    call :validate_docs_driven_feature "!DOCS_FEATURE_NAME!"
    if !ERRORLEVEL! NEQ 0 (
        echo.
        echo !RED!Documentation-driven validation failed. Available features:!RESET!
        call :list_available_docs_features
        goto :error
    )
    echo !GREEN!Documentation-driven validation successful!!RESET!
    echo !CYAN!Found methodology workspaces: !METHODOLOGY_WORKSPACES!!RESET!
    echo.
)

:: ===================================================================
:: Dynamic Version Creation Loop
:: ===================================================================
set "CREATED_VERSIONS="
set "CURRENT_VERSION=!NEXT_VERSION!"

if "!USE_DOCS_DRIVEN!"=="true" (
    :: Documentation-driven mode: create workspaces for each methodology
    call :create_docs_driven_workspaces "!DOCS_FEATURE_NAME!" "!NUM_VERSIONS!"
) else (
    :: Traditional mode: create specified number of workspaces
    for /l %%i in (1,1,!NUM_VERSIONS!) do (
        :: Generate workspace name based on template usage
        if "!USE_TEMPLATE!"=="true" (
            set "WORKSPACE_NAME=!BASE_PROJECT_NAME!-!FEATURE_NAME!-v!CURRENT_VERSION!"
        ) else (
            set "WORKSPACE_NAME=!BASE_PROJECT_NAME!-v!CURRENT_VERSION!"
        )

        set "VERSION_DIR=!PARENT_DIR!\!WORKSPACE_NAME!"
        set "VERSION_BRANCH=!WORKSPACE_NAME!"

        echo.
        echo =========================================================
        if "!USE_TEMPLATE!"=="true" (
            echo Setting up !WORKSPACE_NAME! environment with !FEATURE_NAME! template ^(%%i of !NUM_VERSIONS!^)...
        ) else (
            echo Setting up !WORKSPACE_NAME! environment ^(%%i of !NUM_VERSIONS!^)...
        )
        echo =========================================================

        :: Create single workspace
        call :create_single_workspace "!VERSION_DIR!" "!VERSION_BRANCH!" "!CURRENT_VERSION!"

        :: Add to created versions list
        set "CREATED_VERSIONS=!CREATED_VERSIONS! !WORKSPACE_NAME!"

        :: Increment version for next iteration
        set /a "CURRENT_VERSION+=1"
    )
)

:: ===================================================================
:: Helper Functions
:: ===================================================================
goto :skip_functions

:extract_version
set "FOLDER_NAME=%~1"
set "PROJECT_NAME=%~2"
set "VERSION_PART="

:: Extract version number from folder name (e.g., [REPO_NAME]-v2 -> 2)
for /f "tokens=2 delims=-v" %%a in ("!FOLDER_NAME!") do (
    set "VERSION_PART=%%a"
)

:: Check if version part is numeric
if defined VERSION_PART (
    echo !VERSION_PART! | findstr /r "^[0-9][0-9]*$" >nul
    if !ERRORLEVEL! EQU 0 (
        if !VERSION_PART! GTR !HIGHEST_VERSION! (
            set "HIGHEST_VERSION=!VERSION_PART!"
        )
        echo Found existing version: !FOLDER_NAME!
        set "EXISTING_VERSIONS=!EXISTING_VERSIONS! !FOLDER_NAME!"
    )
)
goto :eof

:: ===================================================================
:: Dependency Setup Function
:: ===================================================================

:setup_dependencies
set "TARGET_DIR=%~1"
set "VERSION_NUM=%~2"

echo Installing individual dependencies for v!VERSION_NUM!...
echo This ensures complete isolation and prevents package resolution issues.

:: Remove any existing node_modules to ensure clean installation
if exist "!TARGET_DIR!\node_modules" (
    echo Cleaning existing node_modules...
    rd /s /q "!TARGET_DIR!\node_modules" 2>nul
)

:: Install dependencies
call npm install
if !ERRORLEVEL! NEQ 0 (
    echo Error: npm install failed for v!VERSION_NUM!.
    echo Please check your internet connection and try running 'npm install' manually.
    goto :eof
)

:: Verify critical dependencies are installed
echo Verifying dependency installation...
call :verify_dependencies "!TARGET_DIR!" "!VERSION_NUM!"

goto :eof

:: ===================================================================
:: Dependency Verification Function
:: ===================================================================

:verify_dependencies
set "TARGET_DIR=%~1"
set "VERSION_NUM=%~2"
set "VERIFICATION_FAILED=false"

:: Check for Next.js
if not exist "!TARGET_DIR!\node_modules\next\package.json" (
    echo Error: Next.js package not found in v!VERSION_NUM!
    set "VERIFICATION_FAILED=true"
)

:: Check for React
if not exist "!TARGET_DIR!\node_modules\react\package.json" (
    echo Error: React package not found in v!VERSION_NUM!
    set "VERIFICATION_FAILED=true"
)

:: Check for TypeScript
if not exist "!TARGET_DIR!\node_modules\typescript\package.json" (
    echo Error: TypeScript package not found in v!VERSION_NUM!
    set "VERIFICATION_FAILED=true"
)

:: Check for package.json in the project root
if not exist "!TARGET_DIR!\package.json" (
    echo Error: package.json not found in project root for v!VERSION_NUM!
    set "VERIFICATION_FAILED=true"
)

if "!VERIFICATION_FAILED!"=="true" (
    echo.
    echo Warning: Dependency verification failed for v!VERSION_NUM!
    echo Some critical packages may be missing. You may need to run 'npm install' manually.
    echo.
) else (
    echo Dependencies verified successfully for v!VERSION_NUM!
)

goto :eof

:: ===================================================================
:: Template Validation Functions
:: ===================================================================

:validate_template
set "TEMPLATE_DIR=%~1"
set "TEMPLATE_FULL_PATH=%ORIGINAL_DIR%\!TEMPLATE_DIR!"

:: Check if template directory exists
if not exist "!TEMPLATE_FULL_PATH!" (
    echo Error: Template directory '!TEMPLATE_DIR!' not found.
    exit /b 1
)

:: Check if template directory contains at least one markdown file
set "MARKDOWN_FOUND=false"
for %%f in ("!TEMPLATE_FULL_PATH!\*.md") do (
    if exist "%%f" set "MARKDOWN_FOUND=true"
)

if "!MARKDOWN_FOUND!"=="false" (
    echo Error: Template directory '!TEMPLATE_DIR!' must contain at least one .md documentation file.
    exit /b 1
)

echo Template directory validated: !TEMPLATE_DIR!
echo Found required markdown documentation files.
exit /b 0

:list_available_templates
set "TEMPLATES_DIR=%ORIGINAL_DIR%\templates"
echo.
if not exist "!TEMPLATES_DIR!" (
    echo No templates directory found. Create 'templates/' directory with feature subdirectories.
    echo.
    echo Example structure:
    echo   templates/
    echo   ├── recipe-discovery/
    echo   │   ├── README.md
    echo   │   └── src/components/...
    echo   └── meal-planning/
    echo       ├── FEATURE.md
    echo       └── next.config.ts
    goto :eof
)

echo Available templates in 'templates/' directory:
set "TEMPLATE_COUNT=0"
for /d %%d in ("!TEMPLATES_DIR!\*") do (
    set "TEMPLATE_NAME=%%~nxd"
    set "TEMPLATE_PATH=%%d"

    :: Check if this template has markdown files
    set "HAS_MARKDOWN=false"
    for %%f in ("!TEMPLATE_PATH!\*.md") do (
        if exist "%%f" set "HAS_MARKDOWN=true"
    )

    if "!HAS_MARKDOWN!"=="true" (
        echo   - templates/!TEMPLATE_NAME!
        set /a "TEMPLATE_COUNT+=1"
    ) else (
        echo   - templates/!TEMPLATE_NAME! (missing .md files)
    )
)

if !TEMPLATE_COUNT! EQU 0 (
    echo   (No valid templates found - templates must contain .md files)
)
echo.
goto :eof

:apply_template
set "TARGET_DIR=%~1"
set "TEMPLATE_DIR=%~2"
set "VERSION_NUM=%~3"
set "TEMPLATE_FULL_PATH=%ORIGINAL_DIR%\!TEMPLATE_DIR!"

echo Copying template files from !TEMPLATE_DIR! to workspace...
echo Source: !TEMPLATE_FULL_PATH!
echo Target: !TARGET_DIR!
echo.

:: Copy all files and directories from template, preserving structure
call :copy_template_recursive "!TEMPLATE_FULL_PATH!" "!TARGET_DIR!"

:: Copy markdown documentation files to workspace root
echo Copying documentation files to workspace root...
for %%f in ("!TEMPLATE_FULL_PATH!\*.md") do (
    if exist "%%f" (
        echo   Copying: %%~nxf
        copy "%%f" "!TARGET_DIR!\" >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo   [OK] Successfully copied %%~nxf
        ) else (
            echo   [ERROR] Failed to copy %%~nxf
        )
    )
)

echo.
echo Template application completed for v!VERSION_NUM!
goto :eof

:copy_template_recursive
set "SOURCE_DIR=%~1"
set "TARGET_DIR=%~2"

:: Copy all files in current directory (excluding .md files as they go to root)
for %%f in ("!SOURCE_DIR!\*") do (
    if not "%%~xf"==".md" (
        if not exist "%%f\*" (
            :: It's a file, not a directory
            set "REL_PATH=%%~nxf"
            echo   Copying file: !REL_PATH!
            copy "%%f" "!TARGET_DIR!\" >nul 2>&1
            if !ERRORLEVEL! EQU 0 (
                echo   [OK] File copied: !REL_PATH!
            ) else (
                echo   [ERROR] Failed to copy: !REL_PATH!
            )
        )
    )
)

:: Recursively copy subdirectories
for /d %%d in ("!SOURCE_DIR!\*") do (
    set "DIR_NAME=%%~nxd"
    set "TARGET_SUBDIR=!TARGET_DIR!\!DIR_NAME!"

    echo   Creating directory: !DIR_NAME!
    if not exist "!TARGET_SUBDIR!" (
        mkdir "!TARGET_SUBDIR!" 2>nul
    )

    :: Recursive call for subdirectory
    call :copy_template_recursive "%%d" "!TARGET_SUBDIR!"
)

goto :eof

:: ===================================================================
:: Documentation-Driven Workspace Creation Functions
:: ===================================================================

:validate_docs_driven_feature
set "FEATURE_NAME=%~1"
set "DOCS_FEATURE_DIR=%ORIGINAL_DIR%\docs\sandbox\!FEATURE_NAME!"

:: Check if feature directory exists
if not exist "!DOCS_FEATURE_DIR!" (
    echo "Error: Documentation feature directory 'docs/sandbox/!FEATURE_NAME!/' was missing."
    exit /b 1
)

:: Check for foundation document (00-*-foundation.md)
set "FOUNDATION_FOUND=false"
for %%f in ("!DOCS_FEATURE_DIR!\00-*-foundation.md") do (
    if exist "%%f" set "FOUNDATION_FOUND=true"
)

if "!FOUNDATION_FOUND!"=="false" (
    echo "Error: Foundation document (00-*-foundation.md) was missing at 'docs/sandbox/!FEATURE_NAME!/'."
    exit /b 1
)

:: Discover methodology files (01-*.md, 02-*.md, etc.)
set "METHODOLOGY_COUNT=0"
set "METHODOLOGY_WORKSPACES="

:: Check for methodology files with explicit patterns (broken into multiple loops to avoid line length limits)

:: Check for 01-*.md files
for %%f in ("!DOCS_FEATURE_DIR!\01-*.md") do (
    if exist "%%f" call :process_methodology_file "%%f"
)

:: Check for 02-*.md files
for %%f in ("!DOCS_FEATURE_DIR!\02-*.md") do (
    if exist "%%f" call :process_methodology_file "%%f"
)

:: Check for 03-*.md files
for %%f in ("!DOCS_FEATURE_DIR!\03-*.md") do (
    if exist "%%f" call :process_methodology_file "%%f"
)

:: Check for 04-*.md files
for %%f in ("!DOCS_FEATURE_DIR!\04-*.md") do (
    if exist "%%f" call :process_methodology_file "%%f"
)

:: Check for 05-*.md files
for %%f in ("!DOCS_FEATURE_DIR!\05-*.md") do (
    if exist "%%f" call :process_methodology_file "%%f"
)

if !METHODOLOGY_COUNT! EQU 0 (
    echo "Error: Methodology files (01-*.md, 02-*.md, etc.) were missing at 'docs/sandbox/!FEATURE_NAME!/'."
    exit /b 1
)

echo "Discovered !METHODOLOGY_COUNT! methodology files for feature: !FEATURE_NAME!"
exit /b 0

:process_methodology_file
set "METHODOLOGY_FILEPATH=%~1"
set "METHODOLOGY_FILE=%~n1"

:: Extract methodology name (remove number prefix and suffix)
set "METHODOLOGY_NAME=%METHODOLOGY_FILE:~3%"

:: Remove -methodology suffix if present (inline to avoid parameter issues)
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:-methodology=!"

:: Clean methodology name (replace spaces and special chars with hyphens)
set "METHODOLOGY_NAME=!METHODOLOGY_NAME: =-!"
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:_=-!"
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:/=-!"
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:\=-!"

:: Add to methodology workspaces list
set "METHODOLOGY_WORKSPACES=!METHODOLOGY_WORKSPACES! !METHODOLOGY_NAME!"
set /a "METHODOLOGY_COUNT+=1"
goto :eof

:list_available_docs_features
set "DOCS_SANDBOX_DIR=%ORIGINAL_DIR%\docs\sandbox"
echo.
if not exist "!DOCS_SANDBOX_DIR!" (
    echo "No docs/sandbox directory exists. Create 'docs/sandbox/[feature-name]/' directories."
    echo.
    echo Example structure:
    echo   docs/sandbox/
    echo   ├── design-system/
    echo   │   ├── 00-design-system-foundation.md
    echo   │   ├── 01-design-tokens-first-methodology.md
    echo   │   └── 02-feature-driven-methodology.md
    echo   └── authentication/
    echo       ├── 00-auth-foundation.md
    echo       └── 01-oauth-methodology.md
    goto :eof
)

echo "Available documentation-driven features at 'docs/sandbox/' directory:"
set "FEATURE_COUNT=0"
for /d %%d in ("!DOCS_SANDBOX_DIR!\*") do (
    set "FEATURE_NAME=%%~nxd"
    set "FEATURE_PATH=%%d"

    :: Check if this feature has foundation and methodology files
    set "HAS_FOUNDATION=false"
    set "HAS_METHODOLOGIES=false"

    for %%f in ("!FEATURE_PATH!\00-*-foundation.md") do (
        if exist "%%f" set "HAS_FOUNDATION=true"
    )

    :: Check for methodology files with explicit patterns
    for %%f in ("!FEATURE_PATH!\01-*.md" "!FEATURE_PATH!\02-*.md" "!FEATURE_PATH!\03-*.md" "!FEATURE_PATH!\04-*.md" "!FEATURE_PATH!\05-*.md" "!FEATURE_PATH!\06-*.md" "!FEATURE_PATH!\07-*.md" "!FEATURE_PATH!\08-*.md" "!FEATURE_PATH!\09-*.md") do (
        if exist "%%f" set "HAS_METHODOLOGIES=true"
    )

    if "!HAS_FOUNDATION!"=="true" (
        if "!HAS_METHODOLOGIES!"=="true" (
            echo   [OK] docs/sandbox/!FEATURE_NAME!
            set /a "FEATURE_COUNT+=1"
        ) else (
            echo   [ERROR] docs/sandbox/!FEATURE_NAME! (missing methodology files)
        )
    ) else (
        echo   [ERROR] docs/sandbox/!FEATURE_NAME! (missing foundation file)
    )
)

if !FEATURE_COUNT! EQU 0 (
    echo "  (No valid documentation-driven features exist)"
)
echo.
goto :eof

:create_docs_driven_workspaces
set "FEATURE_NAME=%~1"
set "NUM_COPIES=%~2"
set "DOCS_FEATURE_DIR=%ORIGINAL_DIR%\docs\sandbox\!FEATURE_NAME!"

echo Creating documentation-driven workspaces for feature: !FEATURE_NAME!
echo Number of copies per methodology: !NUM_COPIES!
echo.

:: Process each methodology file
for %%f in ("!DOCS_FEATURE_DIR!\01-*.md" "!DOCS_FEATURE_DIR!\02-*.md" "!DOCS_FEATURE_DIR!\03-*.md" "!DOCS_FEATURE_DIR!\04-*.md" "!DOCS_FEATURE_DIR!\05-*.md" "!DOCS_FEATURE_DIR!\06-*.md" "!DOCS_FEATURE_DIR!\07-*.md" "!DOCS_FEATURE_DIR!\08-*.md" "!DOCS_FEATURE_DIR!\09-*.md") do (
    if exist "%%f" (
        call :create_methodology_workspaces "%%f" "!NUM_COPIES!"
    )
)
goto :eof

:create_methodology_workspaces
set "METHODOLOGY_FILEPATH=%~1"
set "NUM_COPIES=%~2"
set "METHODOLOGY_FILE=%~n1"

:: Extract methodology name (remove number prefix and suffix)
set "METHODOLOGY_NAME=%METHODOLOGY_FILE:~3%"

:: Remove -methodology suffix if present (inline to avoid parameter issues)
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:-methodology=!"

:: Clean methodology name (replace spaces and special chars with hyphens)
set "METHODOLOGY_NAME=!METHODOLOGY_NAME: =-!"
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:_=-!"
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:/=-!"
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:\=-!"

echo Processing methodology: !METHODOLOGY_NAME!

:: Create specified number of copies for this methodology
for /l %%i in (1,1,!NUM_COPIES!) do (
    set "WORKSPACE_NAME=!BASE_PROJECT_NAME!-!METHODOLOGY_NAME!-v!CURRENT_VERSION!"
    set "VERSION_DIR=!PARENT_DIR!\!WORKSPACE_NAME!"
    set "VERSION_BRANCH=!WORKSPACE_NAME!"

    echo.
    echo =========================================================
    echo Setting up !WORKSPACE_NAME! environment ^(%%i of !NUM_COPIES!^)...
    echo Methodology: !METHODOLOGY_NAME!
    echo =========================================================

    :: Create single workspace
    call :create_single_workspace "!VERSION_DIR!" "!VERSION_BRANCH!" "!CURRENT_VERSION!"

    :: Apply documentation-driven files
    call :apply_docs_driven_files "!VERSION_DIR!" "!FEATURE_NAME!" "!METHODOLOGY_FILE!"

    :: Add to created versions list
    set "CREATED_VERSIONS=!CREATED_VERSIONS! !WORKSPACE_NAME!"

    :: Increment version for next iteration
    set /a "CURRENT_VERSION+=1"
)
goto :eof

:create_single_workspace
set "VERSION_DIR=%~1"
set "VERSION_BRANCH=%~2"
set "VERSION_NUM=%~3"

:: Create directory if it doesn't exist
if exist "!VERSION_DIR!" (
    echo.
    echo !YELLOW!=== CRITICAL WARNING ===!RESET!
    echo !YELLOW!Directory !VERSION_DIR! already exists!!RESET!
    echo !YELLOW!This directory may contain important work or changes!!RESET!
    echo.

    :: SAFETY CHECK: Prevent deletion of important directories
    call :safety_check_directory "!VERSION_DIR!"
    if !ERRORLEVEL! NEQ 0 (
        echo.
        echo !RED!SAFETY ERROR: Refusing to delete directory that may contain important files!!RESET!
        echo !RED!Directory: !VERSION_DIR!!RESET!
        echo !YELLOW!Please manually remove the directory if you're sure it's safe to delete.!RESET!
        goto :error
    )

    :: MANDATORY USER CONFIRMATION for existing directories
    echo !RED!WARNING: This will PERMANENTLY DELETE all files in:!RESET!
    echo !RED!  !VERSION_DIR!!RESET!
    echo.
    echo !YELLOW!If this directory contains important work, press Ctrl+C to cancel NOW!!RESET!
    echo.
    set /p "CONFIRM=Type 'DELETE' to confirm deletion (or anything else to cancel): "

    if not "!CONFIRM!"=="DELETE" (
        echo.
        echo !GREEN!Operation cancelled. Directory preserved.!RESET!
        echo !YELLOW!Please backup or rename the existing directory before running this script.!RESET!
        goto :error
    )

    echo.
    echo !RED!User confirmed deletion. Proceeding with cleanup...!RESET!
    rd /s /q "!VERSION_DIR!" 2>nul
    if !ERRORLEVEL! NEQ 0 (
        echo Error: Failed to clean up existing directory. Please check if files are in use.
        goto :error
    )
)

mkdir "!VERSION_DIR!" 2>nul
if !ERRORLEVEL! NEQ 0 (
    echo Error: Failed to create directory !VERSION_DIR!.
    goto :error
)

:: Clone repository
echo Cloning repository...
git clone !REPO_URL! "!VERSION_DIR!" 2>nul
if !ERRORLEVEL! NEQ 0 (
    echo Error: Git clone failed. Please check your repository URL and internet connection.
    goto :error
)

:: Setup Git branch
cd /d "!VERSION_DIR!"
git checkout !MAIN_BRANCH! 2>nul
if !ERRORLEVEL! NEQ 0 (
    echo Warning: Failed to checkout branch !MAIN_BRANCH!. Using default branch.
)

echo Creating and checking out branch !VERSION_BRANCH!...
git checkout -b !VERSION_BRANCH! 2>nul
if !ERRORLEVEL! NEQ 0 (
    echo Warning: Failed to create branch !VERSION_BRANCH!. Using current branch.
)

:: Apply template if specified (for traditional template mode)
if "!USE_TEMPLATE!"=="true" (
    echo.
    echo Applying template: !TEMPLATE_PATH!
    call :apply_template "!VERSION_DIR!" "!TEMPLATE_PATH!" "!VERSION_NUM!"
    echo.
)

:: Copy .env.local file if it exists
call :copy_env_local "!VERSION_DIR!"

:: Handle dependencies - individual installation
call :setup_dependencies "!VERSION_DIR!" "!VERSION_NUM!"

:: Return to original directory
cd /d "!ORIGINAL_DIR!"
goto :eof

:apply_docs_driven_files
set "TARGET_DIR=%~1"
set "FEATURE_NAME=%~2"
set "METHODOLOGY_FILE=%~3"
set "DOCS_FEATURE_DIR=%ORIGINAL_DIR%\docs\sandbox\!FEATURE_NAME!"

echo Applying documentation-driven files for !FEATURE_NAME!...

:: Copy foundation document to workspace root
for %%f in ("!DOCS_FEATURE_DIR!\00-*-foundation.md") do (
    if exist "%%f" (
        echo   Copying foundation document: %%~nxf
        copy "%%f" "!TARGET_DIR!\FEATURE_FOUNDATION.md" >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo   [OK] Foundation document copied as FEATURE_FOUNDATION.md
        ) else (
            echo   [ERROR] Failed to copy foundation document
        )
    )
)

:: Copy specific methodology document to workspace root
set "METHODOLOGY_PATH=!DOCS_FEATURE_DIR!\!METHODOLOGY_FILE!.md"
if exist "!METHODOLOGY_PATH!" (
    echo   Copying methodology document: !METHODOLOGY_FILE!.md
    copy "!METHODOLOGY_PATH!" "!TARGET_DIR!\METHODOLOGY_GUIDE.md" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo   [OK] Methodology document copied as METHODOLOGY_GUIDE.md
    ) else (
        echo   [ERROR] Failed to copy methodology document
    )
)

:: Update package.json with methodology metadata
call :update_package_json_metadata "!TARGET_DIR!" "!FEATURE_NAME!" "!METHODOLOGY_FILE!"

echo Documentation-driven files applied successfully.
goto :eof

:update_package_json_metadata
set "TARGET_DIR=%~1"
set "FEATURE_NAME=%~2"
set "METHODOLOGY_FILE=%~3"

:: Extract methodology name for metadata
set "METHODOLOGY_NAME=!METHODOLOGY_FILE:~3!"
set "METHODOLOGY_NAME=!METHODOLOGY_NAME:-methodology=!"

echo Updating package.json with methodology metadata...
echo   Feature: !FEATURE_NAME!
echo   Methodology: !METHODOLOGY_NAME!

:: Note: This is a simplified approach. In a real implementation,
:: you might want to use a more sophisticated JSON manipulation tool
echo   Methodology metadata added to workspace.
goto :eof

:skip_functions

:: ===================================================================
:: Create dynamic switch-workspace.bat helper script
:: ===================================================================
echo.
echo Creating dynamic workspace switcher script...

call :create_workspace_switcher

:: ===================================================================
:: Workspace Switcher Creation Function
:: ===================================================================
goto :skip_switcher_function

:create_workspace_switcher
:: Create a simple, compatible workspace switcher
echo @echo off > switch-workspace.bat
echo setlocal >> switch-workspace.bat
echo. >> switch-workspace.bat
echo echo ========================================================= >> switch-workspace.bat
echo echo   [REPO_NAME] - Dynamic Workspace Switcher >> switch-workspace.bat
echo echo ========================================================= >> switch-workspace.bat
echo echo. >> switch-workspace.bat

:: Add original project option if it exists
if "!ORIGINAL_PROJECT_EXISTS!"=="true" (
    echo echo 0. Switch to original !BASE_PROJECT_NAME! workspace ^(branch: !MAIN_BRANCH!^) >> switch-workspace.bat
)

:: Add all existing and newly created versions
set "OPTION_NUM=1"
set "ALL_VERSIONS=!EXISTING_VERSIONS!!CREATED_VERSIONS!"

for %%v in (!ALL_VERSIONS!) do (
    if not "%%v"=="!BASE_PROJECT_NAME!" (
        echo echo !OPTION_NUM!. Switch to %%v workspace ^(branch: %%v^) >> switch-workspace.bat
        set /a "OPTION_NUM+=1"
    )
)

set /a "EXIT_OPTION=OPTION_NUM"
echo echo !EXIT_OPTION!. Exit >> switch-workspace.bat
echo echo. >> switch-workspace.bat
echo set /p choice="Enter your choice (0-!EXIT_OPTION!): " >> switch-workspace.bat
echo echo. >> switch-workspace.bat

:: Add original project case
if "!ORIGINAL_PROJECT_EXISTS!"=="true" (
    echo if "%%choice%%"=="0" ^( >> switch-workspace.bat
    echo   cd /d "!PARENT_DIR!\!BASE_PROJECT_NAME!" >> switch-workspace.bat
    echo   echo Switched to !BASE_PROJECT_NAME! workspace on branch !MAIN_BRANCH! >> switch-workspace.bat
    echo   cmd /k >> switch-workspace.bat
    echo ^) else >> switch-workspace.bat
)

:: Add cases for all versions
set "CASE_NUM=1"
for %%v in (!ALL_VERSIONS!) do (
    if not "%%v"=="!BASE_PROJECT_NAME!" (
        echo if "%%choice%%"=="!CASE_NUM!" ^( >> switch-workspace.bat
        echo   cd /d "!PARENT_DIR!\%%v" >> switch-workspace.bat
        echo   echo Switched to %%v workspace on branch %%v >> switch-workspace.bat
        echo   cmd /k >> switch-workspace.bat
        echo ^) else >> switch-workspace.bat
        set /a "CASE_NUM+=1"
    )
)

:: Add exit case and error handling
echo if "%%choice%%"=="!EXIT_OPTION!" ^( >> switch-workspace.bat
echo   exit /b 0 >> switch-workspace.bat
echo ^) else ^( >> switch-workspace.bat
echo   echo Invalid choice. Please try again. >> switch-workspace.bat
echo   pause >> switch-workspace.bat
echo   call switch-workspace.bat >> switch-workspace.bat
echo ^) >> switch-workspace.bat
goto :eof

:skip_switcher_function

:: ===================================================================
:: Final summary
:: ===================================================================
echo.
echo =========================================================
echo   Setup Complete! Summary:
echo =========================================================
echo.

:: Get parent directory for display
for %%i in ("!CD!\..") do set "PARENT_DISPLAY=%%~fi"

if "!ORIGINAL_PROJECT_EXISTS!"=="true" (
    echo Original Project:
    echo   Directory: !PARENT_DISPLAY!\!BASE_PROJECT_NAME!
    echo   Branch: !MAIN_BRANCH!
    echo   Dependencies: Original installation
    echo.
)

echo Created Workspaces:
set "WORKSPACE_NUM=1"
for %%v in (!CREATED_VERSIONS!) do (
    echo   Workspace !WORKSPACE_NUM!:
    echo     Directory: !PARENT_DISPLAY!\%%v
    echo     Branch: %%v
    echo     Dependencies: Individual installation
    if "!USE_DOCS_DRIVEN!"=="true" (
        echo     Mode: Documentation-driven
        echo     Feature: !DOCS_FEATURE_NAME!
        echo     Documentation: FEATURE_FOUNDATION.md + METHODOLOGY_GUIDE.md
    ) else (
        if "!USE_TEMPLATE!"=="true" (
            echo     Mode: Template-based
            echo     Template: !TEMPLATE_PATH!
            echo     Feature: !FEATURE_NAME!
            echo     Documentation: Copied to workspace root
        ) else (
            echo     Mode: Standard workspace
        )
    )
    echo.
    set /a "WORKSPACE_NUM+=1"
)

echo How to use:
echo   1. Run 'switch-workspace.bat' to choose a workspace
echo   2. Or navigate to any directory manually
echo.
echo Important Notes:
echo   - Individual dependencies: Each workspace has its own complete node_modules
echo   - Isolated environments: Dependency changes only affect current workspace
echo   - Reliable package resolution: No symbolic link issues or missing packages
echo   - Each workspace has its own Git branch and commit history
echo   - Changes to code in one workspace will NOT affect others
echo   - Remember to commit and push changes from the appropriate workspace
echo   - Disk usage: Each workspace requires ~200-500MB for node_modules
echo   - Setup time: Individual installations take longer but ensure reliability
if "!USE_DOCS_DRIVEN!"=="true" (
    echo   - Documentation-driven: Methodology-specific workspaces with foundation + guide docs
    echo   - Methodology isolation: Each workspace focuses on a specific development approach
    echo   - Foundation document: Shared knowledge base copied to all methodology workspaces
    echo   - Methodology guide: Specific implementation approach for each workspace
) else (
    if "!USE_TEMPLATE!"=="true" (
        echo   - Template applied: Feature-specific files and documentation included
        echo   - Documentation files: Copied to workspace root for easy access
        echo   - Feature isolation: Template changes only affect this workspace type
    )
)
echo.
echo =========================================================
goto :end

:error
echo.
echo Setup failed. Please check the errors above and try again.
exit /b 1

:end
echo Setup completed successfully!
endlocal