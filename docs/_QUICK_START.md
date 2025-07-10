# ChatGPT

I need a PRD in markdown format for a full feature [app_idea] with [integration]

# Augment Code

## Prompts
Enhance the PRD.md file based on the best practices outlined in the @SOLO_DEVELOPMENT_BEST_PRACTICES.md
Create a roadmap from @PRD.md following the @ROADMAP_TEMPLATE.md template
Create or update the AUGMENT_MEMORIES.txt file in the templates directory to serve as a comprehensive AI context and memory file for the [app_name] project development workflow
For each phase of development listed @ROADMAP.md, create a new directory in docs/sandbox/[feature-name]/ with the necessary markdown files for Documentation-Driven Development
Set-up gitignore file, commit files and publish repo
Run ‘setup-dual-environments.bat [number] docs-driven [feature-name]’ to start development
Start [PHASE] refer to @FEATURE_FOUNDATION.md and @METHODOLOGY_GUIDE.md for details

## Trouble Shooting
When you get in trouble … this feature development process has been a mess. I'd like for you to create a lessons learned document and then use that document to improve the @METHODOLOGY_GUIDE.md in order to rebuild this feature from scratch in a cleaner and more efficient way
After reviewing @LESSONS_LEARNED_[FEATURE_NAME].md, @[FEATURE_NAME]_REBUILD_STRATEGY.md and the updated @METHODOLOGY_GUIDE.md, I'd like to rebuild this feature from scratch.

## Powershell Commands
Remove-Item -Recurse -Force .git
