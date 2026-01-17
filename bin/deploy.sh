#!/bin/bash
set -e

VERSION_TYPE=${1:-patch}

if [[ ! "$VERSION_TYPE" =~ ^(patch|minor|major)$ ]]; then
  echo "Usage: $0 [patch|minor|major]"
  echo "  patch: 1.0.0 -> 1.0.1"
  echo "  minor: 1.0.0 -> 1.1.0"
  echo "  major: 1.0.0 -> 2.0.0"
  exit 1
fi

echo "🚀 Starting deployment process..."

# Ensure we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "❌ Must be on main branch to deploy (currently on $CURRENT_BRANCH)"
  exit 1
fi

# Ensure working directory is clean
if [[ -n $(git status -s) ]]; then
  echo "❌ Working directory is not clean. Commit or stash changes first."
  git status -s
  exit 1
fi

# Pull latest changes
echo "📥 Pulling latest changes..."
git pull origin main

# Run tests
echo "🧪 Running tests..."
mix test || {
  echo "❌ Tests failed. Fix them before deploying."
  exit 1
}

# Get current version from mix.exs
CURRENT_VERSION=$(grep 'version:' mix.exs | head -n 1 | sed 's/.*version: "\(.*\)".*/\1/')
echo "📌 Current version: $CURRENT_VERSION"

# Calculate new version
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

case $VERSION_TYPE in
  major)
    NEW_VERSION="$((MAJOR + 1)).0.0"
    ;;
  minor)
    NEW_VERSION="$MAJOR.$((MINOR + 1)).0"
    ;;
  patch)
    NEW_VERSION="$MAJOR.$MINOR.$((PATCH + 1))"
    ;;
esac

echo "🆕 New version: $NEW_VERSION"

# Update version in mix.exs
sed -i "s/version: \"$CURRENT_VERSION\"/version: \"$NEW_VERSION\"/" mix.exs

# Commit version bump
git add mix.exs
git commit -m "Bump version to $NEW_VERSION"

# Create git tag
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

# Push to git
echo "📤 Pushing to git..."
git push origin main
git push origin "v$NEW_VERSION"

# Deploy to Fly.io
echo "🚢 Deploying to Fly.io..."
fly deploy --remote-only

echo "✅ Deployment complete!"
echo "📦 Version: $NEW_VERSION"
echo "🌐 Check status: fly status"
echo "📊 View logs: fly logs"
