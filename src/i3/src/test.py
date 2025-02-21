import logging
from pyroute2 import NDB
import pandas as pd

def get_namespace_interfaces(namespace: str | None = None) -> list[dict]:
    """
    Gather network interface information for a specific namespace using pyroute2 NDB.

    Args:
        namespace (str | None): Network namespace. Use None for the default namespace.

    Returns:
        list[dict]: A list of dictionaries containing interface data.
    """
    try:
        ndb = NDB(netns=namespace) if namespace else NDB()
    except Exception as e:
        logging.warning(f"Failed to access namespace {namespace or 'default'}: {e}")
        return []

    data = []
    try:
        for iface in ndb.interfaces:
            iface_data = {
                "namespace": namespace or "default",
                "interface": iface.ifname,
                "inet_addr": iface.ipaddr[0]["address"] if iface.ipaddr else None,
                "inet6_addr": iface.ip6addr[0]["address"] if iface.ip6addr else None,
                "hwaddr": iface.address,
                "bcast": iface.broadcast,
                "mask": iface.ipaddr[0]["prefixlen"] if iface.ipaddr else None,
            }
            data.append(iface_data)
    except Exception as e:
        logging.warning(f"Error retrieving interfaces for namespace {namespace or 'default'}: {e}")
    finally:
        ndb.close()

    return data

def collect_all_namespaces_data() -> pd.DataFrame:
    """
    Collect network interface information for all namespaces and the default namespace.

    Returns:
        pd.DataFrame: A DataFrame containing all collected data.
    """
    try:
        with NDB() as ndb:
            namespaces = [ns for ns in ndb.netns.list()] + [None]
    except Exception as e:
        logging.warning(f"Failed to list namespaces: {e}")
        namespaces = [None]

    all_data = []
    for namespace in namespaces:
        all_data.extend(get_namespace_interfaces(namespace))

    return pd.DataFrame(all_data)

# Main script
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    network_data = collect_all_namespaces_data()

    if not network_data.empty:
        print(network_data.to_string(index=False))
    else:
        print("No network information available.")
