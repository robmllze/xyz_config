# Workflow for Managing Pub.dev Packages

This workflow streamlines the process of managing your pub.dev packages by automatically updating the CHANGELOG.md with each commit and automatically publishing your package to pub.dev upon creating a GitHub release.

## Setup Instructions

**1. Navigate to your project:**

```zsh
cd your_project
```

**2. Clone this repo into a `.github/` folder:**

```zsh
git clone https://github.com/robmllze/pub.dev_package_workflow.git .github
```

**3. Remove the `/.git` folder to include it to your project:**
   
*On macOS and Linux:*
```zsh
rm -rf .github/.git/
```

*On Windows:*
```cmd
rmdir /s /q .github/.git/
```


