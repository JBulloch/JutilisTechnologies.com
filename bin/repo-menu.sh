#!/bin/bash
# Interactive menu for JutilisTechnologies.com repository management
set -e

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display the main menu
show_main_menu() {
  clear
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}   JutilisTechnologies.com Menu${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo ""
  echo "1) Dev"
  echo "2) Sandbox"
  echo "3) Production"
  echo "q) Quit"
  echo ""
  echo -n "Select an environment: "
}

# Function to display the dev submenu
show_dev_menu() {
  clear
  echo -e "${GREEN}================================${NC}"
  echo -e "${GREEN}   Dev Environment Menu${NC}"
  echo -e "${GREEN}================================${NC}"
  echo ""
  echo "1) Setup"
  echo "2) Start Services (Docker)"
  echo "3) Stop Services (Docker)"
  echo "4) Start Server"
  echo "5) Seed DB"
  echo "6) Run Tests"
  echo "7) Format Code"
  echo "8) Check Code Quality"
  echo "b) Back to Main Menu"
  echo "q) Quit"
  echo ""
  echo -n "Select an option: "
}

# Function to display the sandbox submenu
show_sandbox_menu() {
  clear
  echo -e "${YELLOW}================================${NC}"
  echo -e "${YELLOW}   Sandbox Environment Menu${NC}"
  echo -e "${YELLOW}================================${NC}"
  echo ""
  echo "No options available yet."
  echo ""
  echo "b) Back to Main Menu"
  echo "q) Quit"
  echo ""
  echo -n "Select an option: "
}

# Function to display the production submenu
show_production_menu() {
  clear
  echo -e "${RED}================================${NC}"
  echo -e "${RED}   Production Environment Menu${NC}"
  echo -e "${RED}================================${NC}"
  echo ""
  echo "1) Deploy (Patch)"
  echo "2) Deploy (Minor)"
  echo "3) Deploy (Major)"
  echo "4) Check Production Status"
  echo "5) View Logs"
  echo "6) Connect to Database"
  echo "7) Run Migrations"
  echo "b) Back to Main Menu"
  echo "q) Quit"
  echo ""
  echo -n "Select an option: "
}

# Function to run setup
run_setup() {
  echo -e "\n${GREEN}Running setup...${NC}\n"
  cd "$PROJECT_ROOT"
  bash ./bin/setup.sh
  echo -e "\n${GREEN}Setup complete!${NC}"
  read -p "Press Enter to continue..."
}

# Function to start services
start_services() {
  echo -e "\n${GREEN}Starting development services (Docker)...${NC}\n"
  cd "$PROJECT_ROOT"
  docker compose -f docker-compose.yml up -d
  echo -e "\n${GREEN}Services started!${NC}"
  echo -e "${BLUE}PostgreSQL is running on port 5432${NC}"
  read -p "Press Enter to continue..."
}

# Function to stop services
stop_services() {
  echo -e "\n${YELLOW}Stopping development services...${NC}\n"
  cd "$PROJECT_ROOT"
  docker compose -f docker-compose.yml down
  echo -e "\n${YELLOW}Services stopped!${NC}"
  read -p "Press Enter to continue..."
}

# Function to start server
start_server() {
  echo -e "\n${GREEN}Starting Phoenix server...${NC}\n"
  echo -e "${BLUE}Server will be available at http://localhost:4000${NC}\n"
  cd "$PROJECT_ROOT"
  mix phx.server
}

# Function to run seeds
run_seeds() {
  echo -e "\n${GREEN}Seed the development database${NC}\n"
  echo "This will run: MIX_ENV=dev mix run priv/repo/seeds.exs"
  read -p "Proceed? [y/N]: " confirm
  case "$confirm" in
    y|Y)
      cd "$PROJECT_ROOT"
      MIX_ENV=dev mix run priv/repo/seeds.exs || {
        echo -e "\n${RED}Seeding failed. Check output above for errors.${NC}";
        read -p "Press Enter to continue...";
        return 1;
      }
      echo -e "\n${GREEN}Seeding complete.${NC}"
      read -p "Press Enter to continue..."
      ;;
    *)
      echo -e "\n${YELLOW}Cancelled.${NC}"
      read -p "Press Enter to continue..."
      ;;
  esac
}

# Function to run tests
run_tests() {
  echo -e "\n${GREEN}Running tests...${NC}\n"
  cd "$PROJECT_ROOT"
  mix test || {
    echo -e "\n${RED}Tests failed. Check output above for errors.${NC}";
    read -p "Press Enter to continue...";
    return 1;
  }
  echo -e "\n${GREEN}All tests passed!${NC}"
  read -p "Press Enter to continue..."
}

# Function to format code
format_code() {
  echo -e "\n${GREEN}Formatting code...${NC}\n"
  cd "$PROJECT_ROOT"
  mix format
  echo -e "\n${GREEN}Code formatted!${NC}"
  read -p "Press Enter to continue..."
}

