#!/bin/bash

# Script to copy template feature and rename it with a new feature name
# Usage: ./feat.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FEATURES_DIR="$SCRIPT_DIR/lib/features"
TEMPLATE_DIR="$FEATURES_DIR/template"

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "${RED}Error: Template directory not found at $TEMPLATE_DIR${NC}"
    exit 1
fi

# Prompt for feature name
echo -e "${YELLOW}Enter feature name in snake_case (e.g., user_profile, product_list):${NC}"
read -r FEATURE_NAME

# Validate snake_case format
if [[ ! "$FEATURE_NAME" =~ ^[a-z][a-z0-9_]*[a-z0-9]$ ]]; then
    echo -e "${RED}Error: Feature name must be in snake_case (e.g., user_profile, product_list)${NC}"
    exit 1
fi

# Check if feature already exists (before prompting for GlobalBloc)
NEW_FEATURE_DIR="$FEATURES_DIR/$FEATURE_NAME"
if [ -d "$NEW_FEATURE_DIR" ]; then
    echo -e "${RED}✗ Error: Feature '$FEATURE_NAME' already exists!${NC}"
    echo -e "${RED}  Location: $NEW_FEATURE_DIR${NC}"
    echo -e "${YELLOW}  Please choose a different feature name or remove the existing feature directory.${NC}"
    exit 1
fi

# Prompt for GlobalBloc
echo -e "${YELLOW}GlobalBloc (true/false):${NC}"
read -r GLOBAL_BLOC_INPUT

# Validate and normalize GlobalBloc input
GLOBAL_BLOC=false
if [[ "$GLOBAL_BLOC_INPUT" =~ ^[Tt][Rr][Uu][Ee]$ ]] || [[ "$GLOBAL_BLOC_INPUT" == "true" ]]; then
    GLOBAL_BLOC=true
elif [[ ! "$GLOBAL_BLOC_INPUT" =~ ^[Ff][Aa][Ll][Ss][Ee]$ ]] && [[ "$GLOBAL_BLOC_INPUT" != "false" ]]; then
    echo -e "${RED}Error: GlobalBloc must be 'true' or 'false'${NC}"
    exit 1
fi

# Convert snake_case to PascalCase
# e.g., user_profile -> UserProfile, login -> Login
PASCAL_CASE=$(echo "$FEATURE_NAME" | awk -F'_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}' OFS='')

# Convert snake_case to camelCase
# e.g., user_profile -> userProfile, login -> login
if [[ "$FEATURE_NAME" == *_* ]]; then
    # Has underscores: convert first letter after each underscore to uppercase, then lowercase first letter
    CAMEL_CASE=$(echo "$FEATURE_NAME" | awk -F'_' '{for(i=2;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}' OFS='')
else
    # No underscores: keep as is (already camelCase)
    CAMEL_CASE="$FEATURE_NAME"
fi

echo -e "${GREEN}Creating feature '$FEATURE_NAME'...${NC}"
echo -e "  snake_case: $FEATURE_NAME"
echo -e "  PascalCase: $PASCAL_CASE"
echo -e "  camelCase: $CAMEL_CASE"

# Copy template directory
cp -r "$TEMPLATE_DIR" "$NEW_FEATURE_DIR"

# Function to rename files recursively using find
rename_files() {
    local root_dir=$1
    local old_name=$2
    local new_name=$3
    
    # Use find to get all files and directories, process directories first (depth-first)
    # Get all directories that need renaming, sorted by depth (deepest first)
    find "$root_dir" -type d -name "*${old_name}*" | sort -r | while read -r dir; do
        local dir_parent=$(dirname "$dir")
        local dir_basename=$(basename "$dir")
        local new_dir_basename=$(echo "$dir_basename" | sed "s/$old_name/$new_name/g")
        if [ "$dir_basename" != "$new_dir_basename" ]; then
            mv "$dir" "$dir_parent/$new_dir_basename"
            echo "  Renamed directory: $dir_basename -> $new_dir_basename"
        fi
    done
    
    # Get all files that need renaming
    find "$root_dir" -type f -name "*${old_name}*" | while read -r file; do
        local file_parent=$(dirname "$file")
        local file_basename=$(basename "$file")
        local new_file_basename=$(echo "$file_basename" | sed "s/$old_name/$new_name/g")
        if [ "$file_basename" != "$new_file_basename" ]; then
            mv "$file" "$file_parent/$new_file_basename"
            echo "  Renamed file: $file_basename -> $new_file_basename"
        fi
    done
}

