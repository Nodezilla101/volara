# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

# ASCII logo
display_ascii() {
echo -e " ${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET}"
echo -e " ${MAGENTA}~ ${RED} _   _  ___  ____  _____ ________ _     _        _    _  ___  _  ${MAGENTA}~"
echo -e " ${MAGENTA}~ ${GREEN}| \\ | |/ _ \\|  _ \\| ____|__  /_ _| |   | |      / \\  / |/ _ \\/ | ${MAGENTA}~"
echo -e " ${MAGENTA}~ ${YELLOW}|  \\| | | | | | | |  _|   / / | || |   | |     / _ \\ | | | | | | ${MAGENTA}~"
echo -e " ${MAGENTA}~ ${CYAN}| |\\  | |_| | |_| | |___ / /_ | || |___| |___ / ___ \\| | |_| | | ${MAGENTA}~"
echo -e " ${MAGENTA}~ ${BLUE}|_| \\_|\\___/|____/|_____/____|___|_____|_____/_/   \\_\\_|\\___/|_| ${MAGENTA}~"
echo -e " ${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET}"
echo -e " ${MAGENTA}🚀 Join Nodzillaz on Telegram: https://t.me/nodezilla101 ${RESET}"
echo -e " ${MAGENTA}📢 Join Nodzillaz on Discord: https://discord.gg/RAEnTZSEVh ${RESET}"
}

# Keywords and Docker configurations
KEYWORD="volara"
SPECIFIC_IMAGE="volara/miner"

show_message() {
    echo -e "${MAGENTA}$1${RESET}"
}

stop_containers_by_keyword() {
    local containers=$(sudo docker ps --format '{{.Names}}' | grep "$KEYWORD")
    if [[ -n "$containers" ]]; then
        for container in $containers; do
            show_message "🛑 Stopping container $container..."
            sudo docker stop $container
        done
    else
        show_message "✅ No running containers found with the keyword '$KEYWORD'."
    fi
}

remove_containers_by_keyword() {
    local containers=$(sudo docker ps -a --format '{{.Names}}' | grep "$KEYWORD")
    if [[ -n "$containers" ]]; then
        for container in $containers; do
            show_message "🗑️ Removing container $container..."
            sudo docker rm $container
        done
    else
        show_message "✅ No containers found with the keyword '$KEYWORD'."
    fi
}

remove_images_by_keyword() {
    local images=$(sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep "$KEYWORD")
    if [[ -n "$images" ]]; then
        for image in $images; do
            show_message "🗑️ Removing image $image..."
            sudo docker rmi -f $image
        done
    else
        show_message "✅ No images found with the keyword '$KEYWORD'."
    fi

    local specific_images=$(sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep "$SPECIFIC_IMAGE")
    if [[ -n "$specific_images" ]]; then
        for image in $specific_images; do
            show_message "🗑️ Removing specific image $image..."
            sudo docker rmi -f $image
        done
    else
        show_message "✅ Specific image '$SPECIFIC_IMAGE' not found."
    fi
}

cleanup_docker() {
    read -p "Do you want to clean up all unused Docker data? (y/n): " CONFIRM
    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
        show_message "🧹 Cleaning up unused Docker data..."
        sudo docker system prune -a -f
    else
        show_message "❌ Docker cleanup cancelled."
    fi
}

download_and_run_script() {
    local url="https://raw.githubusercontent.com/shareithub/volara-new/refs/heads/main/del-volara.sh"
    show_message "📥 Downloading and running script from $url..."
    curl -sSL $url | sudo bash
    show_message "✅ Script from URL has been executed."
}

run_additional_script() {
    read -p "Do you want to run the additional volara.sh script? (y/n): " CONFIRM
    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
        show_message "🚀 Running additional script for volara.sh..."
        [ -f "volara.sh" ] && rm volara.sh
        curl -s -o volara.sh https://raw.githubusercontent.com/volaradlp/minercli/refs/heads/main/run_docker.sh
        chmod +x volara.sh
        ./volara.sh
        show_message "✅ volara.sh script has been executed."
    else
        show_message "❌ Execution of additional script cancelled."
    fi
}

# Main execution
display_ascii
stop_containers_by_keyword
remove_containers_by_keyword
remove_images_by_keyword
cleanup_docker
download_and_run_script
run_additional_script

show_message "✨ All processes completed."