# Function to check code quality
check_quality() {
  echo -e "\n${GREEN}Checking code quality...${NC}\n"
  cd "$PROJECT_ROOT"

  echo -e "${BLUE}Running formatter check...${NC}"
  mix format --check-formatted || echo -e "${YELLOW}Some files need formatting${NC}"

  echo -e "\n${BLUE}Running Credo...${NC}"
  mix credo --strict || echo -e "${YELLOW}Credo found some issues${NC}"

  echo -e "\n${BLUE}Running Dialyzer...${NC}"
  mix dialyzer || echo -e "${YELLOW}Dialyzer found some issues${NC}"

  echo -e "\n${GREEN}Quality check complete!${NC}"
  read -p "Press Enter to continue..."
}

# Dev menu handler
handle_dev_menu() {
  while true; do
    show_dev_menu
    read choice
    case $choice in
      1)
        run_setup
        ;;
      2)
        start_services
        ;;
      3)
        stop_services
        ;;
      4)
        start_server
        ;;
      5)
        run_seeds
        ;;
      6)
        run_tests
        ;;
      7)
        format_code
        ;;
      8)
        check_quality
        ;;
      b|B)
        return
        ;;
      q|Q)
        echo -e "\n${BLUE}Goodbye!${NC}"
        exit 0
        ;;
      *)
        echo -e "\n${RED}Invalid option. Please try again.${NC}"
        read -p "Press Enter to continue..."
        ;;
    esac
  done
}

# Sandbox menu handler
handle_sandbox_menu() {
  while true; do
    show_sandbox_menu
    read choice
    case $choice in
      b|B)
        return
        ;;
      q|Q)
        echo -e "\n${BLUE}Goodbye!${NC}"
        exit 0
        ;;
      *)
        echo -e "\n${RED}Invalid option. Please try again.${NC}"
        read -p "Press Enter to continue..."
        ;;
    esac
  done
}

# Function to deploy (patch)
deploy_patch() {
  echo -e "\n${RED}Deploying with PATCH version bump...${NC}\n"
  cd "$PROJECT_ROOT"
  bash ./bin/deploy.sh patch
  echo -e "\n${GREEN}Deploy complete!${NC}"
  read -p "Press Enter to continue..."
}

# Function to deploy (minor)
deploy_minor() {
  echo -e "\n${RED}Deploying with MINOR version bump...${NC}\n"
  cd "$PROJECT_ROOT"
  bash ./bin/deploy.sh minor
  echo -e "\n${GREEN}Deploy complete!${NC}"
  read -p "Press Enter to continue..."
}

# Function to deploy (major)
deploy_major() {
  echo -e "\n${RED}Deploying with MAJOR version bump...${NC}\n"
  cd "$PROJECT_ROOT"
  bash ./bin/deploy.sh major
  echo -e "\n${GREEN}Deploy complete!${NC}"
  read -p "Press Enter to continue..."
}

# Function to check production status
check_prod_status() {
  echo -e "\n${BLUE}Checking production status...${NC}\n"
  cd "$PROJECT_ROOT"
  fly status
  echo ""
  read -p "Press Enter to continue..."
}

# Function to view logs
view_logs() {
  echo -e "\n${BLUE}Tailing production logs...${NC}"
  echo -e "${YELLOW}Press Ctrl+C to stop${NC}\n"
  cd "$PROJECT_ROOT"
  fly logs
  echo ""
  read -p "Press Enter to continue..."
}

# Function to connect to database
connect_db() {
  echo -e "\n${BLUE}Connecting to production database...${NC}\n"
  cd "$PROJECT_ROOT"
  fly postgres connect -a jutilis-db
  echo ""
  read -p "Press Enter to continue..."
}

# Function to run migrations
run_migrations() {
  echo -e "\n${RED}Running production migrations...${NC}\n"
  echo -e "${YELLOW}WARNING: This will modify the production database!${NC}"
  read -p "Are you sure you want to continue? [y/N]: " confirm
  case "$confirm" in
    y|Y)
      cd "$PROJECT_ROOT"
      fly ssh console -C "/app/bin/migrate"
      echo -e "\n${GREEN}Migrations complete!${NC}"
      read -p "Press Enter to continue..."
      ;;
    *)
      echo -e "\n${YELLOW}Cancelled.${NC}"
      read -p "Press Enter to continue..."
      ;;
  esac
}

# Production menu handler
handle_production_menu() {
  while true; do
    show_production_menu
    read choice
    case $choice in
      1)
        deploy_patch
        ;;
      2)
        deploy_minor
        ;;
      3)
        deploy_major
        ;;
      4)
        check_prod_status
        ;;
      5)
        view_logs
        ;;
      6)
        connect_db
        ;;
      7)
        run_migrations
        ;;
      b|B)
        return
        ;;
      q|Q)
        echo -e "\n${BLUE}Goodbye!${NC}"
        exit 0
        ;;
      *)
        echo -e "\n${RED}Invalid option. Please try again.${NC}"
        read -p "Press Enter to continue..."
        ;;
    esac
  done
}

# Main menu loop
main() {
  while true; do
    show_main_menu
    read choice
    case $choice in
      1)
        handle_dev_menu
        ;;
      2)
        handle_sandbox_menu
        ;;
      3)
        handle_production_menu
        ;;
      q|Q)
        echo -e "\n${BLUE}Goodbye!${NC}"
        exit 0
        ;;
      *)
        echo -e "\n${RED}Invalid option. Please try again.${NC}"
        read -p "Press Enter to continue..."
        ;;
    esac
  done
}

# Run the main menu
main
