# X-UI Setup with Chisel Tunnel

This repository contains the necessary files and instructions to set up a secure X-UI panel with a Chisel tunnel.

## Overview

The setup consists of two main components:

1.  **A server (`vds1`)**: This server runs the `chisel` server and an `nginx` proxy.
2.  **A local machine**: This machine runs the `x-ui` panel inside a Docker container. The container also runs a `chisel` client that connects to the `chisel` server on `vds1`.

The traffic is routed as follows:

-   **X-UI Panel Access**: `https://vds1.iri1968.dpdns.org` -> `nginx` (port 443) -> `chisel` tunnel (port 8443) -> `x-ui` container (port 2053)
-   **Chisel Client Connection**: `x-ui` container -> `https://vds1.iri1968.dpdns.org/chisel-ws` -> `nginx` (port 443) -> `chisel` server (port 80)

## Server Setup (`vds1`)

1.  **Copy the files**: Copy the `server_setup.sh` and `nginx.conf` files to the `/home/x-ui-final-setup` directory on your server.
2.  **Run the setup script**: Execute the following command as `root`:

    ```bash
    bash /home/x-ui-final-setup/server_setup.sh
    ```

    This script will:
    -   Kill any running `chisel` server processes.
    -   Start a new `chisel` server on port 80.
    -   Test and reload the `nginx` configuration.

3.  **Configure Nginx**: The `nginx.conf` file provided in this repository should be placed in `/etc/nginx/sites-available/3x-ui.conf`. Make sure to create a symbolic link to it in `/etc/nginx/sites-enabled/`.

## Docker Container Setup (Local)

1.  **Build the Docker image**: From the root of this repository, run the following command:

    ```bash
    docker build -t x-ui-vds1-final .
    ```

2.  **Run the Docker container**:

    ```bash
    docker run -d --name x-ui-vds1-final-container -p 2053:2053 x-ui-vds1-final
    ```

## X-UI Configuration

1.  **Access the panel**: The `x-ui` panel will be accessible at `https://vds1.iri1968.dpdns.org`.
2.  **Login**: The default credentials are `admin`/`admin`. On the first run, the system will generate a random username and password. You can find them in the container logs:

    ```bash
    docker logs x-ui-vds1-final-container
    ```

3.  **Add Inbounds**: To add new inbounds for Vless, Vmess, and Trojan, log in to the panel and navigate to the "Inbounds" page. Click on "Add Inbound" and follow the instructions.