# Rename files and directories
echo -e "${GREEN}Renaming files and directories...${NC}"
rename_files "$NEW_FEATURE_DIR" "template" "$FEATURE_NAME"

# Function to replace content in files
replace_content() {
    local file=$1
    local old_pattern=$2
    local new_pattern=$3
    
    # Escape special characters in patterns for sed
    # Escape forward slashes and ampersands
    local escaped_old=$(echo "$old_pattern" | sed 's/\//\\\//g; s/&/\\&/g')
    local escaped_new=$(echo "$new_pattern" | sed 's/\//\\\//g; s/&/\\&/g')
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/$escaped_old/$escaped_new/g" "$file"
    else
        # Linux
        sed -i "s/$escaped_old/$escaped_new/g" "$file"
    fi
}

# Function to process all Dart files
process_dart_files() {
    local dir=$1
    
    find "$dir" -type f -name "*.dart" | while read -r file; do
        echo "  Processing: $file"
        
        # Replace Template* class names with PascalCase*
        replace_content "$file" "TemplatePage" "${PASCAL_CASE}Page"
        replace_content "$file" "TemplateBloc" "${PASCAL_CASE}Bloc"
        replace_content "$file" "TemplateEvent" "${PASCAL_CASE}Event"
        replace_content "$file" "TemplateState" "${PASCAL_CASE}State"
        replace_content "$file" "TemplateRepository" "${PASCAL_CASE}Repository"
        replace_content "$file" "TemplateExt" "${PASCAL_CASE}Ext"
        
        # Replace template* variable names with camelCase*
        replace_content "$file" "templateBloc" "${CAMEL_CASE}Bloc"
        replace_content "$file" "templateState" "${CAMEL_CASE}State"
        replace_content "$file" "templateListener" "${CAMEL_CASE}Listener"
        replace_content "$file" "templateRepository" "${CAMEL_CASE}Repository"
        replace_content "$file" "addTemplateEvent" "add${PASCAL_CASE}Event"
        
        # Replace file paths in imports/exports
        replace_content "$file" "/template/" "/$FEATURE_NAME/"
        replace_content "$file" "'template_" "'${FEATURE_NAME}_"
        replace_content "$file" '"template_' "\"${FEATURE_NAME}_"
        replace_content "$file" "template_page" "${FEATURE_NAME}_page"
        replace_content "$file" "template_bloc" "${FEATURE_NAME}_bloc"
        replace_content "$file" "template_event" "${FEATURE_NAME}_event"
        replace_content "$file" "template_state" "${FEATURE_NAME}_state"
        replace_content "$file" "template_ext" "${FEATURE_NAME}_ext"
        replace_content "$file" "template_repository" "${FEATURE_NAME}_repository"
    done
}

# Replace content in all Dart files
echo -e "${GREEN}Replacing content in Dart files...${NC}"
process_dart_files "$NEW_FEATURE_DIR"

# Always update app.dart to add import and repository provider
echo -e "${GREEN}Updating app.dart...${NC}"
APP_DART="$SCRIPT_DIR/lib/app/app.dart"

if [ ! -f "$APP_DART" ]; then
    echo -e "${RED}Warning: app.dart not found at $APP_DART${NC}"
