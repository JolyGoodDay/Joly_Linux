# Networking Commands Cheat Sheet

## IP Commands

### Display Network Information
```bash
ip addr show      # Show IP addresses
ip link           # Show link layer information

Netcat (nc) Commands
Listen for Incoming Connections

nc -l -p <port>       # Listen on a specific port
nc -w3 <ip> <port>    # Listen for a connection from an IP on a specific port

Banner Grabbing

echo | nc -v -n -w1 <ip> <port min>-<port max>   # Retrieve banners from a range of ports

Port Scanning

nc -v -n -z -w1 <ip> <port min>-<port max>   # Scan a range of ports on a target IP

Perform HTTP Request

printf 'GET / HTTP/1.0\n\n' | nc <server> <port>

Network Interface Management
Display Network Interface Information

ip link          # Show link layer information
ifconfig         # Show all network interfaces and their statuses

Bring Network Interface Down and Up

ifdown eth0      # Disable interface eth0
ifup eth0        # Enable interface eth0

Alternatively, using ifconfig:

ifconfig eth0 down   # Disable interface eth0
ifconfig eth0 up     # Enable interface eth0

Restart Network Services
Restart an Individual Network Interface

ifdown eth0 && ifup eth0   # Restart eth0 interface

Restart All Network Services

service network-manager restart   # Restart network manager service

Or manually restart:

cd /etc/init.d
./networking restart

Configure Network Interfaces
Obtain an IP via DHCP

dhclient   # Request a DHCP lease

Configure Static or DHCP in /etc/network/interfaces

Ensure the NICs are properly configured by editing:

sudo nano /etc/network/interfaces

Example configuration for a static IP:

auto eth0
iface eth0 inet static
  address 192.168.1.100
  netmask 255.255.255.0
  gateway 192.168.1.1

For DHCP:

auto eth0
iface eth0 inet dhcp

Save changes and restart the network:

service networking restart

Troubleshooting

Use these commands to diagnose and debug network issues:

ip addr show             # Check assigned IP addresses
ping <ip>                # Test connectivity to an IP
traceroute <ip>          # Trace route to destination
netstat -tulnp           # Show listening ports
sudo systemctl restart networking  # Restart network service