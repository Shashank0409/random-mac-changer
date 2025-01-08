generate_new_mac(){
	prefix=$(macchanger -l | grep -oP '([0-9a-f]{2}[:]){2}[0-9a-f]{2}' | sort -u)
	random_prefix=$(echo "$prefix" | shuf -n 1)
	end=$(hexdump -n 3 -e '3/1 "%02x:"' /dev/random | sed 's/:$//')
	echo "$random_prefix:$end"
}

random_mac1=$(generate_new_mac)
random_mac2=$(generate_new_mac)

#performed 2 times to change both the current mac address and new mac address
sudo macchanger eth0 -m $random_mac1
sudo macchanger eth0 -m $random_mac2
