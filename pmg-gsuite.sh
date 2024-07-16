```#!/bin/bash
while true
do
# Fetch mynetworks configuration using pmgsh
mynetworks_output=$(pmgsh get /config/mynetworks/)

if [ -z "$mynetworks_output" ]; then
    echo "Failed to fetch mynetworks configuration. Exiting."
    exit 1
fi

# Parse CIDR values from JSON output
cidr_list=$(echo "$mynetworks_output" | jq -r '.[].cidr')

if [ -z "$cidr_list" ]; then
    echo "No CIDR found in mynetworks configuration. Exiting."
    #exit 0
fi

echo "CIDR list:"
echo "$cidr_list"

# Iterate over each CIDR and delete it using pmgsh
for cidr in $cidr_list; do
    echo "Deleting CIDR: $cidr"
    pmgsh delete "/config/mynetworks/${cidr}"
done
# Function to query SPF record and extract includes and IP addresses
query_spf_and_include() {
    local domain=$1
    local dns_server=$2

    local result=$(nslookup -q=TXT "$domain" "$dns_server" | grep -oE 'v=spf1 .*')

    # Extract include directives
    local includes=$(echo "$result" | grep -oE 'include:[^ ]+' | cut -d':' -f2)

    # Extract ip4 and ip6 addresses
    local ip4_addresses=$(echo "$result" | grep -oE 'ip4:[^ ]+' | cut -d':' -f2)
    local ip6_addresses=$(echo "$result" | grep -oE 'ip6:[^ ]+' | cut -d':' -f2)



    # Print ip4 addresses
    for ip4 in $ip4_addresses; do
        echo "ip4: $ip4"
        pmgsh create /config/mynetworks --cidr $ip4 --comment "GOOGLE"
    done


    # Loop through each include directive and query recursively
    for include in $includes; do
        query_spf_and_include "$include" "$dns_server"
    done
}

# Initial domain and DNS server
initial_domain="_spf.google.com"
dns_server="8.8.8.8"

# Call the function with initial parameters
query_spf_and_include "$initial_domain" "$dns_server"


echo "Sleeping for 8 hours..."
sleep 5d
done```
