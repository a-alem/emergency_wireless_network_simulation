# Emergency Wireless Network Simulation
Simulatio of an emergency wireless network in case of trivial networks blackout, meant as a project for KFUPM COE 543 project.

## Premise
The main idea is to simulate a wireless network deployment in an emergency situation that resulted in complete blackout of cellular networks.

Emergency responders will deploy a mesh of access points to cover a large area so users can connect to the network that would have an uplink to WAN via sattelite for example.

## Design choices
- To simulate connections, I created a docker network for each link in the network.
- Used `/29` subnet masks for point to point instead of the typical `/30` due to Docker reserving the first host address of the network for gateway, thus making a `/30` network only has one viable host ip address instead of two.
- Continuing from that, the default route added by docker must also be removed, as the node is no longer the first host ip.
- Since this is a networking project, adding `privileged: true` directive eo espace container isolation is a must.

## Running the project
To build and runt the project:
```bash
docker compose build
docker compose up
```

You can run it in detached mode also:
```bash
docker compose up -d
```