# X-UI Docker Setup with Chisel Tunnel and Nginx

This project contains the necessary files and instructions to run the `3x-ui` panel in a Docker container and expose it securely via a Chisel tunnel and an Nginx reverse proxy.

## Components

1.  **`Dockerfile`**: Builds a Debian-based Docker image that includes:
    *   The `3x-ui` panel.
    *   The `chisel` client (v1.10.1).
    *   A startup script that runs both `x-ui` and the `chisel` client simultaneously, with auto-restart for the chisel tunnel.

2.  **`nginx.conf`**: A working Nginx server block configuration to be used on the public-facing server (`vds1`). It handles SSL termination (HTTPS) and reverse proxies traffic to the Chisel tunnel endpoint.

## Deployment Instructions

### 1. Server Setup (`vds1.iri1968.dpdns.org`)

a. **Place Nginx Configuration:**
   Copy the contents of `nginx.conf` to `/etc/nginx/sites-available/marzban.conf` (or your chosen config file). Ensure it's enabled, typically via a symlink in `/etc/nginx/sites-enabled/`.

b. **Run Chisel Server:**
   The Chisel server must be running to accept connections from the client in the Docker container. This command should be run in the background.
   ```bash
   nohup chisel server --port 80 --reverse > /dev/null 2>&1 &
   ```

c. **Run Nginx:**
   Make sure Nginx is running with the correct configuration.
   ```bash
   sudo nginx -t
   sudo systemctl start nginx # or reload
   ```

### 2. Local Machine Setup (Where Docker is)

a. **Build the Docker Image:**
   From inside this project directory, run:
   ```bash
   docker build -t x-ui-container .
   ```

b. **Run the Docker Container:**
   ```bash
   docker run -d --name x-ui-container x-ui-container
   ```

## Access

Once both the server and the local container are running, the `x-ui` panel will be available at:

**`https://vds1.iri1968.dpdns.org`**
