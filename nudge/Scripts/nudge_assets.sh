if [ -d "/Users/Shared/nudge/" ] ; then
    echo "Nudge directory exists, skipping creation"
else
    echo "Creating Directory: /Users/Shared/nudge/"
    mkdir -p "/Users/Shared/nudge/"

    if [ -d "/Users/Shared/nudge/" ] ; then
        echo "Asset directory exists, Good to go."
    else
        echo "Asset directory does not exist, something went wrong."
        exit 1
    fi
fi

#Grab latest asset images
echo "Downloading latest asset images"
/usr/bin/curl "https://raw.githubusercontent.com/khulnasoft-lab/macOS-tweaks/master/nudge/Assets/khulnasoftmdm_dk.png" -o "/Users/Shared/nudge/khulnasoftmdm_dk.png"
/usr/bin/curl "https://raw.githubusercontent.com/khulnasoft-lab/macOS-tweaks/master/nudge/Assets/khulnasoftmdm_lt.png" -o "/Users/Shared/nudge/khulnasoftmdm_lt.png"
