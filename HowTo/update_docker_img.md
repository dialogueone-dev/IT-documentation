> # Updating a Docker Image

> This is useful for when you may need to update Ninox.

Updating a Docker image without losing the data stored in a volume is a common concern. Here's a step-by-step guide to help you update the image without losing the volume data.

## Introduction

When updating a Docker image, especially for a SaaS application, it is crucial to ensure that the data stored in Docker volumes is preserved. Volumes are designed to persist data across container lifecycles, but care must be taken to ensure that they are properly managed during updates.

## Methodology

1. **Identify the Volume**: First, identify the volume that you want to preserve. You can list all volumes using the following command:

   ```bash
   docker volume ls
   ```

2. **Stop the Running Container**: If the container is running, you'll need to stop it before updating the image. Use the following command:

   ```bash
   docker stop <container_name>
   ```

3. **Pull the New Image**: Pull the new image that you want to update to:

   ```bash
   docker pull <image_name>:<tag>
   ```

4. **Create a New Container with the Existing Volume**: When creating a new container with the updated image, make sure to attach the existing volume. Here's an example command:

   ```bash
   docker run -d --name <new_container_name> -v <volume_name>:/path/in/container <image_name>:<tag>
   ```

   Make sure to replace `<volume_name>` with the name of the volume you want to preserve, and `/path/in/container` with the path where the volume should be mounted in the container.

5. **Verify the Data**: Once the new container is running, verify that the data in the volume is intact.

## Conclusion

By carefully managing the lifecycle of the container and explicitly attaching the existing volume to the new container, you can update a Docker image without losing the data stored in the volume. This approach ensures that the SaaS application continues to have access to its persistent data, even after an update.

Remember to follow the best practices for managing Docker containers and volumes, including proper testing in a development or staging environment before applying changes to a production system. This will help in identifying any potential issues early and ensuring a smooth update process.
