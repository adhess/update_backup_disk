# update_backup_disk
Update your backup hard disk from your workstation hard disk.

# This script will automatise two things:

-> Any file doesn't exist in the destination_folder and exist in the source folder will be copied from the source to the destination folder.

-> Any file exists in both folders, but it's not the same file will be replaced from the source folder to the destination folder

# Commande
clear && ./update_disk.sh "destination_folder" "source_folder"

# Exemple
clear && ./update_disk.sh "/run/media/adhess/Selbez/MyData" "/run/media/adhess/6AF8235AF82323B3/MyData"
