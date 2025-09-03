# X-UI Setup with Chisel Tunnel

This repository contains the necessary files and instructions to set up a secure X-UI panel with a Chisel tunnel.

## Overview

The setup consists of two main components:

1.  **A server (`vds1`)**: This server runs the `chisel` server and an `nginx` proxy.
2.  **A local machine**: This machine runs the `x-ui` panel inside a Docker container. The container also runs a `chisel` client that connects to the `chisel` server on `vds1`.

## Interaction Diagram

```
+-----------------+      +--------------------------------+      +------------------+
|   User/Admin    |----->|      nginx (vds1:443)          |----->| x-ui (via tunnel)|
| (Browser)       |      |                                |      | (container:2053) |
+-----------------+      |                                |      +------------------+
                         |                                |
+-----------------+      |                                |
| Vmess/Vless/    |----->|      chisel-server (vds1:80)   |
| Trojan Client   |      |                                |
+-----------------+      +--------------------------------+
       ^                      ^
       |                      |
       |      +--------------------------------+
       +------|      chisel-client             |
              | (in x-ui container)            |
              +--------------------------------+
```

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
2.  **Login**: The credentials for the admin user are:
    -   **Username:** `prog10`
    -   **Password:** `04091968`

3.  **Created Inbounds**: The following inbounds have been created:

    *   **Vmess**
        *   **Remark:** Vmess
        *   **Port:** 15001
        *   **Client Email:** prog10-vmess
        *   **Client ID:** ff0c864e-efbc-45d0-a5a0-0f1aa2f08804

    *   **Vless**
        *   **Remark:** Vless
        *   **Port:** 15002
        *   **Client Email:** prog10-vless
        *   **Client ID:** a0b88969-25df-4a6e-9a52-08fb4afdb9b5

    *   **Trojan**
        *   **Remark:** Trojan
        *   **Port:** 15003
        *   **Client Email:** prog10-trojan
        *   **Password:** 5R9sNA0rws