else
    # Add import for the new feature (always needed for repository)
    IMPORT_LINE="import '../features/$FEATURE_NAME/index.dart';"
    
    # Check if import already exists
    if ! grep -q "$IMPORT_LINE" "$APP_DART"; then
        # Add import before the class definition using awk
        awk -v import_line="$IMPORT_LINE" '
            /^class App / {
                print import_line
            }
            { print }
        ' "$APP_DART" > "$APP_DART.tmp" && mv "$APP_DART.tmp" "$APP_DART"
        echo "  Added import: $IMPORT_LINE"
    fi
    
    # Add repository to Provider list (always added, before the marker comment)
    REPO_LINE="        Provider<${PASCAL_CASE}Repository>(create: (_) => ${PASCAL_CASE}Repository()),"
    if ! grep -q "Provider<${PASCAL_CASE}Repository>" "$APP_DART"; then
        # Use awk to insert before the marker comment
        awk -v repo_line="$REPO_LINE" '
            /<add more repo here>.*MARKER FOR BASH SCRIPT/ {
                print repo_line
            }
            { print }
        ' "$APP_DART" > "$APP_DART.tmp" && mv "$APP_DART.tmp" "$APP_DART"
        echo "  Added repository provider: ${PASCAL_CASE}Repository"
    fi
    
    # Add BlocProvider to MultiBlocProvider list only if GlobalBloc is true
    if [ "$GLOBAL_BLOC" = true ]; then
        BLOC_LINE="              BlocProvider(create: (_) => ${PASCAL_CASE}Bloc(context.read<${PASCAL_CASE}Repository>())),"
        if ! grep -q "BlocProvider.*${PASCAL_CASE}Bloc" "$APP_DART"; then
            # Use awk to insert before the marker comment
            awk -v bloc_line="$BLOC_LINE" '
                /add more global bloc here.*MARKER FOR BASH SCRIPT/ {
                    print bloc_line
                }
                { print }
            ' "$APP_DART" > "$APP_DART.tmp" && mv "$APP_DART.tmp" "$APP_DART"
            echo "  Added global bloc provider: ${PASCAL_CASE}Bloc"
        fi
    fi
fi

# Update the page file to use global bloc only if GlobalBloc is true
if [ "$GLOBAL_BLOC" = true ]; then
    PAGE_FILE="$NEW_FEATURE_DIR/${FEATURE_NAME}_page.dart"
    if [ -f "$PAGE_FILE" ]; then
        echo -e "${GREEN}Updating page file to use global bloc...${NC}"
        # Replace local bloc creation with global bloc access
        # Pattern: late final bloc = PascalCaseBloc(context.read<PascalCaseRepository>());
        # Replace with: late final bloc = context.read<PascalCaseBloc>();
        
        # Use sed with a flexible pattern that matches any Bloc name
        # This works because we know the exact structure after processing
        # Replace with type annotation: late final PascalCaseBloc bloc = context.read<PascalCaseBloc>();
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS - use sed with extended regex
            sed -i '' -E "s/late final bloc = ${PASCAL_CASE}Bloc\(context\.read<${PASCAL_CASE}Repository>\(\)\);/late final ${PASCAL_CASE}Bloc bloc = context.read<${PASCAL_CASE}Bloc>();/g" "$PAGE_FILE"
            # Replace BlocProvider(create: (_) => bloc,) with BlocProvider.value(value: bloc,)
            # Handle whitespace variations
            sed -i '' -E "s/return BlocProvider\(/return BlocProvider.value(/g" "$PAGE_FILE"
            sed -i '' -E "s/create: \(_\) => bloc,/value: bloc,/g" "$PAGE_FILE"
        else
            # Linux - use sed with extended regex
            sed -i -E "s/late final bloc = ${PASCAL_CASE}Bloc\(context\.read<${PASCAL_CASE}Repository>\(\)\);/late final ${PASCAL_CASE}Bloc bloc = context.read<${PASCAL_CASE}Bloc>();/g" "$PAGE_FILE"
            # Replace BlocProvider(create: (_) => bloc,) with BlocProvider.value(value: bloc,)
            # Handle whitespace variations
            sed -i -E "s/return BlocProvider\(/return BlocProvider.value(/g" "$PAGE_FILE"
            sed -i -E "s/create: \(_\) => bloc,/value: bloc,/g" "$PAGE_FILE"
        fi
        echo "  Updated bloc initialization and BlocProvider in page file"
    fi
fi

echo -e "${GREEN}✓ Feature '$FEATURE_NAME' created successfully!${NC}"
if [ "$GLOBAL_BLOC" = true ]; then
    echo -e "${GREEN}✓ GlobalBloc added to app.dart${NC}"
fi
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Update lib/app/router.dart to add the new route"
echo -e "  2. Review and update the generated files as needed"
echo -e "  3. Remove sample files (sample_model.dart, sample_widget.dart) if not needed"

