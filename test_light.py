import os
from ola.ClientWrapper import ClientWrapper

# Set the OLA RPC port
os.environ["OLA_RPC_PORT"] = "9019"

# Initialize the ClientWrapper
wrapper = ClientWrapper()
client = wrapper.Client()

# Your DMX data
data = bytearray([255, 0, 0, 0])  # Example DMX data
# Convert the DMX data to a string
data_str = data.decode()

# Send DMX data
client.SendDmx(1, data_str, lambda status: print('Sent' if status.Succeeded() else 'Failed'))
wrapper.Run()
