#!/usr/bin/env bash
# Cleanup script for NixOS rebuild and home-manager generations
# Usage:
#   cleanup-generations.sh       - Keep last 3 generations for both system and home-manager
#   cleanup-generations.sh -f    - Delete ALL old generations (nuclear option)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
FORCE_MODE=false
KEEP_SYSTEM=3
KEEP_HOME=3

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE_MODE=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown parameter: $1${NC}"
            echo "Usage: $0 [-f|--force]"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}          NixOS Generation Cleanup Tool${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo

# Function to count generations
count_generations() {
    local profile=$1
    if [[ -d "$profile" ]]; then
        ls -d ${profile}-*-link 2>/dev/null | wc -l
    else
        echo "0"
    fi
}

# Show current status
echo -e "${YELLOW}Current status:${NC}"

# Count system generations
SYSTEM_GEN_COUNT=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l)
echo -e "  System generations: ${GREEN}${SYSTEM_GEN_COUNT}${NC}"

# Count home-manager generations
HM_PROFILE="${HOME}/.local/state/nix/profiles/home-manager"
if [[ -L "$HM_PROFILE" ]] || [[ -e "$HM_PROFILE" ]]; then
    HM_GEN_COUNT=$(nix-env --list-generations --profile "$HM_PROFILE" 2>/dev/null | wc -l)
    echo -e "  Home-manager generations: ${GREEN}${HM_GEN_COUNT}${NC}"
else
    HM_GEN_COUNT=0
    echo -e "  Home-manager generations: ${YELLOW}0 (profile not found)${NC}"
fi

echo

# Confirmation prompt
if [[ "$FORCE_MODE" == true ]]; then
    echo -e "${RED}⚠️  FORCE MODE: Will delete ALL old generations!${NC}"
    echo -e "${YELLOW}This will keep only the current generation for both system and home-manager.${NC}"
else
    echo -e "${YELLOW}Standard mode: Will keep last ${KEEP_SYSTEM} system generations and last ${KEEP_HOME} home-manager generations.${NC}"
fi

echo
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
    exit 0
fi

echo

# Cleanup system generations
echo -e "${BLUE}━━━ System Generations ━━━${NC}"
if [[ "$FORCE_MODE" == true ]]; then
    echo "Deleting all old system generations..."
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
    echo -e "${GREEN}✓ Deleted all old system generations${NC}"
else
    echo "Keeping last ${KEEP_SYSTEM} generations, deleting the rest..."
    # Get all generations except the last N
    GENS_TO_DELETE=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | \
        awk '{print $1}' | head -n -${KEEP_SYSTEM})

    if [[ -n "$GENS_TO_DELETE" ]]; then
        for gen in $GENS_TO_DELETE; do
            echo "  Deleting generation ${gen}..."
            sudo nix-env --delete-generations ${gen} --profile /nix/var/nix/profiles/system
        done
        echo -e "${GREEN}✓ Deleted old system generations (kept last ${KEEP_SYSTEM})${NC}"
    else
        echo -e "${YELLOW}No old system generations to delete${NC}"
    fi
fi

echo

# Cleanup home-manager generations
echo -e "${BLUE}━━━ Home-Manager Generations ━━━${NC}"
if [[ -L "$HM_PROFILE" ]] || [[ -e "$HM_PROFILE" ]]; then
    if [[ "$FORCE_MODE" == true ]]; then
        echo "Deleting all old home-manager generations..."
        nix-env --delete-generations old --profile "$HM_PROFILE"
        echo -e "${GREEN}✓ Deleted all old home-manager generations${NC}"
    else
        echo "Keeping last ${KEEP_HOME} generations, deleting the rest..."
        # Get all generations except the last N
        GENS_TO_DELETE=$(nix-env --list-generations --profile "$HM_PROFILE" | \
            awk '{print $1}' | head -n -${KEEP_HOME})

        if [[ -n "$GENS_TO_DELETE" ]]; then
            for gen in $GENS_TO_DELETE; do
                echo "  Deleting generation ${gen}..."
                nix-env --delete-generations ${gen} --profile "$HM_PROFILE"
            done
            echo -e "${GREEN}✓ Deleted old home-manager generations (kept last ${KEEP_HOME})${NC}"
        else
            echo -e "${YELLOW}No old home-manager generations to delete${NC}"
        fi
    fi
else
    echo -e "${YELLOW}Home-manager profile not found, skipping...${NC}"
fi

echo

# Run garbage collection
echo -e "${BLUE}━━━ Garbage Collection ━━━${NC}"
echo "Running nix-store garbage collection..."
if [[ "$FORCE_MODE" == true ]]; then
    # More aggressive GC in force mode
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
else
    sudo nix-collect-garbage
    nix-collect-garbage
fi
echo -e "${GREEN}✓ Garbage collection complete${NC}"

echo

# Show final status
echo -e "${BLUE}━━━ Final Status ━━━${NC}"

SYSTEM_GEN_COUNT_AFTER=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l)
echo -e "  System generations: ${GREEN}${SYSTEM_GEN_COUNT_AFTER}${NC}"

if [[ -L "$HM_PROFILE" ]] || [[ -e "$HM_PROFILE" ]]; then
    HM_GEN_COUNT_AFTER=$(nix-env --list-generations --profile "$HM_PROFILE" 2>/dev/null | wc -l)
    echo -e "  Home-manager generations: ${GREEN}${HM_GEN_COUNT_AFTER}${NC}"
fi

# Calculate space saved (approximate)
echo
echo -e "${GREEN}✓ Cleanup complete!${NC}"
echo -e "${YELLOW}Note: Run 'df -h /nix/store' to see current store size${NC}"
